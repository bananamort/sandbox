# App/Lua-5.1.4/src/ltm.c

## Purpose
Tag-method implementation (`$Id: ltm.c,v 2.8.1.1`): type-name table, metamethod-name initialization, cached lookup.

## API
- `const char *const luaT_typenames[]` — names indexed by type tag; **shuffled** in lockstep with `lua.h`'s `lua_Type` (nil / SHUFFLE3(boolean,userdata,number) / string / SHUFFLE4(table,function,userdata,thread) / "proto","upval"). Note: the literal list still contains `"userdata"` twice (positions of LUA_TUSERDATA and the internal tag slot) exactly as stock.
- `void luaT_init(lua_State *L)` — for i in [0,TM_N): `G(L)->tmname[i] = luaS_new(L, luaT_eventname[i]); luaS_fix(...)`. The eventname array is shuffled identically to the `TMS` enum in `ltm.h`.
- `const TValue *luaT_gettm(Table *events, TMS event, TString *ename)` — `luaH_getstr`; on nil caches absence via `events->flags |= 1u<<event`.
- `const TValue *luaT_gettmbyobj(lua_State*, const TValue*, TMS)` — metatable from table/userdata or `G(L)->mt[ttype(o)]`.

## Usage
`luaT_init` is called once per state from `lstate.c` (`f_luaopen`). Lookups used pervasively by `lvm.c`, `ltable.c`, `ldo.c`, `lgc.c`, `lbaselib.c`.

## Roblox modifications (vs stock Lua 5.1.4)
1. `luaT_typenames[]` and `luaT_eventname[]` wrapped in `LUAVM_SHUFFLE3/4/7/5` macros (compile-time order shuffling under `LUAVM_SECURE`), matching the shuffled `lua_Type` and `TMS`.
2. Otherwise stock; `lua_assert(event <= TM_EQ)` inside `luaT_gettm` maps to `RBXASSERT` in debug builds.

## Gotchas
- Because both enum *and* name array are shuffled with the same permutation, lookups stay correct; editing one side without the other silently misroutes every metamethod.
- `luaS_fix` marks the 17 metamethod names permanent in the string table.
