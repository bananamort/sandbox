# App/script/LuaBridge.cpp

## Purpose

Explicit template-instantiation anchor for `RBX::Lua::Bridge<Class, __eq>`, the templated userdata wrapper that exposes C++ value types (Vector3, Color3, CoordinateFrame, BrickColor, Faces, Axes, UDim/UDim2, Region3, CellID, enums, connections, libraries, sequences, thread nodes, generic functions) to Lua. This translation unit exists almost entirely to force the compiler to emit two member templates — `on_tostring` and `registerClass` — for every bridged class, because MSVC cannot see them if they live only in the header (the long comment block quotes the C++ FAQ and an internal "Porting Error Cases Document").

## API

- `template<class Class, bool __eq> int Bridge<Class, __eq>::on_tostring(const Class& object, lua_State *L)` — converts via `RBX::StringConverter<Class>::convertToString(object)` and pushes the string; returns 1.
- `template<class Class, bool __eq> void Bridge<Class, __eq>::registerClass(lua_State *L)` — creates the metatable via `luaL_newmetatable(L, className)`, calls `Lua::protect_metatable(L, -1)`, sets fields `__type` (= className string), `__index` = on_index, `__newindex` = on_newindex, `__gc` = on_gc, conditionally `__eq` = on_eq when `__eq` is true, `__tostring` = on_tostring; then `lua_setreadonly(L, -1, true)` and pops.
- Explicit instantiations of `on_tostring` for: `G3D::Color3`, `RBX::RbxRay`, `G3D::Vector3int16`, `G3D::Vector2int16`, `G3D::Vector3`, `RBX::Vector2`, `RBX::Rect2D`, `PhysicalProperties`, `RBX::BrickColor`, `G3D::CoordinateFrame`, `RBX::Faces`, `RBX::Axes`, `RBX::CellID`, `RBX::UDim`, `RBX::UDim2`.
- Explicit instantiations of `registerClass` for: `RBX::Axes`, `RBX::CellID`, `RBX::Faces`, `RBX::BrickColor`, `RBX::RbxRay`, `RBX::Region3`, `RBX::Region3int16`, `G3D::Color3`, `boost::intrusive_ptr<WeakThreadRef::Node>`, `shared_ptr<GenericFunction>`, `shared_ptr<GenericAsyncFunction>`, `shared_ptr<RBX::Instance>` (`__eq=false`), `rbx::signals::connection`, `Library`, `EventInstance`, `AllEnumDescriptorsPtr`, `EnumDescriptorPtr`, `EnumDescriptorItemPtr` (last three `__eq=false`), `RBX::NumberSequenceKeypoint`, `RBX::ColorSequenceKeypoint`, `RBX::NumberSequence`, `RBX::ColorSequence`, `RBX::NumberRange`.

## Usage

The `registerClass(...)` calls enumerated in `ScriptContext::openState` (App/script/ScriptContext.cpp lines ~670–740) rely on these instantiations existing at link time; per-class behavior such as `on_index`/`on_gc`/`pushNewObject` is specialized in each feature's own TU (e.g. `LuaEnum.cpp` specializes `on_tostring` per the comment; `ThreadRef.cpp` specializes index/newindex for `WeakThreadRef::Node`; `LuaInstanceBridge.cpp` handles instances). The header with the primary template lives outside this module (included as `"Lua/LuaBridge.h"`).

## Gotchas

- `registerClass` marks every bridge metatable readonly through the custom 5.1 patch `lua_setreadonly` in addition to `protect_metatable`'s `__metatable` lock — two independent protection layers that a Luau graft must reproduce or replace (Luau has its own readonly-table support, but semantics must be verified).
- `__type` stores the class name as a plain string field on the metatable — this is how Lua-side code identifies userdata kinds; scripts can read it but not change it (readonly metatable).
- `__gc` is registered unconditionally even where the object may be a value type; actual finalizer behavior comes from the per-class specialization of `on_gc`, not this file.
- The `__eq` registration is compile-time conditional on the second template parameter; `shared_ptr<Instance>`, enum descriptors use `false` so identity comparison falls back to stock Lua equality on userdata pointers.
