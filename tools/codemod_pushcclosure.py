#!/usr/bin/env python3
"""WS4-C4-followup: 3-arg lua_pushcclosure -> lua_pushcclosure_3."""
import re, sys, pathlib

PATTERN = re.compile(r'lua_pushcclosure\s*\(\s*([^,()]+?)\s*,\s*([^,()]+?)\s*,\s*([^,()]+?)\s*\)', re.DOTALL)

def codemod(text, fname):
    n = 0
    def repl(m):
        nonlocal n
        n += 1
        return f'lua_pushcclosure_3({m.group(1).strip()}, {m.group(2).strip()}, {m.group(3).strip()})'
    return PATTERN.sub(repl, text), n

ROOTS = ["roblox-sandbox/App/script", "roblox-sandbox/App/include", "roblox-sandbox/App/util", "roblox-sandbox/App/v8datamodel", "roblox-sandbox/App/Network", "roblox-sandbox/App/humanoid"]
for root in ROOTS:
    for p in pathlib.Path(root).rglob("*.cpp"):
        try:
            txt = p.read_text(encoding="utf-8", errors="replace")
        except Exception:
            continue
        if "lua_pushcclosure" not in txt:
            continue
        out, n = codemod(txt, p.stem)
        if n:
            p.write_text(out, encoding="utf-8")
            print(f"{p}: {n} replacements")
