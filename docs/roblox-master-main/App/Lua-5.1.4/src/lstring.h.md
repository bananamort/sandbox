# App/Lua-5.1.4/src/lstring.h

## Purpose
String-interning table interface (`$Id: lstring.h,v 1.43.1.1`): size helpers, creation entry points, and the `FIXEDBIT` pin. Stock.

## API
- `sizestring(s)` = `sizeof(union TString) + ((s)->len+1)*sizeof(char)` — note `(s)->len` reads through Roblox's `LuaVMValue<size_t>` wrapper (decodes under `LUAVM_SECURE`).
- `sizeudata(u)` = `sizeof(union Udata) + (u)->len`
- `luaS_new(L,s)` / `luaS_newliteral(L,s)` → `luaS_newlstr`
- `luaS_fix(s)` — set `FIXEDBIT` in `tsv.marked` (never-collect)
- `void luaS_resize(lua_State*, int newsize)`
- `Udata *luaS_newudata(lua_State*, size_t s, Table *e)`
- `TString *luaS_newlstr(lua_State*, const char *str, size_t l)`

## Usage
Everywhere strings are created/compared: `llex.c` (tokens), `lobject.c`, `ltm.c`, `lbaselib.c`, `lapi.c` (`lua_pushlstring`), parser identifiers.

## Roblox modifications (vs stock Lua 5.1.4)
None in this header's text; effective behavior differs because `TString::len/hash` are `LuaVMValue<T>` (see `lobject.h`) so the macros decode on access.

## Gotchas
- Interned strings are unique per `global_State`; two VMs (per-Security-Identity states in Roblox) have independent string tables.
