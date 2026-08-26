"""Local logging proxy for the Roblox sandbox smoke-run.

Architecture §7: a local process in front of `<BaseUrl>`. Records every
request, forwards to live endpoints (default gametest1.robloxlabs.com),
returns synthetic responses for the join handshake so a headless
two-sided smoke can run without depending on a live game.

The engine hits these URLs during a join (see Application.cpp.md /
Network/INDEX.md):
  - /login/v1                (renewLoginAsync)        -> {"IsValid":true}
  - /Game/PlaceLauncher.ashx (request=RequestGame)    -> status=2
  - /Game/join.ashx          (fetchJoinScriptAsync)   -> start(...) Lua body
  - /universes/validate-place-join                     -> "true"
  - /Game/ClientSettings.ashx (ClientAppSettings)      -> passthrough live
  - everything else                                       passthrough live

Logging is line-prefixed `[req] URL -> STATUS` and `[req-body]`, written
to --log, stderr, and stdout. Pass --dry-run to print the bound URL
then exit 0 (used by the smoke step to verify reachability first).
"""

import argparse
import http.server
import json
import socketserver
import sys
import threading
import time
import urllib.parse
import urllib.request


JOIN_SCRIPT_TEMPLATE = (
    "game:GetService('RunService'):BindToRenderStep('sandbox', 200, function() end)\n"
    "local ts = game:GetService('HttpService')\n"
    "print('SANDBOX_JOIN_SCRIPT_EXECUTED at ' .. tostring(workspace.DistributedGameTime))\n"
    "local s = Instance.new('Sound', workspace); s.SoundId='rbxasset://sounds/uuhhh.mp3'\n"
    "game:service('Players').LocalPlayer.Chatted:connect(function(m) print('CHAT',m) end)\n"
)


class Handler(http.server.BaseHTTPRequestHandler):
    upstream = "http://www.gametest1.robloxlabs.com"
    log_path = None

    def log_message(self, format, *args):  # noqa: A002 (override signature)
        return  # silence default stderr noise; we log explicitly

    def do_GET(self):  # noqa: N802
        self._serve()

    def do_POST(self):  # noqa: N802
        length = int(self.headers.get("Content-Length", "0") or "0")
        self._body = self.rfile.read(length) if length else b""
        self._serve()

    def _serve(self):
        path = urllib.parse.urlsplit(self.path).path
        body = getattr(self, "_body", b"") or b""
        log = f"[req] {self.command} {self.path} (body={len(body)}B)\n"
        sys.stderr.write(log)
        if self.log_path:
            with open(self.log_path, "a", encoding="utf-8") as f:
                f.write(log)
                f.write(f"  headers: {dict(self.headers)}\n")
                if body:
                    f.write(f"  body: {body[:512]!r}\n")

        synth = self._synthesize(path)
        if synth is not None:
            self._send(synth)
            return
        self._forward()

    def _synthesize(self, path: str):
        if path == "/login/v1" or path.endswith("/login/v1"):
            return 200, {"application/json": json.dumps({"IsValid": True}).encode()}, "application/json"
        if path.endswith("/Game/PlaceLauncher.ashx"):
            qs = urllib.parse.parse_qs(urllib.parse.urlsplit(self.path).query)
            place_id = qs.get("placeId", ["1818"])[0]
            auth = "http://127.0.0.1:" + str(Handler.listen_port) + "/login/v1"
            ticket = "sandbox-ticket-" + str(int(time.time()))
            join = "http://127.0.0.1:" + str(Handler.listen_port) + "/Game/join.ashx"
            payload = json.dumps({
                "status": 2,
                "authenticationUrl": auth,
                "authenticationTicket": ticket,
                "joinScriptUrl": join,
                "placeId": int(place_id) if place_id.isdigit() else 1818,
            }).encode()
            return 200, {"application/json": payload}, "application/json"
        if path.endswith("/Game/join.ashx") or path == "/Game/join.ashx":
            return 200, JOIN_SCRIPT_TEMPLATE.encode(), "text/plain"
        if path.endswith("/universes/validate-place-join") or path == "/universes/validate-place-join":
            return 200, b"true", "text/plain"
        return None

    def _forward(self):
        url = self.upstream + self.path
        try:
            req = urllib.request.Request(url, data=getattr(self, "_body", None) or None, method=self.command)
            for k, v in self.headers.items():
                if k.lower() not in ("host", "content-length"):
                    req.add_header(k, v)
            with urllib.request.urlopen(req, timeout=10) as r:
                self.send_response(r.status)
                for k, v in r.headers.items():
                    if k.lower() in ("content-type", "content-length", "server", "date"):
                        self.send_header(k, v)
                self.end_headers()
                self.wfile.write(r.read())
        except Exception as e:  # noqa: BLE001
            sys.stderr.write(f"[fwd-err] {self.path}: {e}\n")
            self._send((502, str(e).encode(), "text/plain"))

    def _send(self, triple):
        status, body, ctype = triple
        self.send_response(status)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)


class ThreadingServer(socketserver.ThreadingMixIn, http.server.HTTPServer):
    daemon_threads = True
    allow_reuse_address = True


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--port", type=int, default=64989)
    ap.add_argument("--log", default=None)
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    Handler.listen_port = args.port
    Handler.log_path = args.log
    if args.dry_run:
        print(f"http://127.0.0.1:{args.port}/")
        return 0

    srv = ThreadingServer(("127.0.0.1", args.port), Handler)
    sys.stderr.write(f"[proxy] listening on 127.0.0.1:{args.port}\n")
    try:
        srv.serve_forever()
    except KeyboardInterrupt:
        pass
    return 0


if __name__ == "__main__":
    sys.exit(main())
