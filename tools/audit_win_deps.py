"""Recursive static import audit for Win32 PEs.

Walks the static import table of each executable/DLL under a directory
using dumpbin, resolving every non-delay-load dependency against the
loader search order for a 32-bit process (application directory first,
then SysWOW64/System32). Any module that cannot be resolved is reported
with the name of the module that imports it, and the script exits
non-zero. API-set contracts (api-ms-* / ext-ms-*) are treated as
resolvable by the OS apiset mapper.

Usage: python audit_win_deps.py <dir> [entry ...]
       entry defaults to every *.exe directly in <dir>.
Requires dumpbin on PATH.
"""

import os
import re
import subprocess
import sys
from pathlib import Path

DEP_RE = re.compile(r"^([A-Za-z0-9_.\-]+\.[dD][lL][lL])$")
APiset_PREFIXES = ("api-", "ext-", "gecko-")


def dumpbin_dependents(pe: Path, run=subprocess.run) -> tuple[list[str], list[str]]:
    proc = run(
        ["dumpbin", "/nologo", "/DEPENDENTS", str(pe)],
        capture_output=True,
        text=True,
    )
    if proc.returncode != 0:
        sys.exit(f"dumpbin failed on {pe}: {proc.stderr.strip()}")
    static: list[str] = []
    delay: list[str] = []
    section = None
    for raw in proc.stdout.splitlines():
        line = raw.strip()
        if line.startswith("Image has the following dependencies"):
            section = "static"
            continue
        if line.startswith("Image has the following delay load"):
            section = "delay"
            continue
        if section == "static" and line.lower().startswith(("summary", "image has the following")):
            section = None
        m = DEP_RE.match(line) if section else None
        if m:
            (static if section == "static" else delay).append(m.group(1))
    return static, delay


def main() -> None:
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    bin_dir = Path(sys.argv[1]).resolve()
    if not bin_dir.is_dir():
        sys.exit(f"not a directory: {bin_dir}")

    entries = [Path(a) for a in sys.argv[2:]] or sorted(bin_dir.glob("*.exe"))
    for e in entries:
        if not e.exists():
            sys.exit(f"missing entry: {e}")

    wow64 = Path(os.environ.get("SystemRoot", r"C:\Windows")) / "SysWOW64"
    system32 = Path(os.environ.get("SystemRoot", r"C:\Windows")) / "System32"

    queue = list(entries)
    visited: set[Path] = set()
    missing: list[tuple[str, str]] = []
    delay_all: list[tuple[str, str]] = []

    while queue:
        pe = queue.pop(0).resolve()
        if pe in visited:
            continue
        visited.add(pe)
        static, delay = dumpbin_dependents(pe)
        for dep in delay:
            delay_all.append((pe.name, dep))
        for dep in static:
            low = dep.lower()
            if low.startswith(APiset_PREFIXES):
                continue
            local = bin_dir / dep
            if local.exists():
                queue.append(local)
                continue
            if (wow64 / dep).exists() or (system32 / dep).exists():
                continue
            missing.append((pe.name, dep))

    print(f"Audited {len(visited)} module(s):")
    for pe in sorted(p.name for p in visited):
        print(f"  {pe}")
    if delay_all:
        print("\nDelay-loaded (informational):")
        for importer, dep in sorted(set(delay_all)):
            print(f"  {importer} -> {dep}")
    if missing:
        print("\nUNRESOLVED IMPORTS:")
        for importer, dep in sorted(set(missing)):
            print(f"  {importer} -> {dep}")
        sys.exit(1)
    print("\nAll static imports resolve. AUDIT_OK")


if __name__ == "__main__":
    main()
