#!/usr/bin/env python3
"""Assert WS5 capture-stream gate for a JSONL capture log.

Usage: python3 tools/assert_capture.py <path/to/capture.jsonl>

Requires (each must appear at least once):
  openState, load, resumeEnter, resumeExit, bridgeGet,
  schedulerQueue, schedulerResume, forced, forcedCall
Consistency:
  - every signalConnect name has a matching signalFire or forcedFire
  - every line parses as JSON with seq/ts_ms/tid/hook/detail keys
  - seq values are strictly increasing from 1
Exits 1 listing violations.
"""
import json
import sys
from pathlib import Path


REQUIRED = [
    "openState", "load", "resumeEnter", "resumeExit", "bridgeGet",
    "schedulerQueue", "schedulerResume", "forced", "forcedCall",
]

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
        if set(rec.keys()) != KEYS:
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
    fired = set()
    for rec in records:
        if rec["hook"] in ("signalFire", "forcedFire"):
            fired.add(rec["detail"])
    for rec in records:
        if rec["hook"] == "signalConnect" and rec["detail"] not in fired:
            errors.append("unfired connect: %s" % rec["detail"])
    print("records=%d hooks=%s" % (len(records), sorted(seen.keys())))
    return errors


if __name__ == "__main__":
    errs = main(sys.argv[1])
    for e in errs:
        print("CAPTURE_GATE_FAIL: %s" % e)
    sys.exit(1 if errs else 0)
