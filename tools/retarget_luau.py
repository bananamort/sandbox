#!/usr/bin/env python3
"""Retarget App.vcxproj from Lua 5.1.4 to Luau 0.735 (WS4-C2)."""
import re
import pathlib
import xml.etree.ElementTree as ET

vcx = pathlib.Path("roblox-sandbox/App/App.vcxproj")
text = vcx.read_text(encoding="utf-8-sig")

# The vcxproj has no default namespace; raw string replace is safer than XML tree for preserving formatting.
# 1) Remove old Lua-5.1.4 ClCompile entries (lapi.c ... print.c) — block from first Lua ClCompile to print.c's closing </ClCompile>
# Find all old Lua entries via regex and remove them.
old_pattern = re.compile(r'\s*<ClCompile Include="Lua-5\.1\.4\\src\\[^"]+">.*?</ClCompile>\s*', re.DOTALL)
old_count = len(old_pattern.findall(text))
print(f"Found {old_count} old Lua ClCompile entries")
text, n = old_pattern.subn("", text)
print(f"Removed {n} entries")

# 2) Remove old Lua ClInclude entries
old_inc_pattern = re.compile(r'\s*<ClInclude Include="Lua-5\.1\.4\\src\\[^"]+" />\s*', re.DOTALL)
old_inc_count = len(old_inc_pattern.findall(text))
print(f"Found {old_inc_count} old Lua ClInclude entries")
text, n2 = old_inc_pattern.subn("", text)
print(f"Removed {n2} ClInclude")

# 3) Gather new Luau source files to compile.
# We want VM, Compiler, Ast, Common, Bytecode, Config — the libs needed for luau_compile + VM.
import os
src_root = pathlib.Path("roblox-sandbox/App/Lua-5.1.4/src")
# Collect .cpp files under VM/src, Compiler/src, Ast/src, Common/src, Bytecode/src, Config/src etc
# Use vendor mirror to list canonical Luau files, but src is where we actually compile from.
luau_src_files = []
for sub in ["VM/src", "Compiler/src", "Ast/src", "Common/src", "Bytecode/src", "Config/src"]:
    p = src_root / sub
    if p.exists():
        for f in sorted(p.glob("*.cpp")):
            rel = f.relative_to(pathlib.Path("roblox-sandbox/App"))
            # vcxproj uses backslashes
            rel_str = str(rel).replace("/", "\\")
            luau_src_files.append(rel_str)
        for f in sorted(p.glob("*.c")):
            rel = f.relative_to(pathlib.Path("roblox-sandbox/App"))
            rel_str = str(rel).replace("/", "\\")
            luau_src_files.append(rel_str)

# Also handle VM/src/*.cpp that are direct, plus headers for ClInclude
luau_headers = []
for sub in ["VM/include", "VM/src", "Compiler/include/Luau", "Ast/include/Luau", "Common/include/Luau", "Bytecode/include/Luau", "Config/include/Luau"]:
    p = src_root / sub
    if p.exists():
        for f in sorted(p.glob("*.h")):
            rel = f.relative_to(pathlib.Path("roblox-sandbox/App"))
            rel_str = str(rel).replace("/", "\\")
            luau_headers.append(rel_str)

print(f"New Luau src files: {len(luau_src_files)} Cpps")
for f in luau_src_files[:10]:
    print("  ", f)
print(f"New Luau headers: {len(luau_headers)}")

# 4) Build new ClCompile block (insert before </ItemGroup> that contained old Lua entries — we removed them, so find next ItemGroup)
# Simpler: insert after the last non-Lua ClCompile before old block, or before the ClInclude group.
# Find insertion point: after the last remaining ClCompile (should be tool\ResizeTool etc) — insert new block before the <ClInclude> section for Lua headers.
# We'll insert before the first <ClInclude Include="Lua-5.1.4
# Since we removed old ClInclude, we need to find where to insert new ClInclude — before the next non-Lua ClInclude.
# Easier: find the ItemGroup that contains ClCompile entries and insert there.
# Approach: find string "<ItemGroup>" that we can insert into — pick the one that had Lua entries (now empty) and repopulate.

