# App/Lua-5.1.4/src/ltm.h

## Purpose
Tag-method (metamethod) declarations (`$Id: ltm.h,v 2.6.1.1`): the `TMS` enum, fast metamethod lookup macro, and prototypes. In this tree the enum is **Roblox-shuffled** like the type tags.

## API
```c
typedef enum {
  LUAVM_SHUFFLE4(LUAVM_SHUFFLE_COMMA, TM_INDEX, TM_NEWINDEX, TM_GC, TM_MODE),
  TM_EQ,                       /* last tag method with `fast' access */
  LUAVM_SHUFFLE7(LUAVM_SHUFFLE_COMMA, TM_ADD, TM_SUB, TM_MUL, TM_DIV, TM_MOD, TM_POW, TM_UNM),
  LUAVM_SHUFFLE5(LUAVM_SHUFFLE_COMMA, TM_LEN, TM_LT, TM_LE, TM_CONCAT, TM_CALL),
  TM_N
} TMS;
```
- `gfasttm(g,et,e)` — NULL-safe cached lookup honoring `Table::flags` bit per event; `fasttm(l,et,e) = gfasttm(G(l),et,e)`
- `LUAI_DATA const char *const luaT_typenames[];`
- `const TValue *luaT_gettm(Table *events, TMS event, TString *ename)`
- `const TValue *luaT_gettmbyobj(lua_State*, const TValue*, TMS)`
- `void luaT_init(lua_State*)`

## Usage
`fasttm` is used by `lvm.c` (GETTABLE/arithmetic), `lvm.h` (`luaV_index`, `luaV_getnotm`...), `ltable.c`, `ldo.c` (`__call`), `lgc.c` (`TM_GC` finalization), `lapi.c`.

## Roblox modifications (vs stock Lua 5.1.4)
The `TMS` enumerator order is wrapped in `LUAVM_SHUFFLE4/7/5(LUAVM_SHUFFLE_COMMA, …)` — with `LUAVM_SECURE` the numeric values of `TM_INDEX…TM_CALL` differ from stock and between builds. Constraint preserved: `TM_EQ` remains the last "fast access" tag method and the stock `/* ORDER TM */` contract (eventname array in `ltm.c` must match enum order) still holds because both sides are shuffled identically.

## Gotchas
- `Table::flags` caches "metamethod absent" as `1<<event`; because event values are shuffled, flags bits are build-specific too — never persist them.
- Anything serializing metatable info by numeric TMS breaks under `LUAVM_SECURE`.
