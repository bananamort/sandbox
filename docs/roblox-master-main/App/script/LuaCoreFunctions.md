# App/script/LuaCoreFunctions.cpp

## Purpose

Defines the three trimmed/rebuilt standard libraries that `ScriptContext::openState` installs instead of the stock Lua openers: `LuaOsExtension` (an `os` library containing only `difftime` and `time`, copied verbatim from loslib.c), `LuaMathExtension::noise` (classic Ken Perlin improved-noise added onto the stock math table), and `LuaDebugExtension` (a debug library containing only a Roblox-formatted `traceback`). This is where the "no io, no os filesystem access" sandbox posture is enforced for the os/debug surfaces.

## API

- `namespace LuaOsExtension { static int os_time(lua_State *L); static int os_difftime(lua_State *L); const luaL_Reg registry[] = { {"difftime", os_difftime}, {"time", os_time}, {NULL, NULL} }; }` — plus loslib-derived helpers `getboolfield(L,key)` and `getfield(L,key,d)`.
- `namespace LuaMathExtension { int noise(lua_State* L); }` — signature `noise(x [, y [, z]])`; reads `luaL_checknumber(L,1)`, `luaL_optnumber(L,2/3,0.0)`, returns classic Perlin noise computed with the 512-byte permutation table `kPerlin` and helpers `fade/lerp/grad/perlin` (all file-static).
- `namespace LuaDebugExtension { static int debug_traceback(lua_State *L); const luaL_Reg registry[] = { {"traceback", debug_traceback}, {NULL, NULL} }; }`.

## Usage

Consumed only by App/script/ScriptContext.cpp: `luaopen_os_rbx` does `luaL_register(L, "os", LuaOsExtension::registry)`; `luaopen_math_rbx` calls stock `luaopen_math(L)` then pushes `LuaMathExtension::noise` as field `"noise"`; `luaopen_debug_rbx` does `luaL_register(L, "debug", LuaDebugExtension::registry)`. All three are loaded through `loadLibraryProtected`, so the resulting tables are made readonly.

## Gotchas

- The os registry has exactly two functions — no `execute`, `remove`, `rename`, `getenv`, `exit`, `clock`, `date`, `setlocale`, `tmpname`. `os.time` still calls C `time(NULL)` and `mktime`, so real wall-clock time leaks into scripts (relevant to instrumentation that wants deterministic time).
- `debug.traceback` here does not use Lua's formatter; it delegates to `RBX::ScriptContext::printCallStack(L, &callStack, true)` (dontPrint=true) producing the engine's "Script 'x', Line N" format with Stack Begin/End markers, capped at 12 levels, and suppressed entirely when `DebugSettings::singleton().getStackTracingEnabled()` is false.
- `os_time`/`os_difftime` are marked as copy/paste from loslib.c — behavior matches stock Lua 5.1 including returning nil when `mktime` yields `(time_t)-1`.
- Perlin noise uses the canonical permutation table doubled to 512 entries; output range is roughly [-1,1] float precision (intermediate math is `float`, not double).
