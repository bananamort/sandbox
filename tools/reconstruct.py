#!/usr/bin/env python3
"""Offline behavior reconstruction from a WS5 capture log.

Usage: python3 tools/reconstruct.py <capture.jsonl> [--out reconstruction.md]
       [--emit-replay DIR]

Reads the single capture stream and rebuilds what the scripts did:
  - chunks: every loaded chunk with source size, identity, coverage
    (executed/total offsets), and trace-record count
  - timeline: every boundary event in order (resumes with args/returns,
    bridge reads/writes with values, signal connects/fires, HTTP egress,
    forced-coverage calls)
  - globals inventory from openState

This is the playback side of the flight recorder: the capture stream
holds full sources plus all boundary values, so observed behavior is
re-derivable here without re-running anything. Per-instruction trace
lines stay in capture.jsonl for deep inspection; the timeline below
summarizes them per chunk.

Structural failures (exit 1):
  - a load with bytes>0 has no matching loadSource, or the source is empty
  - a trace/coverage record names a chunk with no logged source
"""
import json
import re
import sys
from collections import OrderedDict
from pathlib import Path


LITERAL_RE = re.compile(
    r'^(?:"(?:[^"\\\n]|\\["\\/nrt])*"|true|false|nil|-?\d+(\.\d+)?([eE][+-]?\d+)?)$')
IDENT_PATH_RE = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*(\.[A-Za-z_][A-Za-z0-9_]*)*$")
FN_RE = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")


def to_literal(rendered):
    """(literal, ok): runnable Luau literal or nil+False for complex values."""
    s = rendered.strip()
    if LITERAL_RE.match(s):
        return s, True
    return "nil", False


def parse_detail_path(path):
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


def split_detail(det):
    """Split pipe-separated detail into fields."""
    return [f.strip() for f in det.split(" | ")]


def emit_replay(records, chunks, outdir):
    """Regenerate a runnable stimulus replay: straight-line Luau that
    re-issues every observed property write and member call with logged
    literal values, in order. Non-literal values become nil with a comment
    recording what was observed. Returns (code_lines, errors)."""
    errors = []
    code = []
    code.append("-- replay generated from capture.jsonl: re-issues observed")
    code.append("-- property writes and member calls in order. Run inside")
    code.append("-- the sandbox DataModel context (game global present).")
    for rec in records:
        hook, det = rec.get("hook"), rec.get("detail", "")
        if hook == "bridgeSet":
            parts = split_detail(det)
            if len(parts) != 3:
                errors.append("malformed bridgeSet: %s" % det[:120])
                continue
            what, objf, val = parts
            if not objf.startswith("obj="):
                errors.append("bridgeSet without obj: %s" % det[:120])
                continue
            m = re.match(r"^(\S+)\.([A-Za-z_][A-Za-z0-9_]*)$", what)
            path = "game." + objf[4:] if objf[4:] else "game"
            if not m or not IDENT_PATH_RE.match(path):
                code.append("-- non-replayable set: %s" % det[:200])
                continue
            lit, ok = to_literal(val)
            prop = m.group(2)
            if ok:
                code.append("%s.%s = %s" % (path, prop, lit))
            else:
                code.append("-- %s.%s = %s (non-literal, skipped)" % (path, prop, val[:120]))
        elif hook == "memberCall":
            parts = split_detail(det)
            if len(parts) != 3:
                errors.append("malformed memberCall: %s" % det[:120])
                continue
            what, objf, argsf = parts
            m = re.match(r"^(\S+)\.([A-Za-z_][A-Za-z0-9_]*)$", what)
            path = "game." + objf[4:] if objf.startswith("obj=") and objf[4:] else None
            args = argsf[5:] if argsf.startswith("args=") else None
            if not m or path is None or args is None or not IDENT_PATH_RE.match(path):
                code.append("-- non-replayable call: %s" % det[:200])
                continue
            lits = []
            bad = []
            if args.strip():
                for a in args.split(","):
                    lit, ok = to_literal(a)
                    lits.append(lit)
                    if not ok:
                        bad.append(a.strip()[:60])
            if bad:
                code.append("-- %s:%s(%s) (non-literal args %s, nulled)" % (
                    path, m.group(2), ", ".join(lits), ";".join(bad)))
            code.append("%s:%s(%s)" % (path, m.group(2), ", ".join(lits)))
        elif hook == "signalFire":
            code.append("-- observed event: %s" % det[:200])
        elif hook == "http":
            code.append("-- observed egress: %s" % det.split("\n", 1)[0][:200])
    return code, errors


def main(argv):
    path = argv[1]
    out_path = None
    if "--out" in argv:
        out_path = argv[argv.index("--out") + 1]
    replay_dir = None
    if "--emit-replay" in argv:
        replay_dir = argv[argv.index("--emit-replay") + 1]
    records, errors = parse_detail_path(path)
    if records is None:
        for e in errors:
            print("RECONSTRUCT_FAIL: %s" % e)
        return 1

    chunks = OrderedDict()  # name -> dict(bytes, identity, source, exec, total)
    timeline = []
    globs = []
    trace_counts = {}
    errors = []

    for rec in records:
        hook, det = rec.get("hook"), rec.get("detail", "")
        if hook == "load":
            m = re.search(r"chunk=(\S+) bytes=(\d+)(?: identity=(-?\d+))?", det)
            if m:
                c = chunks.setdefault(m.group(1), {})
                c["bytes"] = int(m.group(2))
                c["identity"] = m.group(3)
        elif hook == "loadSource":
            head, _, body = det.partition("\n")
            m = re.search(r"chunk=(\S+)", head)
            if m:
                c = chunks.setdefault(m.group(1), {})
                c["source"] = body
        elif hook == "coverage":
            m = re.search(r"chunk=(\S+) proto=\d+ exec=(\d+)/(\d+)", det)
            if m:
                lst = chunks.setdefault(m.group(1), {}).setdefault("protos", [])
                lst.append((int(m.group(2)), int(m.group(3))))
        elif hook == "trace":
            m = re.search(r"chunk=(\S+)", det)
            if m:
                trace_counts[m.group(1)] = trace_counts.get(m.group(1), 0) + 1
        elif hook == "openState":
            globs.append(det)
        elif hook in ("resumeEnter", "resumeExit", "bridgeGet", "bridgeGetValue",
                      "bridgeSet", "signalConnect", "signalFire", "forcedFire",
                      "forcedCall", "http", "schedulerQueue", "schedulerResume"):
            timeline.append((rec["seq"], hook, det))

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
    for seq, hook, det in timeline:
        first = det.split("\n", 1)[0]
        if len(first) > 300:
            first = first[:300] + "..."
        out.append("%d [%s] %s" % (seq, hook, first))
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
        code, rerrs = emit_replay(records, chunks, rp)
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
