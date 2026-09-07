#!/usr/bin/env python3
"""Assert WS5 capture-stream gate for a JSONL capture log.

Usage: python3 tools/assert_capture.py <path/to/capture.jsonl>

Requires (each must appear at least once):
  openState, load, loadSource, resumeEnter, resumeExit, bridgeGet,
  bridgeGetValue, schedulerQueue, schedulerResume, forced, forcedCall,
  coverage, trace
Payload content (not just hook names):
  - every load with bytes>0 has a loadSource with matching chunk header
    and non-empty source text
  - every bridgeGetValue carries a value after '='
  - every resumeEnter/resumeExit carries nargs/result fields
  - every signal name matches on its first token (details carry
    fn=/args= suffixes)
  - at least one coverage record shows exec>0
Consistency:
  - every signalConnect name has a matching signalFire or forcedFire
  - every line parses as JSON with seq/ts_ms/tid/hook/detail keys
  - seq values are strictly increasing from 1
Exits 1 listing violations.
"""
import json
import re
import sys
from pathlib import Path


REQUIRED = [
    "openState", "load", "loadSource", "resumeEnter", "resumeExit",
    "bridgeGet", "bridgeGetValue", "schedulerQueue", "schedulerResume",
    "forced", "forcedCall", "coverage", "trace",
]

KEYS = {"seq", "ts_ms", "tid", "hook", "detail"}


def name_of(detail):
    return detail.split(None, 1)[0] if detail else ""


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
    # load/loadSource pairing with non-empty sources
    loads = {}
    for rec in records:
        if rec["hook"] == "load":
            m = re.search(r"chunk=(\S+) bytes=(\d+)", rec["detail"])
            if m:
                loads[m.group(1)] = int(m.group(2))
    sources = {}
    for rec in records:
        if rec["hook"] == "loadSource":
            head, _, body = rec["detail"].partition("\n")
            m = re.search(r"chunk=(\S+) bytes=(\d+)", head)
            if m:
                sources[m.group(1)] = body
    for chunk, nbytes in loads.items():
        if nbytes > 0:
            if chunk not in sources:
                errors.append("load without source: %s" % chunk)
            elif not sources[chunk].strip():
                errors.append("empty source: %s" % chunk)
    # operand payloads present
    for rec in records:
        if rec["hook"] == "bridgeGetValue" and "=" not in rec["detail"]:
            errors.append("bridgeGetValue without value")
            break
    for rec in records:
        if rec["hook"] == "resumeEnter" and "nargs=" not in rec["detail"]:
            errors.append("resumeEnter without nargs")
            break
    for rec in records:
        if rec["hook"] == "resumeExit" and "result=" not in rec["detail"]:
            errors.append("resumeExit without result")
            break
    # coverage shows real execution
    covered = False
    for rec in records:
        if rec["hook"] == "coverage":
            m = re.search(r"exec=(\d+)/(\d+)", rec["detail"])
            if m and int(m.group(1)) > 0:
                covered = True
                break
    if "coverage" in seen and not covered:
        errors.append("no coverage record with exec>0")
    # connect/fire matching on name token (details carry suffixes)
    fired = set()
    for rec in records:
        if rec["hook"] in ("signalFire", "forcedFire"):
            fired.add(name_of(rec["detail"]))
    for rec in records:
        if rec["hook"] == "signalConnect" and name_of(rec["detail"]) not in fired:
            errors.append("unfired connect: %s" % name_of(rec["detail"]))
    print("records=%d hooks=%s" % (len(records), sorted(seen.keys())))
    return errors


if __name__ == "__main__":
    errs = main(sys.argv[1])
    for e in errs:
        print("CAPTURE_GATE_FAIL: %s" % e)
    sys.exit(1 if errs else 0)
