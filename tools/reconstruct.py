#!/usr/bin/env python3
"""Offline behavior report from a WS5 capture log.

Usage: python3 tools/reconstruct.py <capture.jsonl> [--out reconstruction.md]
       [--emit-replay DIR]

Reads ONLY typed record keys (never parses detail text — detail is a
human summary line). Produces:
  - chunks: every loaded chunk with source size, identity, coverage
    (executed/total offsets), and trace-record count
  - timeline: every boundary event in order, rendered from typed keys
  - globals inventory from openState
  - optionally, a stimulus replay script (--emit-replay)

The runnable reconstruction itself is produced in-engine by the lifter
(App/script/ScriptLift.cpp: Luau::Parser + PrettyPrinter over the
accumulated typed feed); this tool reports and cross-checks.

Structural failures (exit 1):
  - a load with bytes>0 has no matching loadSource, or the source is empty
  - a trace/coverage record names a chunk with no logged source
"""
import json
import sys
from collections import OrderedDict
from pathlib import Path


def parse_records(path):
    records = []
    with open(path, encoding="utf-8") as f:
        for i, line in enumerate(f, 1):
            line = line.strip()
            if not line:
                continue
            try:
                rec = json.loads(line)
            except ValueError:
                return None, ["line %d: invalid JSON" % i]
            records.append(rec)
    return records, []


def short_timeline(rec, maxlen=300):
    """One-line human rendering from typed keys; detail text is only a
    fallback for hooks that carry no typed payload by design."""
    hook = rec.get("hook")
    g = rec.get
    if hook == "load":
        return "chunk=%s bytes=%s identity=%s" % (g("chunk"), g("bytes"), g("identity"))
    if hook == "resumeEnter":
        return "nargs=%s args=%s" % (g("nargs"), g("args"))
    if hook == "resumeExit":
        return "result=%s rets=%s" % (g("result"), g("rets"))
    if hook in ("bridgeGetValue", "bridgeSet"):
        return "%s.%s obj=%s value=%s" % (g("class"), g("prop"), g("obj"), g("value"))
    if hook == "memberCall":
        return "%s.%s obj=%s args=%s" % (g("class"), g("func"), g("obj"), g("args"))
    if hook == "signalConnect":
        return "%s fn=%s" % (g("event"), g("fnkind"))
    if hook == "signalFire":
        return "%s args=%s" % (g("event"), g("args"))
    if hook == "forcedCall":
        return "fn=%s status=%s" % (g("fn"), g("status"))
    if hook == "http":
        return "%s %s payload=%s hash=%s" % (g("method"), g("url"), g("payloadLen"), g("payloadHash"))
    if hook == "coverage":
        return "chunk=%s proto=%s exec=%s/%s" % (g("chunk"), g("proto"), g("exec"), g("sizecode"))
    if hook == "const":
        return "chunk=%s op=%s %s=%s" % (g("chunk"), g("op"), g("kind"), g("value"))
    if hook == "lift":
        return "chunks=%s ok=%s" % (g("chunks"), g("ok"))
    first = rec.get("detail", "").split("\n", 1)[0]
    return first[:maxlen]


def emit_replay(records, outdir):
    """Regenerate a runnable stimulus replay from TYPED keys: straight-line
    Luau re-issuing observed property writes and member calls. Literals are
    accepted by kind (number/bool verbatim; strings re-quoted only when the
    typed raw matches the safe Luau literal shape). Anything else becomes
    nil with a comment recording the observed kind. Returns (code, errors).
    """
    import re
    safe_str = re.compile(r'^(?:[^"\\\n]|\\["\\/nrt])*$')
    ident = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*(\.[A-Za-z_][A-Za-z0-9_]*)*$")
    errors = []
    code = []
    code.append("-- replay generated from capture.jsonl typed records:")
    code.append("-- re-issues observed property writes and member calls.")
    code.append("-- Run inside the sandbox DataModel context (game present).")

    def lit(kind, raw):
        if kind in ("number", "bool"):
            return raw, True
        if kind == "string" and safe_str.match(raw):
            return '"%s"' % raw, True
        return "nil", False

    for rec in records:
        hook = rec.get("hook")
        if hook == "bridgeSet":
            for k in ("class", "prop", "obj"):
                if k not in rec:
                    errors.append("bridgeSet without key: %s" % k)
                    break
            else:
                path = "game." + rec["obj"] if rec["obj"] else "game"
                if not ident.match(path):
                    code.append("-- non-replayable set: %s.%s" % (rec["class"], rec["prop"]))
                    continue
                v = rec.get("value", {})
                l, ok = lit(v.get("kind"), v.get("raw", ""))
                if ok:
                    code.append("%s.%s = %s" % (path, rec["prop"], l))
                else:
                    code.append("-- %s.%s = %s (kind %s, skipped)" % (path, rec["prop"], v.get("raw", "")[:120], v.get("kind")))
                continue
        elif hook == "memberCall":
            for k in ("class", "func", "obj", "args"):
                if k not in rec:
                    errors.append("memberCall without key: %s" % k)
                    break
            else:
                path = "game." + rec["obj"] if rec["obj"] else None
                fn = rec.get("func", "")
                args = rec.get("args", [])
                if not path or not ident.match(path) or not re.match(r"^[A-Za-z_][A-Za-z0-9_]*$", fn or ""):
                    code.append("-- non-replayable call")
                    continue
                lits = []
                bad = []
                for a in args if isinstance(args, list) else []:
                    l, ok = lit(a.get("kind"), a.get("raw", ""))
                    lits.append(l)
                    if not ok:
                        bad.append(str(a.get("kind")))
                if bad:
                    code.append("-- %s:%s(%s) (non-literal %s, nulled)" % (path, fn, ", ".join(lits), ";".join(bad)))
                code.append("%s:%s(%s)" % (path, fn, ", ".join(lits)))
                continue
        elif hook == "signalFire":
            code.append("-- observed event: %s" % str(rec.get("event", ""))[:200])
        elif hook == "http":
            code.append("-- observed egress: %s %s" % (rec.get("method", ""), str(rec.get("url", ""))[:200]))
    return code, errors


