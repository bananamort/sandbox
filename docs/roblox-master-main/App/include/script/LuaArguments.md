# App/include/script/LuaArguments.h

## Purpose

Declares `RBX::Lua::LuaArguments`, the `Reflection::FunctionDescriptor::Arguments` implementation that marshals between the Lua stack and reflection Variants for bound function calls, plus the free template `withVariantValue<R,F>` — a giant type-switch that expands a Variant into a strongly-typed lambda/functor call. This is the conversion chokepoint for every reflected API invoked from Lua.

## Declared API

- Free function (header-defined):
  - `template<typename R, typename F> R withVariantValue(const Reflection::Variant& value, F f)` — dispatches on the variant's held type in fixed order: void, bool, int, long, float, double, string, ProtectedString, shared_ptr<Instance>, enums (via EnumDescriptor lookup; throws `RBX::runtime_error("Invalid value for enum %s")` on miss), WeakFunctionRef, ValueArray/ValueMap/ValueTable, Instances, Tuple, GenericFunction, GenericAsyncFunction, G3D/RBX math types (Vector3int16, Vector2int16, Vector3, Vector2 [note: checks RBX::Vector2 but casts to G3D::Vector2], Rect2D, PhysicalProperties, RbxRay, CoordinateFrame, Color3, BrickColor, Region3, Region3int16, UDim, UDim2, Faces, Axes, CellID, ContentId), PropertyDescriptor*, rbx::signals::connection, NumberSequence, ColorSequence, NumberRange, NumberSequenceKeypoint, ColorSequenceKeypoint. Falls through to `RBXASSERT(0); return f();`.
- `namespace RBX::Lua`
  - `class LuaArguments : public Reflection::FunctionDescriptor::Arguments`
    - Private: `typedef DenseHashMap<const void*, bool> TablesCollection;` static `bool getRec(lua_State* L, int luaIndex, Reflection::Variant& value, bool treatNilAsMissing, TablesCollection* visitedTables = NULL);` members `const int offset; lua_State* const L;`
    - `LuaArguments(lua_State* L, int offset);` (inline)
    - `virtual size_t size() const` — inline: `lua_gettop(L) - 1`.
    - Statics:
      - `static shared_ptr<Reflection::Tuple> getValues(lua_State* L);` (inline — grabs whole stack as tuple)
      - `static int pushTuple(const Reflection::Tuple&, lua_State* L);` / `static int pushValues(const Reflection::ValueArray&, lua_State* L);` (inline; returns pushed count)
      - `static bool get(lua_State* L, int luaIndex, Reflection::Variant& value, bool treatNilAsMissing);`
      - Template inline `static int pushArray(_InIt _First, _InIt _Last, lua_State* const L)` — builds 1-indexed array table; asserts each push returns exactly 1.
      - `static int push(const Reflection::Variant&, lua_State* const L);`
      - `static int pushReturnValue(const Reflection::Variant&, lua_State* const L);`
      - `static shared_ptr<Reflection::Tuple> convertToReturnValues(const Reflection::Variant& value);`
    - Arguments-interface implementations (`/*implement*/`, mostly declared here, some defined in .cpp): `getVariant(int index, Variant&)` (inline; luaIndex = index + offset, treats nil as missing), `getLong` (inline via getDouble + iRound), `getDouble`, `getObject`, `getBool`, `getString`, `getVector3`, `getRegion3`, `getVector3int16`, `getRegion3int16`, `getRect`, `getPhysicalProperties`, `getEnum(index, desc, int& value)`.

## Usage notes

- Pairs with certified App/script docs (`docs/roblox-master-main/App/script/`) — certification recorded the spurious cyclic-table error on repeated array-table references originating from this file's `visitedTables` handling.
- `size()` assumes the function itself sits at stack index offset+... per luaL conventions; offset shifts argument indexing for method calls.

## Gotchas

- `withVariantValue` order matters: int is tested before long/float/double, and Vector3int16 before Vector3 — reordering silently changes overload resolution.
- The RBX::Vector2 branch casts to **G3D::Vector2** (aliasing assumption baked in).
- Fall-through case calls `f()` with no arguments after asserting — in release builds an unmatched variant quietly invokes the zero-arg overload.
- `pushArray` asserts count==1 per element but has no recovery path ("If not 1, then what do we do?" — verbatim comment).
- Cycle detection uses raw `const void*` table addresses in a DenseHashMap; repeated references to the same table are legal but the App/script certification documented residual false-positive error paths.
