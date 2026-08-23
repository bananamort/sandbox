# App/Lua-5.1.4/src/lualib.h

## Purpose
Header declaring the standard-library openers ($Id: lualib.h,v 1.36.1.1): `luaopen_base/table/io/os/string/math/debug/package`, their global-name macros, `LUA_FILEHANDLE` registry key for io userdata, and the convenience aggregator `luaL_openlibs`. Also defines the no-op `lua_assert`.

## API
```c
#define LUA_FILEHANDLE  "FILE*"
#define LUA_COLIBNAME   "coroutine"    /* opened by luaopen_base */
#define LUA_TABLIBNAME  "table"
#define LUA_IOLIBNAME   "io"
#define LUA_OSLIBNAME   "os"
#define LUA_STRLIBNAME  "string"
#define LUA_MATHLIBNAME "math"
#define LUA_DBLIBNAME   "debug"
#define LUA_LOADLIBNAME "package"

LUALIB_API int  luaopen_base    (lua_State *L);
LUALIB_API int  luaopen_table   (lua_State *L);
LUALIB_API int  luaopen_io      (lua_State *L);
LUALIB_API int  luaopen_os      (lua_State *L);
LUALIB_API int  luaopen_string  (lua_State *L);
LUALIB_API int  luaopen_math    (lua_State *L);
LUALIB_API int  luaopen_debug   (lua_State *L);
LUALIB_API int  luaopen_package (lua_State *L);
LUALIB_API void luaL_openlibs   (lua_State *L);

#ifndef lua_assert
#define lua_assert(x) ((void)0)
#endif
```

## Usage
- `linit.c` (see linit.c.md) is the actual open sequence used by `lua.c`/`luac.c`; Roblox's ScriptContext does NOT call `luaL_openlibs` — it hand-picks libraries per security identity (see LuaCoreFunctions.cpp / ScriptContext.cpp), e.g. omitting io/package entirely on client VMs and replacing base-lib functions (`load`, `dofile`, `loadfile`) with sandbox stubs.

## Roblox modifications (vs stock Lua 5.1.4)
1. File content is stock; the delta is in what callers open. UNKNOWN: whether Roblox added extra luaopen_* elsewhere under this tree — none declared here.
2. Security model: because openers just register globals, Roblox achieves sandboxing by selective opening + post-open function replacement rather than modifying this header.

## Gotchas
- Opening `io` or `os` into a script-facing VM is a full filesystem/process escape — never call `luaL_openlibs` on a user VM in this codebase.
- `lua_assert` compiles to nothing unless overridden; internal asserts across libs are silently disabled in release builds.