# Find the ItemGroup that now is empty after removal — it will be a consecutive open/close with no Lua entries.
# We'll just insert new entries before the first <ClInclude> occurrence (which after removal is the next ClInclude after Lua block).
# Locate where to insert ClCompile: before the next ClInclude group.

# Build XML snippets
compile_snippet = "\n".join(f'    <ClCompile Include="{f}" />' for f in luau_src_files)
include_snippet = "\n".join(f'    <ClInclude Include="{f}" />' for f in luau_headers)

# Insert ClCompile block: find the position after the last tool ClCompile (ToolsArrow.cpp) — we removed Lua block, so next is ClInclude or other ClCompile
# Find the string for the last tool compile as anchor
anchor = '<ClCompile Include="Tool\\ToolsArrow.cpp" />'
if anchor in text:
    text = text.replace(anchor, anchor + "\n" + compile_snippet)
    print("Inserted ClCompile after ToolsArrow anchor")
else:
    # fallback: insert before first ClInclude
    text = text.replace('<ClInclude Include="Lua-5.1.4', compile_snippet + '\n    <ClInclude Include="Lua-5.1.4', 1)
    print("Inserted via ClInclude fallback")

# Insert ClInclude: find first ClInclude after our insertion and insert before it, or append after compile snippet
# Find the next ClInclude Include="App\\..." etc — we need a stable anchor after Lua block
# The next ClInclude after old Lua block is likely for other headers; we removed old Lua ClInclude, so the next is for other files.
# Insert include snippet before the closing </ItemGroup> of the ClCompile group? Simpler: insert include snippet after compile snippet by replacing?
# Find the ItemGroup closing after our inserted compiles and insert includes there.
# Locate the first <ClInclude after our compile block
# We inserted compile_snippet, now find where includes should go — after compile ItemGroup, before ClInclude ItemGroup
# Search for a pattern: the ItemGroup that contains ClCompile ends with </ItemGroup>, next ItemGroup starts with <ClInclude
# We'll insert include_snippet before the next <ItemGroup> that contains ClInclude
# Find the next occurrence of "<ItemGroup>" after compile_snippet
idx = text.find(compile_snippet.split("\n")[-1])
# Find next ItemGroup after idx
next_item = text.find("<ItemGroup>", idx)
if next_item != -1:
    # Insert include snippet inside that ItemGroup after its opening
    # Find the opening tag end
    open_end = text.find(">", next_item) + 1
    text = text[:open_end] + "\n" + include_snippet + text[open_end:]
    print("Inserted ClInclude in next ItemGroup")
else:
    print("Warning: no ItemGroup found for ClInclude")

# 5) Update AdditionalIncludeDirectories to add Luau include paths
# Each occurrence of AdditionalIncludeDirectories contains ".\lua-5.1.4\src;" — append new paths
old_inc = ".\\lua-5.1.4\\src;"
new_paths = (
    ".\\Lua-5.1.4\\src\\VM\\include;"
    ".\\Lua-5.1.4\\src\\Compiler\\include;"
    ".\\Lua-5.1.4\\src\\Ast\\include;"
    ".\\Lua-5.1.4\\src\\Common\\include;"
    ".\\Lua-5.1.4\\src\\Bytecode\\include;"
    ".\\Lua-5.1.4\\src\\Config\\include;"
)
# Replace each occurrence: append new_paths after old_inc
count_inc = text.count(old_inc)
print(f"Found {count_inc} AdditionalIncludeDirectories occurrences")
text = text.replace(old_inc, old_inc + new_paths)

# Write back
vcx.write_text(text, encoding="utf-8")
print(f"Wrote {vcx} with {len(luau_src_files)} ClCompile and {len(luau_headers)} ClInclude, updated {count_inc} include dirs")
