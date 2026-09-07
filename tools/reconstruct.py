#!/usr/bin/env python3
"""Offline behavior reconstruction from a WS5 capture log.

Usage: python3 tools/reconstruct.py <capture.jsonl> [--out reconstruction.md]

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


def main(argv):
    path = argv[1]
    out_path = None
    if "--out" in argv:
        out_path = argv[argv.index("--out") + 1]
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
    for e in errors:
        print("RECONSTRUCT_FAIL: %s" % e)
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
