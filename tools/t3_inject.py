#!/usr/bin/env python3
"""T3 target-script injector for RCCService's SOAP interface.

Feeds one Lua file to a running RCCService.exe (-Console) as an OpenJob
whose script IS the target source, sent verbatim. Exactly one injection
mechanism (OpenJob over SOAP 1.1 document/literal, the engine's own
server interface); no fallback path, loud failure on transport errors.

Modes:
  --probe   poll HelloWorld until the server answers or --deadline passes
  --open    POST OpenJob(job, name, file) once. Any well-formed SOAP reply
            (result or Fault) is transport success: a script that errors
            still executed (load/resume records exist). Whether the target
            really ran is enforced by --verify, never assumed here.
  --verify  check capture.jsonl for the target chunk (load with bytes>0,
            non-empty loadSource) and a clean lift record.

Exit codes: 0 ok (for --open: executed, even on script Fault),
            1 infrastructure or verification failure.
"""
import re
import sys
import time
import urllib.request
import urllib.error
from xml.sax.saxutils import escape

NS = "http://roblox.com/"
SOAP_NS = "http://schemas.xmlsoap.org/soap/envelope/"


def envelope(body):
    return (
        '<?xml version="1.0" encoding="utf-8"?>\n'
        '<soap:Envelope xmlns:soap="%s" xmlns:ns1="%s">\n'
        "<soap:Body>\n%s\n</soap:Body>\n</soap:Envelope>"
    ) % (SOAP_NS, NS, body)


def hello_body():
    return "<ns1:HelloWorld></ns1:HelloWorld>"


def open_body(job, name, source):
    return (
        "<ns1:OpenJob>\n"
        "<ns1:job><ns1:id>%s</ns1:id>"
        "<ns1:expirationInSeconds>600</ns1:expirationInSeconds>"
        "<ns1:category>0</ns1:category>"
        "<ns1:cores>1</ns1:cores></ns1:job>\n"
        "<ns1:script><ns1:name>%s</ns1:name>"
        "<ns1:script>%s</ns1:script></ns1:script>\n"
        "</ns1:OpenJob>"
    ) % (escape(job), escape(name), escape(source))


def exec_body(job, name, source):
    return (
        "<ns1:Execute>\n"
        "<ns1:jobID>%s</ns1:jobID>"
        "<ns1:script><ns1:name>%s</ns1:name>"
        "<ns1:script>%s</ns1:script></ns1:script>\n"
        "</ns1:Execute>"
    ) % (escape(job), escape(name), escape(source))


def post(url, action, body, timeout):
    data = envelope(body).encode("utf-8")
    req = urllib.request.Request(url, data=data, method="POST")
    req.add_header("Content-Type", 'text/xml; charset="utf-8"')
    req.add_header("SOAPAction", '"%s"' % action)
    req.add_header("Content-Length", str(len(data)))
    try:
        with urllib.request.urlopen(req, timeout=timeout) as r:
            return r.status, r.read().decode("utf-8", "replace")
    except urllib.error.HTTPError as e:
        return e.code, e.read().decode("utf-8", "replace")
    except Exception as e:
        return None, "TRANSPORT_FAIL: %r" % e


def cmd_probe(url, deadline):
    t0 = time.time()
    while time.time() - t0 < deadline:
        status, body = post(url, NS + "HelloWorld", hello_body(), 5)
        if status == 200 and "Hello World" in body:
            print("PROBE_OK after %.1fs" % (time.time() - t0))
            return 0
        time.sleep(2)
    print("PROBE_FAIL: no HelloWorld reply within %ds" % deadline)
    return 1


