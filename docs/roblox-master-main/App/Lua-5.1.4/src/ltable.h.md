# App/Lua-5.1.4/src/ltable.h

## Purpose
Header for the table implementation ($Id: ltable.h,v 2.10.1.1): node accessor macros over the array+hash layout (`gnode/gkey/gval/gnext/key2tval`), typed and generic get/set entry points, table creation with pre-sized array/hash parts, `luaH_next` (drives `next`/`pairs`), and `luaH_getn` (border computation for `#`).

## API
```c
#define gnode(t,i) (&(t)->node[i])
#define gkey(n)    (&(n)->i_key.nk)
#define gval(n)    (&(n)->i_val)
#define gnext(n)   ((n)->i_key.nk.next)
#define key2tval(n)(&(n)->i_key.tvk)

LUAI_FUNC const TValue *luaH_getnum (Table *t, int key);
LUAI_FUNC TValue       *luaH_setnum (lua_State *L, Table *t, int key);
LUAI_FUNC const TValue *luaH_getstr (Table *t, TString *key);
LUAI_FUNC TValue       *luaH_setstr (lua_State *L, Table *t, TString *key);
LUAI_FUNC const TValue *luaH_get    (Table *t, const TValue *key);
LUAI_FUNC TValue       *luaH_set    (lua_State *L, Table *t, const TValue *key);
LUAI_FUNC Table        *luaH_new    (lua_State *L, int narray, int lnhash);
LUAI_FUNC void          luaH_resizearray (lua_State *L, Table *t, int nasize);
LUAI_FUNC void          luaH_free   (lua_State *L, Table *t);
LUAI_FUNC int           luaH_next   (lua_State *L, Table *t, StkId key);
LUAI_FUNC int           luaH_getn   (Table *t);

#if defined(LUA_DEBUG)
LUAI_FUNC Node *luaH_mainposition (const Table *t, const TValue *key);
LUAI_FUNC int   luaH_isdummy (Node *n);
#endif
```

## Usage
- Every field/index read in the VM funnels through `luaH_getstr/getnum/get`; metatable dispatch happens ABOVE this layer (`luaV_gettable` → `luaT_gettmbyobj`), except `luaH_getstr` on `__index` chains.
- `LuaInstanceBridge.cpp`'s property memoization relies on `luaH_setstr` inserting into the environment-index table; `DebuggerManager` reads node internals via these macros when walking locals.
- `pairs`/`next` semantics come straight from `luaH_next`'s iteration order — array part first, then hash chain order (unspecified but stable within a run).

## Roblox modifications (vs stock Lua 5.1.4)
1. Header is stock 5.1.4; no Roblox additions.
2. Behavioral deltas live elsewhere: `__metatable` dual protection and `setreadonly` are enforced by callers of `luaH_set*` (Roblox patch in lvm/ltm/api layer), not here.

## Gotchas
- `luaH_set*` returns the slot WITHOUT invoking metamethods or write barriers — barriers are handled inside via `luaC_barriert`, but semantic protection (readonly tables) must be checked before calling.
- Inserting a nil value through `luaH_set` is how deletion works; assigning nil via raw APIs skips `__newindex`.
- `luaH_getn` returns a border, not necessarily length semantics users expect after holes; `#t` instability across rehashes is stock behavior.

