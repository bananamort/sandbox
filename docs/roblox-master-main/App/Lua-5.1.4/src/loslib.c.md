# App/Lua-5.1.4/src/loslib.c

## Purpose
OS facility library ($Id: loslib.c,v 1.19.1.3): `os.clock` (CPU time), `os.date` (strftime formatting or *t table, UTC via '!' prefix), `os.time`/`os.difftime` (mktime-based, table fields with defaults), plus full-risk functions: `os.execute` (system()), `os.exit`, `os.getenv`, `os.remove/rename/tmpname`, `os.setlocale`. Error results follow nil+msg+errno triple convention (`os_pushresult`).

## API
```c
LUALIB_API int luaopen_os (lua_State *L);
/* registered: clock date difftime execute exit getenv remove rename setlocale time tmpname */
```

## Usage
- In the Roblox engine this library is NOT opened into script-facing VMs (ScriptContext hand-picks libraries); it exists for tool builds and completeness.

## Roblox modifications (vs stock Lua 5.1.4)
1. Byte-for-byte stock 5.1.4 — no deltas.
2. Security posture is entirely caller-side: any VM that runs `luaopen_os` gains shell/process/filesystem access; graft reviews should assert os stays unopened in script states.

## Gotchas
- `os.date` uses a 200-byte per-conversion buffer ("should be big enough") — pathological locale output could truncate silently.
- `os.tmpname` behavior differs by platform macro (LUA_USE_POSIX tmpnam vs mkstemp path) — see luaconf.h.
- `setlocale` from script would change number parsing globally for the process (interacts with llex.c decimal-point handling).

