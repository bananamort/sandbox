# App/script/LuaEnum.cpp

## Purpose

Implements the three-level enum surface in Lua: global `Enum` (Bridge<AllEnumDescriptorsPtr>, className "Enums"), each enum descriptor (Bridge<EnumDescriptorPtr>, className "Enum") exposing items plus `GetEnumItems()`, and individual items (Bridge<EnumDescriptorItemPtr>, className "EnumItem") exposing read-only `Name`/`Value`. Backed entirely by reflection's EnumDescriptor registry.

## API

- Class names: `Bridge<AllEnumDescriptorsPtr,false>::className("Enums")`, `Bridge<EnumDescriptorPtr,false>::className("Enum")`, `Bridge<EnumDescriptorItemPtr,false>::className("EnumItem")`.
- `int Bridge<AllEnumDescriptorsPtr,false>::on_index(...)` — resolves via `Reflection::EnumDescriptor::lookupDescriptor(RBX::Name::lookup(name))`, pushes with `Enum::push`; throws "%s is not a valid EnumItem". `on_newindex` throws "Enums cannot be modified".
- `static int pushEnumList(lua_State*)` — builds a 1-based array of all items via `EnumItem::push` (assert-balanced stack).
- `int Bridge<EnumDescriptorPtr,false>::on_index(...)` — "GetEnumItems" returns pushEnumList C function; otherwise `object->lookup(name)` → `EnumItem::push`; throws "%s is not a valid EnumItem". `on_newindex` throws "Enum cannot be modified".
- `int Bridge<EnumDescriptorItemPtr,false>::on_index(...)` — "Name" → item name string; "Value" → numeric value; else "%s is not a valid member". `on_newindex` throws "EnumItem cannot be modified".
- `static AllEnumDescriptors dummy;` + `void Enums::declareAllEnums(lua_State *L)` — `Enums::push(L, &dummy); lua_setglobal(L, "Enum");`.
- `bool Enums::getValue(lua_State*, unsigned int index, RBX::Reflection::Variant&)` — converts an EnumItem userdata to its Variant value via `item->convertToValue(value)`.
- on_tostring specializations: Enums→"Enums"; Enum→descriptor name; EnumItem→`RBX::format("Enum.%s.%s", owner name, item name)`.

## Usage

Registered per VM in `ScriptContext::openState` (`Enums::registerClass/registerClassLibrary` then `declareAllEnums` at the very end of globals setup); consumed by `LuaArguments::getRec`'s userdata chain (`Enums::getValue` is tried FIRST among bridges) and by property assignment in LuaInstanceBridge (enum properties accept EnumItem userdata, numbers, or strings). Item conversion itself lives in Reflection (EnumDescriptor::Item::convertToValue), outside this module.

## Gotchas

- The entire global `Enum` tree is generated lazily through metatable __index resolution against the reflection registry — there is no prebuilt Lua table, so `Enum.X` costs a descriptor lookup each time (and unknown names throw "%s is not a valid EnumItem", note the misleading wording: it says EnumItem even at the Enum level).
- All three levels reject __newindex with distinct messages ("Enums"/"Enum"/"EnumItem cannot be modified"); combined with protect_metatable + readonly metatables from registerClass, enums are triple-locked.
- `getValue` returning true short-circuits ObjectBridge in LuaArguments' userdata dispatch — an EnumItem can never be mistaken for an Instance even if some descriptor name collided.
- The singleton `dummy` AllEnumDescriptors carries no data; identity of the global Enum object is per-VM userdata memoized by the bridge push machinery.
