# App/Lua-5.1.4/src/ltable.c

## Purpose
Table implementation ($Id: ltable.c,v 2.32.1.2): array+hash dual layout with Brent's-variation chained scatter hashing; main-position computation per key type (`hashnum` handles ±0, strings use `tsv.hash`, pointers/objects via `IntPoint`), traversal (`luaH_next` array-then-hash order, dead-key tolerant `findindex`), rehash machinery (`computesizes/countint/numusearray/numusehash/resize` — the >50%-density array-part heuristic), get/set entry points, boundary search for `#` (`luaH_getn` + exponential/binary `unbound_search`), and LUA_DEBUG introspection hooks.

## API
```c
Table *luaH_new (lua_State *L, int narray, int nhash);
void   luaH_resizearray (lua_State *L, Table *t, int nasize);
void   luaH_free (lua_State *L, Table *t);
const TValue *luaH_getnum (Table *t, int key);      /* array part then hash */
const TValue *luaH_getstr (Table *t, TString *key);
const TValue *luaH_get    (Table *t, const TValue *key);
TValue *luaH_setnum (lua_State *L, Table *t, int key);
TValue *luaH_setstr (lua_State *L, Table *t, TString *key);
TValue *luaH_set    (lua_State *L, Table *t, const TValue *key);
int    luaH_next (lua_State *L, Table *t, StkId key);
int    luaH_getn (Table *t);
```

## Usage
- Backs every table operation in the VM and C API; Roblox bridge code touches it directly only through luaH_* calls (e.g. LuaInstanceBridge memoization tables).
- `luaH_set` resets `t->flags = 0`, invalidating cached metamethod lookups (`fasttm`) — next access re-reads metatables; NOTE this is stock asymmetry: `luaH_setnum`/`luaH_setstr` do NOT touch `flags`.

## Roblox modifications (vs stock Lua 5.1.4)
1. **`luaH_new` initializes the NEW `readonly` field to 0** (`// ROBLOX`) — the flag consumed by lapi.c/lvm.c write guards lives on every Table.
2. All algorithms otherwise stock 5.1.4.

## Gotchas
- The readonly flag is enforced by CALLERS (lapi.c rawset/rawseti/setmetatable; lvm.c settable) — `luaH_set` itself happily mutates readonly tables, so any new engine code writing tables must add its own guard or use the guarded API paths.
- `luaH_next` errors ("invalid key to 'next'") when handed a foreign key; pairs-under-mutation remains undefined stock behavior.
- Rehash can move ANY key between parts mid-operation — StkId-style caching of node pointers across inserts is invalid.
- `dummynode` is shared global const state: empty hash parts must never be written (guarded by newkey's `mp == dummynode` branch).

