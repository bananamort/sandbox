# App/Lua-5.1.4/src/lstring.c

## Purpose
String-interning table implementation (`$Id: lstring.c,v 2.8.1.1`): all Lua strings are unique per state; `luaS_newlstr` computes the stock Lua hash and reuses existing `TString`s. Also creates `Udata`.

## API
- `void luaS_resize(lua_State *L, int newsize)` — rebuilds `G(L)->strt` bucket array (no-op during `GCSsweepstring`); rehashes by `gco2ts(p)->hash`.
- `static TString *newlstr(lua_State*, const char*, size_t l, unsigned int h)` — allocates `TString`+bytes via `luaM_malloc`, sets `len/hash/marked(white)/tt=LUA_TSTRING/reserved=0`, NUL-terminates, chains into `strt`, grows table when `nuse > size && size <= MAX_INT/2`.
- `TString *luaS_newlstr(lua_State *L, const char *str, size_t l)` — hash seed = length; `h = h ^ ((h<<5)+(h>>2)+byte)` sampled every `(l>>5)+1` chars; linear scan of bucket comparing len + memcmp (resurrects dead string via `changewhite`).
- `Udata *luaS_newudata(lua_State *L, size_t s, Table *e)` — allocates, white-marked, `metatable=NULL`, `env=e`, **`u->uv.may_gc = true; /* ROBLOX */`**, chained after mainthread on GC list.

## Usage
- Called from `lapi.c` (`lua_pushlstring/lua_pushstring/lua_pushvfstring`), `llex.c` (token/identifier interning), `ltm.c` (`luaT_init`), `lobject.c`, all stdlibs.
- Engine note: Roblox's `ProtectedString` sources are *not* interned here as source text is kept outside the VM; only runtime strings hit this path.

## Roblox modifications (vs stock Lua 5.1.4)
1. **NEW line in `luaS_newudata`: `u->uv.may_gc = true;`** (marked `// ROBLOX`) — initializes the `Udata::may_gc` flag added in `lobject.h`; engine uses it to know which userdata may run `__gc`/trigger reentrancy.
2. Everything else stock 5.1.4.

## Gotchas
- Hash is computed over a *sample* of long strings — collisions across different long strings are possible but correctness is guaranteed by full memcmp in lookup.
- `luaS_resize` refuses during `GCSsweepstring`; growth requests mid-sweep are silently skipped until later.
