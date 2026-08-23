# App/Lua-5.1.4/src/ldblib.c

## Purpose
Lua-to-debug-API bridge library ($Id: ldblib.c,v 1.104.1.3) — INERT IN THIS TREE. Stock contents (all compiled out): debug.getregistry/getmetatable/setmetatable/getfenv/setfenv, getinfo/getlocal/setlocal, getupvalue/setupvalue, sethook/gethook (with registry-keyed hook dispatch wrapper `hookf`), interactive `debug.debug` REPL, and `traceback` builder (LEVELS1/LEVELS2 elision).

## API
```c
LUALIB_API int luaopen_debug (lua_State *L);   /* registers NOTHING here */
/* entire dblib[] and helpers wrapped in #if 0 */
```

## Usage
- `luaopen_debug` may still be invoked by engine bootstrap, but it is a no-op: no global `debug` table is created. Engine-side introspection instead uses DebuggerManager.cpp directly against ldebug.h/lstate.h internals.

## Roblox modifications (vs stock Lua 5.1.4)
1. **Whole library body commented out via `#if 0` … `#endif`** with banner `// ROBLOX CHANGES: file commented out for security`.
2. **`luaopen_debug` neutered**: the `luaL_register(L, LUA_DBLIBNAME, dblib)` call sits commented between `// BEGIN ROBLOX CHANGES` / `// END ROBLOX CHANGES`.
3. Net effect vs stock: scripts have NO debug.sethook/getinfo/traceback access at all; hook-based exploits and metatable/upvalue tampering through `debug.*` are eliminated by omission rather than patching.

## Gotchas
- Any ported stdlib or user code referencing `debug.*` must be rewritten against engine APIs (or DebuggerManager-style C++ paths).
- Because registration is skipped rather than stubbed per-function, error messages will be "attempt to index nil" on `debug`, not "disabled" hints.
- UNKNOWN: whether some Roblox build re-enables parts of this file via a different define — none present here (`#if 0` is unconditional).

