# App/Lua-5.1.4/src/lauxlib.c

## Purpose
Auxiliary library built purely on the public API ($Id: lauxlib.c,v 1.159.1.3): error reporting (`luaL_argerror/typerror/error/where`), argument checking (`checklstring/optlstring/checknumber/optnumber/checkinteger/optinteger/checktype/checkany/checkoption/checkstack`), metatable utilities (`newmetatable/checkudata/getmetafield/callmeta`), module registration (`luaL_register`, `luaI_openlib` with _LOADED bookkeeping), optional LUA_COMPAT_GETN getn/setn, string substitution (`gsub`), namespace walker (`findtable`), the buffered-string builder (`luaL_Buffer`: prepbuffer/addlstring/addstring/addvalue/pushresult), reference registry (`luaL_ref/unref`), file/buffer loaders (`loadfile` with `#!` + binary sniff and reopen, `loadbuffer`, `loadstring`), default allocator (`l_alloc`), panic handler, and `luaL_newstate`.

## API
```c
/* stock LUALIB_API surface of 5.1.4 */
int    luaL_argerror/typerror/error(...);  void luaL_where(...);
const char *luaL_roblox_typename(lua_State *L, unsigned int index);  /* ROBLOX NEW */
void   luaL_checktype/checkany/checkstack (...);
const char *luaL_checklstring/optlstring (...);
lua_Number luaL_checknumber/optnumber;  lua_Integer luaL_checkinteger/optinteger;
int    luaL_getmetafield/callmeta/ref;   void luaL_unref;
void   luaL_register / luaI_openlib (lua_State*, const char*, const luaL_Reg*, int nup);
char  *luaL_prepbuffer;  void luaL_addlstring/addstring/addvalue/pushresult/buffinit;
const char *luaL_gsub/findtable;
int    luaL_loadfile/loadbuffer/loadstring;
lua_State *luaL_newstate (void);
```

## Usage
- Foundation for every stdlib in this tree AND heavily used by App/script bridges (`luaL_error`/`luaL_argerror` messages surface verbatim in script errors; `luaL_ref` backs ThreadRef-style references).
- `luaL_loadfile` is NOT reachable from sandboxed scripts (engine replaces loadfile with signature-checked stubs) but remains linked for tools.

## Roblox modifications (vs stock Lua 5.1.4)
1. **Engine includes added** (`// BEGIN ROBLOX CHANGES` block): `Util/ProtectedString.h`, `Util/MD5Hasher.h`, `V8DataModel/DataModel.h`, `V8DataModel/HackDefines.h`. UNKNOWN: no direct symbol from MD5Hasher/ProtectedString appears in this file — likely pulled in for inline helpers or vestigial.
2. **NEW `luaL_roblox_typename`**: for userdata, fetches metatable field `__type`, then verifies `registry[__type] == actual metatable` via `lua_rawequal` before trusting it — explicitly defeats "newproxies spoofing __type metafield" (in-source comment); falls back to `luaL_typename`. `luaL_typerror` routes through it, so ALL "X expected, got Y" messages can report Roblox-facing type names (e.g. "Instance").
3. Everything else is stock flow-for-flow.

## Gotchas
- `luaL_roblox_typename` manipulates stack slots (-3..-1) internally; safe only because every branch balances — do not refactor casually.
- `luaL_ref` uses integer keys starting at 1 with free-list head at registry slot 0 (FREELIST_REF=0) — bridge code must not pollute that slot.
- `luaL_loadfile`'s binary sniff reopens with freopen("rb") and skips to LUA_SIGNATURE — on Windows text mode this matters; irrelevant to engine but relevant to luac-style tooling.
- Buffer functions assume ≤LUA_MINSTACK/2 pending strings; mixing raw pushes between buffinit and pushresult breaks level accounting.

