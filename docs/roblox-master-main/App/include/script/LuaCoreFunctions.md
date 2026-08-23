# App/include/script/LuaCoreFunctions.h

## Purpose

Declares the extra C-function registries grafted onto Lua's standard libraries: `LuaOsExtension::registry` and `LuaDebugExtension::registry` (arrays of `luaL_Reg` merged into `os`/`debug`), and `LuaMathExtension::noise(lua_State*)` (the Roblox `math.noise` Perlin function).

## Declared API

- `namespace LuaOsExtension { extern const luaL_Reg registry[]; }`
- `namespace LuaMathExtension { int noise(lua_State* L); }`
- `namespace LuaDebugExtension { extern const luaL_Reg registry[]; }`

## Usage notes

- Includes `"lauxlib.h"` directly (Lua 5.1 vendored under App/Lua-5.1.4 — certified module).
- Registration happens where ScriptContext opens standard libraries; see certified App/script docs for the exact merge point.

## Gotchas

- Header-only declarations: which functions live in each registry is only visible in the .cpp.
- `noise` returns int (lua_State* convention) — it is a raw CFunction, not wrapped in bridge machinery.
