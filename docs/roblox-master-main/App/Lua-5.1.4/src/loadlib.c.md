# App/Lua-5.1.4/src/loadlib.c

## Purpose
Dynamic library loader + package system ($Id: loadlib.c,v 1.52.1.3): platform backends for dlopen/Windows DLL/Darwin dyld/stub (`ll_load/ll_sym/ll_unloadlib`), `_LOADLIB` userdata registry with `__gc` unload, `package.loaders` chain (preload → Lua file → C file → C root), `require` with `_LOADED` bookkeeping and loop sentinel, `module()` with _M/_NAME/_PACKAGE init and caller setfenv, `package.seeall`, path resolution from env vars (LUA_PATH/LUA_CPATH with ";;" default-substitution) and `package.config`.

## API
```c
LUALIB_API int luaopen_package (lua_State *L);
/* package.*: loadlib seeall ; global: module require */
```

## Usage
- In the Roblox engine `luaopen_package` is NOT called on script VMs; require is instead provided by ScriptContext's own implementation over ProtectedStrings (see App/script notes). This file serves tool builds.

## Roblox modifications (vs stock Lua 5.1.4)
1. Byte-for-byte stock 5.1.4 — no deltas.
2. Security posture caller-side: opening package into any script state exposes arbitrary native code loading via package.loadlib — must stay unopened.

## Gotchas
- `loader_Lua` calls luaL_loadfile which text-parses — irrelevant in engine but a live path in tools.
- The `sentinel` trick marks in-progress modules; errors during module body leave the sentinel behind ("loop or previous error loading module").
- Windows `setprogdir` rewrites LUA_EXECDIR markers using GetModuleFileNameA (ANSI) — non-ASCII install paths garble cpath templates.