def main(argv):
    path = argv[1]
    out_path = None
    if "--out" in argv:
        out_path = argv[argv.index("--out") + 1]
    replay_dir = None
    if "--emit-replay" in argv:
        replay_dir = argv[argv.index("--emit-replay") + 1]
    records, errors = parse_records(path)
    if records is None:
        for e in errors:
            print("RECONSTRUCT_FAIL: %s" % e)
        return 1

    chunks = OrderedDict()
    timeline = []
    globs = []
    trace_counts = {}
    errors = []

    for rec in records:
        hook = rec.get("hook")
        if hook == "load":
            if "chunk" in rec and "bytes" in rec:
                c = chunks.setdefault(rec["chunk"], {})
                c["bytes"] = rec["bytes"]
                c["identity"] = rec.get("identity")
        elif hook == "loadSource":
            if "chunk" in rec and "source" in rec:
                chunks.setdefault(rec["chunk"], {})["source"] = rec["source"]
        elif hook == "coverage":
            if "chunk" in rec and "exec" in rec and "sizecode" in rec:
                lst = chunks.setdefault(rec["chunk"], {}).setdefault("protos", [])
                lst.append((rec["exec"], rec["sizecode"]))
        elif hook == "trace":
            if "chunk" in rec:
                trace_counts[rec["chunk"]] = trace_counts.get(rec["chunk"], 0) + 1
        elif hook == "openState":
            globs.append(rec.get("detail", ""))
        elif hook in ("resumeEnter", "resumeExit", "bridgeGet", "bridgeGetValue",
                      "bridgeSet", "signalConnect", "signalFire", "forcedFire",
                      "forcedCall", "http", "schedulerQueue", "schedulerResume",
                      "memberCall", "const", "lift"):
            timeline.append((rec["seq"], hook, rec))

    # structural checks
    for name, c in chunks.items():
        if c.get("bytes", 0) > 0 and not c.get("source", "").strip():
            errors.append("chunk without source: %s" % name)
    for name in trace_counts:
        if name not in chunks or not chunks[name].get("source", "").strip():
            errors.append("trace for chunk with no source: %s" % name)

    out = []
    out.append("# Reconstruction")
    out.append("")
    out.append("records=%d chunks=%d timeline_events=%d" % (len(records), len(chunks), len(timeline)))
    out.append("")
    out.append("## Chunks")
    for name, c in chunks.items():
        protos = c.get("protos", [])
        exec_n = sum(e for e, _ in protos)
        total_n = sum(t for _, t in protos)
        cov = "%d/%d" % (exec_n, total_n) if protos else "no-coverage"
        out.append("### %s" % name)
        out.append("bytes=%s identity=%s coverage=%s trace_records=%d" % (
            c.get("bytes", "?"), c.get("identity", "?"), cov,
            trace_counts.get(name, 0)))
        src = c.get("source", "")
        out.append("source_chars=%d" % len(src))
    out.append("")
    out.append("## Timeline (boundary events in order)")
    for seq, hook, rec in timeline:
        out.append("%d [%s] %s" % (seq, hook, short_timeline(rec)))
    if globs:
        out.append("")
        out.append("## Globals inventory")
        out.append(globs[-1][:2000])
    text = "\n".join(out) + "\n"
    if out_path:
        Path(out_path).write_text(text, encoding="utf-8")
    else:
        sys.stdout.write(text)
    if replay_dir:
        rp = Path(replay_dir)
        rp.mkdir(parents=True, exist_ok=True)
        code, rerrs = emit_replay(records, rp)
        errors.extend(rerrs)
        rp.joinpath("replay.lua").write_text("\n".join(code) + "\n", encoding="utf-8")
        ncode = sum(1 for ln in code
                    if ln.strip() and not ln.strip().startswith("--"))
        print("replay: %d code lines" % ncode)
        want_code = any(r.get("hook") in ("bridgeSet", "memberCall") for r in records)
        if want_code and ncode == 0:
            errors.append("events present but replay has no code lines")
    for e in errors:
        print("RECONSTRUCT_FAIL: %s" % e)
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
