# App/include/reflection/EnumConverter.h

## Purpose

Declares the enum side of the reflection type system: `EnumDescriptor` (Type subclass enumerating Items with lookup/conversion contracts), the template `EnumDesc<Enum>` (header-implemented bidirectional tables: int↔enum, name↔enum incl. legacy names, index↔enum), `Singleton<T>` thread-safe once-flag helper, `EnumRegistrar<Enum>` link-enforcement idiom, and the `RBX_REGISTER_ENUM` macro that specializes Type::getSingleton and instantiates registrars.

## Declared API

- `class EnumDescriptor : public Type`
  - Statics: enumsBegin()/enumsEnd()/inline allEnumSize(); private allEnumsNameLookup() (EnumNameTable = std::map<const RBX::Name*, const EnumDescriptor*>; a `#if 0` shows an abandoned boost::unordered_map variant), allEnums(), static count.
  - Nested `class Item : public Descriptor` — members `const EnumDescriptor& owner; const int value; const size_t index;` ("place in ordered enum values (0<=index<enumCount)") inline ctor + convertToValue(Variant&)/convertToString(std::string&) delegating to owner by index.
  - Protected: `std::vector<const Item*> allItems; size_t enumCount; size_t enumCountMSB;` protected ctor(typeName)/dtor.
  - Public: getEnumCount/getEnumCountMSB; begin/end over items; static inline lookupDescriptor(const RBX::Name&) via map, static lookupDescriptor(const Type&) via isEnum flag + static_cast; isValue(int) linear find_if.
  - Pure virtuals: `lookup(const char* text)`, `lookup(const Variant&)`, `convertToValue(size_t, Variant&)`, `convertToString(size_t, std::string&)`.
- `template<typename T> class Singleton : boost::noncopyable` — "A thread-safe singleton!": function-local static in doGetSingleton + boost::call_once init; public `static T& singleton();`
- `template<typename Enum> class EnumDesc : public EnumDescriptor`
  - Friend Singleton<const EnumDesc<Enum>>; public static singleton().
  - Private: user-must-implement ctor; dtor forces EnumRegistrar linking (`registrar.dummy()`) and deletes items.
  - Tables: `nameToEnum`, `nameToEnumLegacy` (Name*-keyed maps), `enumToName`/`enumToString`/`enumToItem` (sparse vectors with gaps), `intToEnum` ("maps legacy values to proper enum", gap-filled with (Enum)-1), `indexToEnum`, `enumToIndex`.
  - Registration helpers (ctor-time): `addPair(Enum value, const char* name, Attributes = {})` — asserts non-negative, NO spaces, NOT CamelCase (`isCamel(name)`); builds Item and all cross-tables, bumps enumCount/MSB. `addLegacy(int oldValue, name, value)` / `addLegacyName(name, value)`.
  - Conversions: convertToName/convertToString/convertToItem(Enum) — bounds-checked, null-name/""/NULL on out-of-range or negative; mapIntValue(int, Enum&) honoring -1 sentinel gaps; convertToValue(Name|const char*, Enum&) checking legacy map second; lookup(char*/Variant); convertToValue(index→Variant|Enum), convertToString(index, string&); convertToIndex(Enum) returning (size_t)-1 out-of-range.
- Macro `RBX_REGISTER_ENUM(Enum)` — defines Type::getSingleton<Enum> specialization + EnumRegistrar and TypeRegistrar static registrar instantiations (GCC dummy-arg workaround comment repeated).
- `template<typename Enum> class EnumRegistrar : boost::noncopyable` — private ctor(int) calls EnumDesc<Enum>::singleton(); public dummy(); static registrar with main-thread-init warning.

## Usage notes

- Every reflected C++ enum pairs with one EnumDesc definition using addPair/addLegacy in its .cpp.
- Lua-facing consumers: [../script/LuaEnum.md](../script/LuaEnum.md).

## Gotchas

- Enum item names are asserted space-free and NON-CamelCase at registration (isCamel check) — naming violations crash fast-fail builds.
- Legacy mapping means two names can resolve to one enum value; int values can alias through addLegacy.
- Sparse vectors use (Enum)-1 / NULL / null-Name sentinels for gaps — negative or oversized enum ids degrade to null conversions rather than throwing.
