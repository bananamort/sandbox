#!/usr/bin/env python3
"""Retarget kept roblox-sandbox vcxprojs to VS2022/v143.

Usage: python3 tools/retarget_v143.py <path/to/roblox-sandbox>

For every .vcxproj under the tree:
- <PlatformToolset>v140_xp</PlatformToolset> -> v143 (any *_xp variant too)
- Ensures each PropertyGroup holding a toolset also carries
  <WindowsTargetPlatformVersion>10.0</WindowsTargetPlatformVersion>
  ("10.0" = newest installed Win10+ SDK at build time).

Prints a per-file change count. Idempotent.
"""
import re
import sys
from pathlib import Path

TOOLSET_RE = re.compile(r"<PlatformToolset>[^<]*</PlatformToolset>")
WTPV_LINE = "    <WindowsTargetPlatformVersion>10.0</WindowsTargetPlatformVersion>"


def convert(text):
    changed = 0

    def sub_toolset(m):
        nonlocal changed
        inner = m.group(0)
        new = "<PlatformToolset>v143</PlatformToolset>"
        if inner != new:
            changed += 1
        return new

    groups = re.split(r"(</PropertyGroup>)", text)
    out_parts = []
    for part in groups:
        if "<PlatformToolset>" in part:
            new_part = TOOLSET_RE.sub(sub_toolset, part)
            if "<WindowsTargetPlatformVersion>" not in new_part:
                new_part = new_part.replace(
                    "</PlatformToolset>", "</PlatformToolset>\n" + WTPV_LINE, 1)
                # count only when we actually added after a toolset exists
            out_parts.append(new_part)
        else:
            out_parts.append(part)
    return "".join(out_parts), changed


def main():
    if len(sys.argv) != 2:
        print(__doc__)
        return 2
    root = Path(sys.argv[1])
    total_files = total_changed = 0
    for vcx in sorted(root.rglob("*.vcxproj")):
        raw = vcx.read_text(encoding="utf-8-sig", errors="surrogateescape")
        new_text, n = convert(raw)
        total_files += 1
        if n:
            vcx.write_bytes(new_text.encode("utf-8"))
            total_changed += n
            print(f"{n:3d}  {vcx.relative_to(root)}")
    print(f"\nfiles scanned: {total_files}, toolset/WTPV edits: {total_changed}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