def cmd_open(url, job, name, path, logpath):
    try:
        with open(path, "r", encoding="utf-8") as f:
            source = f.read()
    except OSError as e:
        print("OPEN_FAIL: cannot read %s: %s" % (path, e))
        return 1
    if not source.strip():
        print("OPEN_FAIL: refusing to inject empty source %s" % path)
        return 1
    print("opening job %r" % job)
    status, body = post(url, NS + "OpenJob", open_body(job, name, source), 180)
    if logpath:
        with open(logpath, "w", encoding="utf-8") as f:
            f.write("http=%r\n%s" % (status, body))
    if status is None:
        print("OPEN_FAIL: %s" % body)
        return 1
    if status != 200 or "OpenJobResponse" not in body:
        m = re.search(r"<faultstring>(.*?)</faultstring>", body, re.S)
        print("OPEN_FAIL: job open rejected http=%r fault=%s" % (
            status, m.group(1)[:500] if m else body[:500]))
        return 1
    print("job open; executing chunk %r (%d bytes)" % (name, len(source)))
    status, body = post(url, NS + "Execute", exec_body(job, name, source), 180)
    if logpath:
        with open(logpath.replace("open-", "exec-", 1) if "open-" in logpath else logpath + ".exec",
                   "w", encoding="utf-8") as f:
            f.write("http=%r\n%s" % (status, body))
    if status is None:
        print("EXEC_FAIL: %s" % body)
        return 1
    m = re.search(r"<faultstring>(.*?)</faultstring>", body, re.S)
    if m:
        print("EXEC_FAULT (script executed, returned error): %s" % m.group(1)[:500])
        return 0
    if status == 200 and "ExecuteResponse" in body:
        print("EXEC_OK")
        return 0
    print("OPEN_FAIL: http=%r body=%.500s" % (status, body))
    return 1


def cmd_verify(cappath, chunk):
    import json
    loads = {}
    sources = {}
    lift = None
    try:
        with open(cappath, encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                rec = json.loads(line)
                h = rec.get("hook")
                if h == "load" and "chunk" in rec:
                    loads[rec["chunk"]] = rec.get("bytes", 0)
                elif h == "loadSource" and "chunk" in rec:
                    sources[rec["chunk"]] = rec.get("source", "")
                elif h == "lift":
                    lift = rec
    except (OSError, ValueError) as e:
        print("T3_VERIFY_FAIL: cannot parse %s: %s" % (cappath, e))
        return 1
    if chunk not in loads:
        print("T3_VERIFY_FAIL: target chunk %r never loaded (loaded: %s)"
              % (chunk, sorted(loads)[:10]))
        return 1
    if loads[chunk] <= 0:
        print("T3_VERIFY_FAIL: target chunk %r loaded with bytes=0" % chunk)
        return 1
    if not sources.get(chunk, "").strip():
        print("T3_VERIFY_FAIL: target chunk %r has no source" % chunk)
        return 1
    if lift is None or lift.get("ok") is not True:
        print("T3_VERIFY_FAIL: lifter did not report ok: %r" % lift)
        return 1
    print("T3_VERIFY_OK chunk=%r bytes=%d source_chars=%d lift_chunks=%s"
          % (chunk, loads[chunk], len(sources[chunk]), lift.get("chunks")))
    return 0


def main(argv):
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument("--port", type=int, default=64989)
    ap.add_argument("--probe", action="store_true")
    ap.add_argument("--open", action="store_true", dest="do_open")
    ap.add_argument("--verify", action="store_true")
    ap.add_argument("--deadline", type=int, default=60)
    ap.add_argument("--job", default="T3")
    ap.add_argument("--name", default="")
    ap.add_argument("--file", default="")
    ap.add_argument("--out", default="")
    ap.add_argument("--capture", default="")
    ap.add_argument("--expect-chunk", default="")
    a = ap.parse_args(argv[1:])
    url = "http://127.0.0.1:%d/" % a.port
    if a.probe:
        return cmd_probe(url, a.deadline)
    if a.do_open:
        if not a.name or not a.file:
            print("OPEN_FAIL: --name and --file required")
            return 1
        return cmd_open(url, a.job, a.name, a.file, a.out or None)
    if a.verify:
        if not a.capture or not a.expect_chunk:
            print("T3_VERIFY_FAIL: --capture and --expect-chunk required")
            return 1
        return cmd_verify(a.capture, a.expect_chunk)
    print("no mode: pass --probe, --open, or --verify")
    return 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
