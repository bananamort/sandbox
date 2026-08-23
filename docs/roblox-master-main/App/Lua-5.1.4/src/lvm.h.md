# App/Lua-5.1.4/src/lvm.h

## Purpose
Header for the bytecode interpreter ($Id: lvm.h,v 2.5.1.1): fast coercion macros (`tostring`/`tonumber`), metamethod-aware equality (`equalobj`, `luaV_equalval`) and ordering (`luaV_lessthan`), table access with full `__index`/`__newindex` chains (`luaV_gettable/settable`), the interpreter loop itself (`luaV_execute`), and concat with `__concat` fallback (`luaV_concat`).

## API
```c
#define tostring(L,o)  ((ttype(o) == LUA_TSTRING) || (luaV_tostring(L, o)))
#define tonumber(o,n)  (ttype(o) == LUA_TNUMBER || (((o) = luaV_tonumber(o,n)) != NULL))
#define equalobj(L,o1,o2) (ttype(o1) == ttype(o2) && luaV_equalval(L, o1, o2))

LUAI_FUNC int            luaV_lessthan  (lua_State *L, const TValue *l, const TValue *r);
LUAI_FUNC int            luaV_equalval  (lua_State *L, const TValue *t1, const TValue *t2);
LUAI_FUNC const TValue  *luaV_tonumber  (const TValue *obj, TValue *n);
LUAI_FUNC int            luaV_tostring  (lua_State *L, StkId obj);
LUAI_FUNC void           luaV_gettable  (lua_State *L, const TValue *t, TValue *key, StkId val);
LUAI_FUNC void           luaV_settable  (lua_State *L, const TValue *t, TValue *key, StkId val);
LUAI_FUNC void           luaV_execute   (lua_State *L, int nexeccalls);
LUAI_FUNC void           luaV_concat    (lua_State *L, int total, int last);
```

## Usage
- `luaV_execute` is where Roblox's obfuscated dispatch lives: instructions are fetched as `InstructionV` and decoded per-fetch via the VM's `global_State::ckey` (`rbxDecodeOp`); every opcode handler in lvm.c.md operates on decoded values.
- `luaV_gettable/settable` are also called from C bridges (LuaInstanceBridge property access) — they honor metatables including function and table `__index`.
- `safe_lua_tostring` in App/script/LuaAtomicClasses.cpp wraps `tostring`-equivalent logic for crash-safe bridge logging.

## Roblox modifications (vs stock Lua 5.1.4)
1. Header surface is stock; deltas concentrate in lvm.c (obfuscated fetch/decode, `luaG_checkcode` integration).
2. UNKNOWN: whether Roblox changed any macro here (none visible).

## Gotchas
- `tonumber(o,n)` ASSIGNS to `o` as a side effect on success (macro trick) — reusing `o` afterwards sees the converted number.
- `luaV_tostring` only converts actual numbers, and formats via `lua_number2str` → `LUA_NUMBER_FMT "%.14g"` (luaconf.h); it does NOT call `__tostring` — 5.1 handles that in `luaL_callmeta(L, obj, "__tostring")` inside lbaselib.c's `luaB_tostring` (no `luaL_tolstring` exists in this tree).
- Re-entrancy: metamethods triggered inside gettable/concat can reallocate the stack — all StkId caches must use savestack/restorestack.

