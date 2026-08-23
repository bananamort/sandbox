#!/usr/bin/env python3
"""Remove pruned projects from Roblox.sln (roblox-sandbox working copy).

Usage: python3 tools/slim_sln.py <path/to/Roblox.sln>

Removes each pruned project's Project(...) block, all of its
{GUID}.<config> lines under ProjectConfigurationPlatforms, its
NestedProjects children lines, and solution folders left empty by the
removals. Stale GUID config lines make MSBuild still attempt removed
projects, so they must go too.

Idempotent: a rerun reports zero removals. Exits 1 on parse failure or
if any surviving project still points into a deleted tree.
"""
import re
import sys
from pathlib import Path

SOLUTION_FOLDER_TYPE = "{2150E333-8FDC-42A3-9474-1A3956D46DE8}"

# Lowercased, backslash-normalized path prefixes (relative to the .sln)
# whose projects were pruned from roblox-sandbox.
DELETE_PREFIXES = [
    "android\\", "builtinplugins\\", "corescriptconverter2\\", "gamechat\\",
    "includechecker\\", "installer\\", "ios\\", "mac\\",
    "macclient.xcodeproj\\", "microsoft.xbox.samples.networkmesh\\",
    "prepallforupload\\", "qtitanribbon\\", "rccservice.prepforupload\\",
    "rccservice.test\\", "rccservice.thumb.test\\", "rbxtesthooks\\",
    "roblox.rccservicearbiter\\", "roblox.test\\", "robloxhybrid\\",
    "robloxmac\\", "robloxmobiletest\\", "robloxmodelanalyzer\\",
    "robloxstudio\\", "robloxstudio.prepforupload\\", "scriptsigner\\",
    "settingscomparisontool\\", "simulationtestutility\\", "studioplugins\\",
    "windowsclient.prepforupload\\", "xboxclient\\", "app.unittest\\",
    "app.unittest.lib\\", "app.unittest.run\\", "base.unittest\\",
    "base.unittest.lib\\", "base.unittest.run\\", "robloxtest\\",
    "refreshpolicies\\", "cmake\\", "rendering\\shadercompiler\\",
    "boostlibs\\boost.test.vcxproj",
]

PROJECT_LINE = re.compile(
    r'^Project\("\{[^}]+\}"\)\s*=\s*"[^"]*",\s*"([^"]*)",\s*"\{([^}]+)\}"')


def norm(path):
    return path.replace("/", "\\").strip().lower()


def is_deleted(project_path):
    p = norm(project_path)
    return any(p.startswith(prefix) for prefix in DELETE_PREFIXES)


def main():
    if len(sys.argv) != 2:
        print(__doc__)
        return 2
    sln = Path(sys.argv[1])
    raw = sln.read_text(encoding="utf-8-sig", errors="surrogateescape")
    eol = "\r\n" if "\r\n" in raw else "\n"
    lines = raw.splitlines()

    # Parse Project blocks.
    blocks = []
    cur = None
    for i, line in enumerate(lines):
        if line.startswith("Project("):
            m = PROJECT_LINE.match(line)
            if not m:
                print(f"FATAL: unparseable Project line {i+1}: {line!r}")
                return 1
            cur = {"start": i, "path": m.group(1), "guid": "{" + m.group(2).upper() + "}",
                   "type": "folder" if "2150E333" in line.upper() else "project"}
        elif line.strip() == "EndProject" and cur is not None:
            cur["end"] = i
            blocks.append(cur)
            cur = None
    if cur is not None or not blocks:
        print("FATAL: malformed solution (unbalanced Project blocks)")
        return 1

    def section_range(name):
        start = end = None
        for i, line in enumerate(lines):
            s = line.strip()
            if start is None and s.startswith(f"GlobalSection({name})"):
                start = i
            elif start is not None and s == "EndGlobalSection":
                end = i
                break
        return start, end

    cfg_start, cfg_end = section_range("ProjectConfigurationPlatforms")
    nest_start, nest_end = section_range("NestedProjects")

    removed = {b["guid"] for b in blocks if b["type"] == "project" and is_deleted(b["path"])}

    # Nested child -> parent map (kept as-is first).
    nested_pairs = []
    for i in range(nest_start + 1, nest_end):
        m = re.match(r"\s*(\{[^}]+\})\s*=\s*(\{[^}]+\})", lines[i])
        if m:
            nested_pairs.append((m.group(1).upper(), m.group(2).upper()))

    # Drop nested lines touching removed projects, then collapse solution
    # folders that no longer have any surviving children (fixpoint).
    folders = {b["guid"]: b for b in blocks if b["type"] == "folder"}
    while True:
        pairs = [(c, p) for c, p in nested_pairs
                 if c not in removed and p not in removed]
        occupied_parents = {p for _, p in pairs}
        newly = {g for g in folders if g not in removed and g not in occupied_parents}
        if not newly:
            break
        removed |= newly

    kept_pairs = [(c, p) for c, p in nested_pairs if c not in removed and p not in removed]

    # Rebuild.
    out = []
    removed_block_lines = 0
    removed_cfg_lines = 0
    removed_nested_lines = 0
    skip_until = -1
    nest_i = 0
    kept_pairs_by_child = dict(kept_pairs)
    for i, line in enumerate(lines):
        if i <= skip_until:
            continue
        in_cfg = cfg_start is not None and cfg_start < i < cfg_end
        in_nest = nest_start is not None and nest_start < i < nest_end
        if in_cfg:
            m = re.search(r"\{([0-9A-Fa-f-]+)\}", line)
            if m and "{" + m.group(1).upper() + "}" in removed:
                removed_cfg_lines += 1
                continue
        if in_nest:
            m = re.match(r"\s*(\{[^}]+\})\s*=\s*\{[^}]+\}", line)
            if m and "{" + m.group(1).upper() + "}" in removed:
                removed_nested_lines += 1
                continue
        block = next((b for b in blocks if b["start"] == i), None)
        if block is not None:
            if block["guid"] in removed:
                removed_block_lines += block["end"] - block["start"] + 1
                skip_until = block["end"]
                continue
        out.append(line)

    new_raw = eol.join(out) + eol
    sln.write_bytes(new_raw.encode("utf-8"))

    survived_projects = sum(1 for b in blocks if b["type"] == "project" and b["guid"] not in removed)
    survived_folders = sum(1 for b in blocks if b["type"] == "folder" and b["guid"] not in removed)

    # Post-check: no surviving project may point into a deleted tree.
    leaks = []
    for b in blocks:
        if b["type"] == "project" and b["guid"] not in removed and is_deleted(b["path"]):
            leaks.append(b["path"])
    if leaks:
        print("FATAL: projects still reference deleted trees:")
        for leak in leaks:
            print(f"  {leak}")
        return 1

    print(f"projects: {survived_projects} kept, {len(removed)} removed "
          f"(incl. {survived_folders} solution folder(s))")
    print(f"lines removed: {removed_block_lines} block / {removed_cfg_lines} config / {removed_nested_lines} nested")
    print("CHECK_OK: no surviving project references a deleted tree")
    return 0


if __name__ == "__main__":
    sys.exit(main())
