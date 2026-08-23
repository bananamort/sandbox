# App/Lua-5.1.4/src/ltablib.c

## Purpose
Table manipulation library ($Id: ltablib.c,v 1.38.1.3): `table.concat` (luaL_Buffer join with separator/range), deprecated iterators `foreach`/`foreachi`, `getn`/`setn`/`maxn` compat shims, `table.insert`/`table.remove` (shift-based, honoring the `n` convention via luaL_getn/setn), and `table.sort` — Sedgewick quicksort with median-of-three pivot, custom comparator support, "invalid order function" guard, smaller-half recursion.

## API
```c
LUALIB_API int luaopen_table (lua_State *L);
/* registered: concat, foreach, foreachi, getn, maxn, insert, remove, setn, sort */
```

## Usage
- Fully available to scripts in every Roblox VM; sort's comparator runs arbitrary script code mid-sort (yield/re-entrancy surface).

## Roblox modifications (vs stock Lua 5.1.4)
1. Byte-for-byte stock 5.1.4 — no deltas.
2. Interaction note: `insert/remove/sort` use `lua_rawseti`, which under this tree raises "Attempt to modify a readonly table" on protected tables (guard lives in lapi.c) — so scripts cannot mutate readonly tables even through these helpers.

## Gotchas
- `sort` comparator errors leave the table partially permuted (documented stock behavior).
- `concat` errors on non-string/number elements ("invalid value (%s) at index %d").
- `foreach`/`foreachi` are deprecated-but-present; clearing table entries during traversal remains undefined.

