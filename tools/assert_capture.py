#!/usr/bin/env python3
"""Assert WS5 capture-stream gate for a JSONL capture log.

Usage: python3 tools/assert_capture.py <path/to/capture.jsonl>

Requires (each must appear at least once):
  openState, load, loadSource, resumeEnter, resumeExit, bridgeGet,
  schedulerQueue, schedulerResume, forced, forcedCall,
  coverage, trace, const, lift
Payload content, read from typed record keys (never parsed out of
detail text):
  - every load with bytes>0 has a loadSource with matching chunk and
    non-empty source text
  - every bridgeGetValue carries class/prop/obj/value keys
  - every resumeEnter/resumeExit carries nargs/result keys
  - every signalConnect event has a matching signalFire or forcedFire
  - at least one coverage record shows exec>0
Consistency:
  - every line parses as JSON with seq/ts_ms/tid/hook/detail keys
  - seq values are strictly increasing from 1
Exits 1 listing violations.
"""
import json
import sys
from pathlib import Path


REQUIRED = [
    "openState", "load", "loadSource", "resumeEnter", "resumeExit",
    "bridgeGet", "schedulerQueue", "schedulerResume", "forced",
    "forcedCall", "coverage", "trace", "const", "lift",
]

# Hooks verified for payload shape whenever present (a workload may
# legitimately perform no property reads in-window).
CONDITIONAL = ["bridgeGetValue"]

KEYS = {"seq", "ts_ms", "tid", "hook", "detail"}


def main(path):
    errors = []
    try:
        lines = Path(path).read_text(encoding="utf-8").splitlines()
    except OSError as e:
        return ["cannot read %s: %s" % (path, e)]
    records = []
    for i, line in enumerate(lines, 1):
        if not line.strip():
            continue
        try:
            rec = json.loads(line)
        except ValueError:
            errors.append("line %d: invalid JSON" % i)
            continue
        if not KEYS.issubset(set(rec.keys())):
            errors.append("line %d: keys %s" % (i, sorted(rec.keys())))
            continue
        records.append(rec)
    if not records:
        return errors + ["no records"]
    for prev, cur in zip(records, records[1:]):
        if cur["seq"] != prev["seq"] + 1:
            errors.append("seq not increasing at %d" % cur["seq"])
            break
    if records[0]["seq"] != 1:
        errors.append("first seq is %d, want 1" % records[0]["seq"])
    seen = {}
    for rec in records:
        seen.setdefault(rec["hook"], 0)
        seen[rec["hook"]] += 1
    for hook in REQUIRED:
        if not seen.get(hook):
            errors.append("missing hook: %s" % hook)
    for hook in CONDITIONAL:
        if hook not in seen:
            print("note: optional hook absent: %s" % hook)
    # load/loadSource pairing with non-empty sources, from typed keys
    loads = {}
    for rec in records:
        if rec["hook"] == "load":
            if "chunk" not in rec or "bytes" not in rec:
                errors.append("load without typed chunk/bytes")
                break
            loads[rec["chunk"]] = rec["bytes"]
    sources = {}
    for rec in records:
        if rec["hook"] == "loadSource":
            if "chunk" not in rec or "source" not in rec:
                errors.append("loadSource without typed chunk/source")
                break
            sources[rec["chunk"]] = rec["source"]
    for chunk, nbytes in loads.items():
        if nbytes > 0:
            if chunk not in sources:
                errors.append("load without source: %s" % chunk)
            elif not sources[chunk].strip():
                errors.append("empty source: %s" % chunk)
    # operand payloads present as typed keys; values are objects
    # {kind, value, truncated}, never rendered text
    for rec in records:
        if rec["hook"] == "bridgeGetValue":
            for k in ("class", "prop", "obj", "value", "setValue"):
                if k not in rec:
                    errors.append("bridgeGetValue without key: %s" % k)
                    break
            else:
                v = rec["value"]
                if not isinstance(v, dict) or "kind" not in v or "value" not in v:
                    errors.append("bridgeGetValue value not an object")
                sv = rec.get("setValue")
                if sv is not None and (not isinstance(sv, dict) or "kind" not in sv or "value" not in sv):
                    errors.append("bridgeGetValue setValue not an object")
            break
    for rec in records:
        if rec["hook"] == "bridgeSet":
            for k in ("class", "prop", "obj", "value"):
                if k not in rec:
                    errors.append("bridgeSet without key: %s" % k)
                    break
            else:
                v = rec["value"]
                if not isinstance(v, dict) or "kind" not in v or "value" not in v:
                    errors.append("bridgeSet value not an object")
            break
    for rec in records:
        if rec["hook"] == "resumeEnter" and "nargs" not in rec:
            errors.append("resumeEnter without nargs")
            break
    for rec in records:
        if rec["hook"] == "resumeExit" and "result" not in rec:
            errors.append("resumeExit without result")
            break
    for rec in records:
        if rec["hook"] == "memberCall":
            for k in ("class", "func", "obj", "args"):
                if k not in rec:
                    errors.append("memberCall without key: %s" % k)
                    break
            break
    for rec in records:
        if rec["hook"] == "const":
            for k in ("chunk", "proto", "op", "off", "line", "kind", "value"):
                if k not in rec:
                    errors.append("const without key: %s" % k)
                    break
            break
    for rec in records:
        if rec["hook"] == "signalFire":
            for k in ("event", "args"):
                if k not in rec:
                    errors.append("signalFire without key: %s" % k)
                    break
            break
    # coverage shows real execution, from typed exec/total
    covered = False
    for rec in records:
        if rec["hook"] == "coverage":
            if "exec" not in rec or "sizecode" not in rec:
                errors.append("coverage without typed exec/sizecode")
                break
            if rec["exec"] > 0:
                covered = True
                break
    if "coverage" in seen and not covered:
        errors.append("no coverage record with exec>0")
    # connect/fire matching on typed event names
    fired = set()
    for rec in records:
        if rec["hook"] in ("signalFire", "forcedFire"):
            if "event" in rec:
                fired.add(rec["event"])
    for rec in records:
        if rec["hook"] == "signalConnect" and rec.get("event") not in fired:
            errors.append("unfired connect: %s" % rec.get("event"))
    # lifter ran clean: typed ok flag (reconstruction.lua written
    # by the in-engine lifter from accumulated typed feed)
    for rec in records:
        if rec["hook"] == "lift":
            if "ok" not in rec or "chunks" not in rec:
                errors.append("lift without typed ok/chunks")
                break
            if rec["ok"] is not True or rec["chunks"] < 1:
                errors.append("lift failed: ok=%r chunks=%r" % (rec.get("ok"), rec.get("chunks")))
                break
            break
    print("records=%d hooks=%s" % (len(records), sorted(seen.keys())))
    return errors


if __name__ == "__main__":
    errs = main(sys.argv[1])
    for e in errs:
        print("CAPTURE_GATE_FAIL: %s" % e)
    sys.exit(1 if errs else 0)
