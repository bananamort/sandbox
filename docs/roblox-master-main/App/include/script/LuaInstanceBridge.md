# App/include/script/LuaInstanceBridge.h

## Purpose

Declares `RBX::Lua::ObjectBridge`, the glue that exposes `shared_ptr<Instance>` objects to Lua: userdata wrapping, the global `Instance` table (with `new`/`Lock`/`Unlock` functions), member-function dispatch, and the template specializations of `Bridge<shared_ptr<Instance>, false>` for `tostring` and `__newindex` behavior.

## Declared API

- Template specializations declared (defined elsewhere):
  - `template<> int Bridge<shared_ptr<Instance>, false>::on_tostring(const shared_ptr<Instance>& object, lua_State* L);`
  - `template<> void Bridge<shared_ptr<Instance>, false>::on_newindex(shared_ptr<Instance>& object, const char* name, lua_State* L);`
- `class ObjectBridge : public SharedPtrBridge<Instance>`
  - Private: `friend class SharedPtrBridge<Instance>;` `static const luaL_reg classLibrary[];`
  - `static int callMemberFunction(lua_State* L);`
  - `static int callMemberYieldFunction(lua_State* L);`
  - `static void registerInstanceClassLibrary(lua_State* L);` (inline) — calls `luaL_register(L, "Instance", classLibrary)`, then `lua_setreadonly(L, -1, true)` and pops the table.
  - `static int newInstance(lua_State* L);`
  - `static int lockInstance(lua_State* L);`
  - `static int unlockInstance(lua_State* L);`
  - `static boost::shared_ptr<Instance> getInstance(lua_State* L, unsigned int index);` (inline) — forwards to `getPtr(L, index)`.

## Usage notes

- Include order matters conceptually: needs both `"Lua/LuaBridge.h"` and `"V8Tree/Instance.h"`.
- Paired implementations live in the certified App/script module (`docs/roblox-master-main/App/script/`).

## Gotchas

- The inline comment in `registerInstanceClassLibrary` links the pop-after-register idiom to the lua-l thread about `luaL_register` leaving the table on the stack.
- `lua_setreadonly` on the registered table makes the global `Instance` namespace immutable from scripts.
- `getInstance`'s index parameter is `unsigned int` while most luaL APIs use `int` — passing negative stack indices will wrap.
