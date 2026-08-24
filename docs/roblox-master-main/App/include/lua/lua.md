# App/include/lua/lua.hpp

## Purpose

The C++ convenience umbrella over the vendored Lua 5.1 C API (`lua.h`/`lauxlib.h`/`lualib.h`) plus small RBX::Lua helpers: safe/throwable tostring variants, float coercion, metatable protection, a std::string push overload, secure string check, stack reset, and the RAII helpers `ScopedPopper` (auto-pop) and `ScopedState` (auto-close lua_State).

## Declared API

- Includes: `"lua.h"`, `"lauxlib.h"`, `"lualib.h"`.
- `namespace RBX::Lua`
  - `extern const char* safe_lua_tostring(lua_State* L, int idx);`
  - `extern const char* throwable_lua_tostring(lua_State* L, int idx);`
  - `extern float lua_tofloat(lua_State* L, int idx);`
  - `extern void protect_metatable(lua_State* thread, int index);`
  - Inline `void lua_pushstring(lua_State* thread, const std::string& s)` — forwards to `lua_pushlstring(thread, s.c_str(), s.size())`.
  - `const char* lua_checkstring_secure(lua_State* L, int idx);`
  - `void lua_resetstack(lua_State* L, int idx);`
  - `class ScopedPopper` — "Pops items from the stack when it goes out of scope": ctor `(thread, popCount)`; operators `+=`/`-=` adjust count; dtor calls `lua_pop(thread, popCount)`.
  - `class ScopedState` — ctor `luaL_newstate()`, dtor `lua_close(thread)`, implicit conversion to `lua_State*`.

## Usage notes

- Pairs with certified docs under `docs/roblox-master-main/App/Lua-5.1.4/` (the vendored VM) and `App/script/` (bridge layer).

## Gotchas

- The inline `lua_pushstring(std::string)` OVERLOADS the C macro/function — include order and namespace resolution determine which fires; inside RBX::Lua the C++ version wins for std::string args.
- ScopedPopper counts are absolute pops at scope exit — interleaving other stack manipulation between += and destruction changes what actually gets popped.
