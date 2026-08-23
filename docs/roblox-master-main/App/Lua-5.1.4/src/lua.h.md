# App/Lua-5.1.4/src/lua.h

## Purpose
The public Lua C API header (`$Id: lua.h,v 1.218.1.5`) — state creation, stack manipulation, value push/get/set, call/load/dump, coroutine resume/yield, GC control, and the debug hook API. Stock in structure but with three Roblox-visible deltas: a **compile-time-shuffled type-tag enum**, two extra API functions, and an **extra debug-hook event**.

## API
Version constants (`LUA_VERSION "Lua 5.1"`, `LUA_RELEASE "Lua 5.1.4"`, `LUA_VERSION_NUM 501`), `LUA_SIGNATURE "\033Lua"`, `LUA_MULTRET`. Pseudo-indices: `LUA_REGISTRYINDEX (-10000)`, `LUA_ENVIRONINDEX`, `LUA_GLOBALSINDEX`, `lua_upvalueindex(i)`. Status codes `LUA_YIELD 1 … LUA_ERRERR 5`.

Types: opaque `lua_State`; `lua_CFunction (lua_State*)→int`; `lua_Reader`, `lua_Writer`, `lua_Alloc`; `lua_Number` (`double`), `lua_Integer` (`ptrdiff_t`); `lua_Debug`, `lua_Hook`.

Full function surface (all stock unless noted): `lua_newstate/close/newthread/atpanic`; stack ops `gettop/settop/pushvalue/remove/insert/replace/checkstack/xmove`; predicates `isnumber/isstring/iscfunction/isuserdata/type/typename/equal/rawequal/lessthan`; conversions `tonumber/tointeger/toboolean/tolstring/**tolstringsecure (ROBLOX)**/objlen/tocfunction/touserdata/tothread/topointer`; push `nil/number/integer/lstring/string/vfstring/fstring/cclosure/boolean/lightuserdata/thread`; get `table/field/rawget/rawgeti/createtable/**setreadonly (ROBLOX)**/newuserdata/getmetatable/getfenv`; set `table/field/rawset/rawseti/setmetatable/setfenv`; exec `call/pcall/cpcall/load/dump`; coroutines `yield/resume/status`; `gc` with options `LUA_GCSTOP…LUA_GCSETSTEPMUL`; misc `error/next/concat/getallocf/setallocf`; macros `pop/newtable/register/pushcfunction/strlen/is*/pushliteral/setglobal/getglobal/tostring/open/getregistry/getgccount`; compat aliases `lua_Chunkreader/writer`; `lua_setlevel`.

Debug API: events `LUA_HOOKCALL/RET/LINE/COUNT/TAILRET` **plus ROBLOX `LUA_HOOKERROR 5`**, masks `1<<event` including **`LUA_MASKERROR`**; functions `getstack/getinfo/getlocal/setlocal/getupvalue/setupvalue/sethook/gethook/gethookmask/gethookcount`. `struct lua_Debug` is stock (fields `event,name,namewhat,what,source,currentline,nups,linedefined,lastlinedefined,short_src[LUA_IDSIZE],i_ci`).

### The shuffled `lua_Type` enum (Roblox)
```c
enum lua_Type {
    LUA_TNIL,                       /* must be 0 due to lua_isnoneornil */
    LUAVM_SHUFFLE3(LUAVM_SHUFFLE_COMMA, LUA_TBOOLEAN, LUA_TLIGHTUSERDATA, LUA_TNUMBER),
    LUA_TSTRING,                    /* iscollectable(o) checks this */
    LUAVM_SHUFFLE4(LUAVM_SHUFFLE_COMMA, LUA_TTABLE, LUA_TFUNCTION, LUA_TUSERDATA, LUA_TTHREAD),
    LUA_T___COUNT,
};
```
With `LUAVM_SECURE` defined (see `App/include/script/LuaVM.h`), `LUAVM_SHUFFLEn` reorders its arguments (e.g. `SHUFFLE3 → a1,a2,a0`), so numeric tag values differ from stock and from any other build. Without it, identity order. `LUA_TSTRING` is deliberately kept immediately after `LUA_TNIL..LUA_TNUMBER` block so `iscollectable(o)` (`ttype >= LUA_TSTRING`) still works.

## Usage
- Included by every engine consumer through `App/include/lua/lua.hpp`; direct includes found in `App/script/LuaVM.cpp`, `LuaCoreFunctions.cpp/.h`, `ModuleScript.cpp`, `v8datamodel/PluginManager.cpp`.
- The script layer (`ScriptContext`, bridges, serializers) uses these calls exclusively; nothing outside `src/` touches internal headers except `LuaVMServer.cpp` (which embeds `lcode.c`/`lparser.c`) and `LuaSerializer.inl` (reads `Proto` directly).
- `lua_tolstringsecure` backs Roblox's secure-string handling of ProtectedString-derived data.

## Roblox modifications (vs stock Lua 5.1.4)
1. **NEW** `LUA_API const char *(lua_tolstringsecure)(lua_State*, int idx, size_t* len);` (line 160).
2. **NEW** `LUA_API void (lua_setreadonly)(lua_State*, int idx, bool value);` (line 194, marked `// ROBLOX`) — pairs with the `Table::readonly` byte in `lobject.h`.
3. `enum lua_Type` wrapped in `LUAVM_SHUFFLE3` / `LUAVM_SHUFFLE4` + sentinel `LUA_T___COUNT`; tag values become build-dependent when `LUAVM_SECURE` is on.
4. Debug hooks: **`LUA_HOOKERROR 5`** and **`LUA_MASKERROR (1<<5)`** inside `BEGIN/END ROBLOX CHANGES` markers — lets the debugger/monitor catch error-raising events (implemented in `ldebug.c`'s error paths).
Everything else matches stock 5.1.4.

## Gotchas
- Any code hardcoding tag numbers (e.g. serialized formats, switch statements on `lua_type`) breaks under `LUAVM_SECURE`; use the enum names only.
- `lua_setreadonly` takes a C++ `bool` (not `int`) — signature matters at ABI level since Lua here is compiled as C++.
- `LUA_HOOKERROR` fires through Roblox's modified `luaD_throw`/error paths, not present in upstream Luau either — migration must reimplement it if debugger parity is required.
- `lua_open()` macro maps to `luaL_newstate()`, which allocates using the engine allocator chain (via `luai_userstateopen` constructing `RobloxExtraSpace`).
