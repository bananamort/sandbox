# App/Lua-5.1.4/src/lua.c

## Purpose
Standalone interpreter front-end ($Id: lua.c,v 1.160.1.2): `main` → protected `pmain`; opens all stdlibs (`luaL_openlibs`), handles CLI options (-e stat, -l lib, -i interactive, -v version, --, -), LUA_INIT env handling (@file or code), script execution with `arg` table, SIGINT→hook-based interruption (`laction` sets a call/return/count-1 hook whose `lstop` raises "interrupted!"), REPL loop with `<eof>` continuation detection and `_PROMPT` support, traceback-wrapped docall, and full-GC after errors.

## API
```c
int main (int argc, char **argv);
/* internal: pmain/docall/dofile/dostring/dotty/loadline/handle_script/
   collectargs/runargs/handle_luainit/traceback/lstop/laction */
```

## Usage
- Tool-only in this tree: the Roblox client/server never links lua.c's main; it exists so developers can run this Lua build standalone for experiments.

## Roblox modifications (vs stock Lua 5.1.4)
1. Byte-for-byte stock 5.1.4 — no deltas.
2. Ecosystem note: running this interpreter exercises the FULL stock library set (including debug/os/io/package since luaL_openlibs is used) — useful as a reference behavior oracle, but NOT representative of sandboxed engine VMs.

## Gotchas
- SIGINT interruption relies on hooks firing; tight C-function loops without VM dispatch won't interrupt until they return (stock limitation).
- `traceback` here calls the Lua-level `debug.traceback` — which this tree's ldblib never registers, so error reporting silently degrades to plain messages when using this binary.

