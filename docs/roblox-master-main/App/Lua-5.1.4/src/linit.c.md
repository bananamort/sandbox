# App/Lua-5.1.4/src/linit.c

## Purpose
Standard-library bootstrap ($Id: linit.c,v 1.14.1.1): defines the `lualibs[]` opener table (base under global name "", plus package/table/io/os/string/math/debug) and `luaL_openlibs`, which calls each opener as a C function receiving its global table name (openers create/register their globals and return nothing).

## API
```c
static const luaL_Reg lualibs[] = {
  {"", luaopen_base}, {LUA_LOADLIBNAME, luaopen_package},
  {LUA_TABLIBNAME, luaopen_table}, {LUA_IOLIBNAME, luaopen_io},
  {LUA_OSLIBNAME, luaopen_os}, {LUA_STRLIBNAME, luaopen_string},
  {LUA_MATHLIBNAME, luaopen_math}, {LUA_DBLIBNAME, luaopen_debug},
  {NULL, NULL}
};
LUALIB_API void luaL_openlibs (lua_State *L);
```

## Usage
- Used by `lua.c` (standalone interpreter) only in this tree. The Roblox engine NEVER calls it: `App/script/ScriptContext.cpp` builds VM globals by selectively invoking individual openers (string/math/table/debug subsets depending on Security::Identity) and then layering Roblox replacements (ypcall, wait, spawn, Instance, game, etc.).

## Roblox modifications (vs stock Lua 5.1.4)
1. File is byte-for-byte stock — no deltas. Its relevance is negative: any graft review should confirm engine code does not regress into calling `luaL_openlibs` on script-facing states.

## Gotchas
- Opener order matters: base first (it opens coroutine + registers _G machinery), package second.
- `lua_call` inside the loop means an opener error longjmps out unprotected from `luaL_openlibs`'s perspective.

