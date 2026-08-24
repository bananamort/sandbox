# App/include/lua/LuaBridge.h

## Purpose

The core userdata bridging template machinery: `Bridge<Class, __eq>` (CRTP-style base wrapping a C++ class into Lua userdata with metatable handlers `__index`/`__newindex`/`__tostring`/`__eq`/`__gc`), `memberFunctionProxy`/`pushMemberFunction` (C-closure trampolines over member functions), `SharedPtrBridge<Class>` and `SingletonBridge<T>` — both implementing Matt Campbell's (Serotek) single-userdata-per-object reuse trick so the same object always maps to the same userdata (usable as table keys, no `__eq` needed).

## Declared API

- Free functions:
  - `void newweaktable(lua_State* L, const char* mode);`
  - `template<class C, int (C::*Func)(lua_State*)> int memberFunctionProxy(lua_State* thread);` — retrieves `C*` from upvalue 1 (lightuserdata), invokes member.
  - `template<class C, int (C::*Func)(lua_State*)> void pushMemberFunction(lua_State* L, C* c);` — pushes lightuserdata + cclosure with 1 upvalue.
- `template<class Class, bool __eq = true> class Bridge` ("TODO: Use traits pattern rather than bool __eq")
  - Statics: `pushNewObject(L)` ×3 (0/1/2-arg placement-new into `lua_newuserdata`, metatable by `className`); `getObject(L, index)` throwing via luaL_checkudata; template `getValue(L, index, V&)` non-throwing reimplementation of luaL_checkudata ("leaving value unchanged" on miss); `static void registerClass(lua_State* L);` (defined per-instantiation in .cpps).
  - Client-implementable hooks (comment: "The following members must be implemented by client"): protected/static `on_index(const Class&, const char*, lua_State*)`, `on_newindex(Class&, const char*, lua_State*)`, `on_tostring(const Class&, lua_State*)` ("may be specialized when StringConverter has no implementation for Class"); static `const char* className;`
  - Metatable dispatchers: on_gc (explicit dtor call), on_tostring/on_newindex/on_index (via lua_checkstring_secure), on_eq (uses `getObject(1)==getObject(2)`; only registered when `__eq==true`).
  - Portability wart: `protected:` applied ONLY under `_WIN32`; a quoted GCC error explains that non-Windows keeps these public because GCC rejects protected access from ScriptContext.cpp registerClass definitions.
- `template<class Class> class SharedPtrBridge : protected Bridge<boost::shared_ptr<Class>, false>` ("This class hides parent on purpose")
  - registerClass forwards; `registerClassLibrary(L)` creates registry entry keyed by `&push` holding a WEAK table (`newweaktable(L,"v")`) — "Declare the UserData re-use table".
  - `push(L, shared_ptr<Class>)`: NULL → nil; else looks up weak table by raw instance pointer, creating+storing a new userdata wrapper on miss (extensive stack-state comments; RBXASSERT "Did you forget to call registerClassLibrary??"; _DEBUG stack-balance check). Comment credits Matt Campbell at Serotek + lua-l link.
  - `getPtr(L, index)` returning empty shared_ptr for nil else getObject; template `getPtr(L, index, V&)` nil-tolerant getValue.
- `template<class T> class SingletonBridge : protected Bridge<T, false>` ("This class hides Bridge on purpose")
  - Same shape but `registerClassLibrary` uses a STRONG table (`lua_newtable`, comment "Not a weak table, unlike SharedPtrBridge") keyed by `&push`; push(T item) identical reuse logic keyed on the item pointer. TODO comment: "only allow explicit, one-time declaration".

## Usage notes

- Every Lua-facing type derives its bridge from one of these three (ObjectBridge, EventBridge, atomic-class bridges, Enum bridges...).
- Pairs with certified App/script docs where the .cpp-side registerClass implementations live.

## Gotchas

- SharedPtrBridge's reuse table is WEAK ("v" mode): an object with no other references loses its cached userdata — identity across table keys holds only while the C++ object is alive elsewhere.
- SingletonBridge's table is strong: entries pin the T value forever (fine for singletons/descriptor pointers, a leak otherwise).
- The `_WIN32`-only `protected:` on client hooks means cross-platform code must not rely on access levels here.
- `className` static must be set before first pushNewObject/getObject or metatable lookups fail.
