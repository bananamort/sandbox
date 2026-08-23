# App/include/script/LuaEnum.h

## Purpose

Declares the Lua-side representations of the reflection enum system: `Enums` (the global `Enum` table over all `Reflection::EnumDescriptor`s), `Enum` (one descriptor), and `EnumItem` (one descriptor item). Each is a `SingletonBridge` over a raw pointer typedef, with declared `on_tostring` specializations for all three.

## Declared API

- `class RBX::Lua::AllEnumDescriptors {};` + `typedef const AllEnumDescriptors* AllEnumDescriptorsPtr;`
- `class RBX::Lua::Enums : public SingletonBridge<AllEnumDescriptorsPtr>`
  - `static void declareAllEnums(lua_State* L);`
  - `static bool getValue(lua_State* L, unsigned int index, RBX::Reflection::Variant& value);`
- `typedef const Reflection::EnumDescriptor* EnumDescriptorPtr;`
- `class RBX::Lua::Enum : public SingletonBridge<EnumDescriptorPtr> {}` — body empty; behavior via bridge template.
- `typedef const Reflection::EnumDescriptor::Item* EnumDescriptorItemPtr;`
- `class RBX::Lua::EnumItem : public SingletonBridge<EnumDescriptorItemPtr>`
  - `static EnumDescriptorItemPtr getItem(lua_State* L, unsigned int index);` (inline → `getObject`)
  - `static bool getItem(lua_State* L, unsigned int index, EnumDescriptorItemPtr& value);` (inline → `getValue`)
- Template specialization declarations:
  - `int Bridge<AllEnumDescriptorsPtr, false>::on_tostring(const AllEnumDescriptorsPtr&, lua_State* L);`
  - `int Bridge<EnumDescriptorPtr, false>::on_tostring(const EnumDescriptorPtr&, lua_State* L);`
  - `int Bridge<EnumDescriptorItemPtr, false>::on_tostring(const EnumDescriptorItemPtr&, lua_State* L);`

## Usage notes

- The tripled comment "Represents a Reflection::EnumDescriptor::Item in Lua" is copy-pasted above each class even where it describes a descriptor or the global table.
- Paired implementation documented under certified App/script module.

## Gotchas

- All three bridges hold RAW const pointers into reflection descriptors — descriptors must outlive every Lua VM using them.
- `getItem`'s two overloads differ only in return-vs-out-param style; both are unchecked casts of userdata at `index`.
