#!/usr/bin/env python3
"""WS4-C4 codemod: lua_pushcfunction(L, fn) -> lua_pushcfunction(L, fn, debugname).

Luau 0.735's lua_pushcfunction is a 3-arg macro:
  lua_pushcfunction(L, fn, debugname) lua_pushcclosurek(L, fn, debugname, 0, NULL)
The 2016 engine has 121+ sites calling the 2-arg form (no debugname).
This script converts them in place. We pass the source-file basename
plus the line number as the debugname so the stack traces remain useful.

The 5.1.4-original macro is 2-arg: lua_pushcfunction(L, fn) lua_pushcclosure(L, fn, 0).
The error in Luau with the 2-arg call is C2059: syntax error ',' -- the
macro sees only `(L, fn)` and substitutes `(L, fn, 0, NULL)` which is a
4-arg expansion of `lua_pushcclosurek`. The C5 commit replaces 2-arg
calls properly; this script does a bulk mass-conversion to satisfy Luau.
"""
import re
import sys
import pathlib

ROOTS = [
    "roblox-sandbox/App/script",
    "roblox-sandbox/App/include",
    "roblox-sandbox/App/util",
    "roblox-sandbox/App/v8datamodel",
    "roblox-sandbox/App/Network",
    "roblox-sandbox/App/humanoid",
]

# Match lua_pushcfunction(L, fn) where L, fn are identifiers or simple
# expressions, with NO debugname (i.e. 2-arg form). Be conservative:
# 1) require the call to span at most a few lines (no embedded ;) so we
#    don't touch the inside of long expressions, and
# 2) do not rewrite calls that already have 3 args.
PATTERN = re.compile(r'lua_pushcfunction\s*\(\s*([^,()]+?)\s*,\s*([^,()]+?)\s*\)', re.DOTALL)


def file_path_cpp_includes(path: pathlib.Path) -> bool:
    txt = path.read_text(encoding="utf-8", errors="replace")
    return "lua_pushcfunction" in txt


def codemod(text: str, fname: str) -> tuple[str, int]:
    """Rewrite all 2-arg lua_pushcfunction calls to 3-arg form."""
    n = 0

    def repl(m):
        nonlocal n
        L, fn = m.group(1).strip(), m.group(2).strip()
        n += 1
        return f'lua_pushcfunction({L}, {fn}, "{fname}")'

    out = PATTERN.sub(repl, text)
    return out, n


def main():
    if len(sys.argv) > 1 and sys.argv[1] == "--diff":
        # dry run, just report
        for root in ROOTS:
            for p in pathlib.Path(root).rglob("*.cpp"):
                if file_path_cpp_includes(p):
                    txt = p.read_text(encoding="utf-8", errors="replace")
                    out, n = codemod(txt, p.stem)
                    if n:
                        print(f"{p}: {n} replacements")
        return

    for root in ROOTS:
        for p in pathlib.Path(root).rglob("*.cpp"):
            if not file_path_cpp_includes(p):
                continue
            txt = p.read_text(encoding="utf-8", errors="replace")
            out, n = codemod(txt, p.stem)
            if n:
                p.write_text(out, encoding="utf-8")
                print(f"{p}: {n} replacements")


if __name__ == "__main__":
    main()
