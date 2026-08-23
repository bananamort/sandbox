# App/Lua-5.1.4/src/lauxlib.h

## Purpose
Public header of the auxiliary library ($Id: lauxlib.h,v 1.88.1.1): declares every `luaL_*` function (arg checking, errors, metatables, register, refs, loaders, newstate, gsub/findtable), the `luaL_Reg` registration struct, convenience macros (argcheck/checkstring/optstring/dofile/dostring/getmetatable/opt…), the `luaL_Buffer` struct and macros (`addchar/addsize/prepbuffer`), `LUA_ERRFILE`, compat shims (LUA_COMPAT_GETN, LUA_COMPAT_OPENLIB aliasing luaI_openlib→luaL_openlib), legacy ref macros (LUA_NOREF/LUA_REFNIL/lua_ref/lua_unref/lua_getref).

## API
Full stock declarations plus Roblox delta:
```c
// BEGIN ROBLOX CHANGES
namespace RBX { class ProtectedString; }
// END ROBLOX CHANGES

#define LUA_ERRFILE (LUA_ERRERR+1)
typedef struct luaL_Reg { const char *name; lua_CFunction func; } luaL_Reg;
typedef struct luaL_Buffer { char *p; int lvl; lua_State *L; char buffer[LUAL_BUFFERSIZE]; } luaL_Buffer;
/* ... all LUALIB_API luaL_* prototypes as in lauxlib.c ... */
```

## Usage
- Included by virtually every stdlib .c and by App/script bridge code for `luaL_check*`/`luaL_error`/`luaL_Buffer`; the canonical argument-validation vocabulary of the whole engine.

## Roblox modifications (vs stock Lua 5.1.4)
1. **Forward declaration injected** (`// BEGIN ROBLOX CHANGES`): `namespace RBX { class ProtectedString; }` — couples this header to engine types (paired with the includes in lauxlib.c). Note `luaL_roblox_typename` is NOT declared here despite being implemented in lauxlib.c (declared nowhere in-tree → callers must extern it; UNKNOWN whether any header elsewhere declares it).
2. All macro/prototype content otherwise stock 5.1.4.

## Gotchas
- `lua_ref(L, lock=0)` intentionally ERRORS ("unlocked references are obsolete") — legacy call sites must use luaL_ref.
- `luaL_Buffer` embeds LUAL_BUFFERSIZE bytes inline — large stack usage per instance; do not allocate arrays of them casually.
- The RBX namespace line makes this "pure C" header require C++ compilation in Roblox builds.

