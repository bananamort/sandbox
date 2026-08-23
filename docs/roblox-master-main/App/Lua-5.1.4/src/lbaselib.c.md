# App/Lua-5.1.4/src/lbaselib.c

## Purpose
Base library + coroutine library ($Id: lbaselib.c,v 1.191.1.6): registers `_G` functions (print, tonumber/tostring, type, error/assert, pcall/xpcall, next/pairs/ipairs, rawget/rawset/rawequal, set/getmetatable, set/getfenv, select, unpack, load/loadstring/loadfile/dofile, collectgarbage/gcinfo, newproxy) plus `coroutine.*` (create/resume/yield/status/wrap/running) via `luaopen_base`; installs `_VERSION`, wires pairs/ipairs generator upvalues and newproxy's weak-table upvalue.

## API
```c
LUALIB_API int luaopen_base (lua_State *L);
/* static luaB_* implementations; base_funcs[] / co_funcs[] tables */
```

## Usage
- Roblox opens base selectively from ScriptContext and then REPLACES entries at script level (pcall→ypcall, load/loadstring/dofile→notImplemented stubs, loadfile→signature-checked). The versions here are the pre-replacement baseline; anything the engine forgets to replace is fully functional stock behavior.

## Roblox modifications (vs stock Lua 5.1.4)
1. **Engine includes** (`// ROBLOX:`): `lobject.h`, `FastLog.h`, `Util/ProtectedString.h`.
2. **`collectgarbage` neutered**: option table reduced to `{"count"}` only under `#if 1` (comment: allowing users to mess with gc may be dangerous; count is OK). Note default arg is still `"collect"` → passing no argument raises "invalid option 'collect'".
3. **`newproxy` hardened twice**:
   - Every proxy's Udata gets `uv.may_gc = false` (reaches into the header via `u--`) — comment: GC handler runs non-sandboxed, so users must never hook it (pairs with lgc.c GCTM check).
   - Shared-metatable form disabled under `#if 1`: `newproxy(proxy)` errors "newproxy only supports the arguments nil and true"; original weaktable-validated path retained in dead `#else`.
4. All other functions byte-for-byte stock.

## Gotchas
- Because may_gc=false is set for ALL user proxies, user __gc metamethods on newproxy userdata NEVER run in this engine — ported code relying on finalization silently leaks.
- print writes to stdout via fputs — in production it is typically replaced or routed elsewhere by the engine before scripts see it.
- getfenv/setfenv remain fully functional here; Roblox sandboxing relies on environment chaining done by ScriptContext, not removal of these.

