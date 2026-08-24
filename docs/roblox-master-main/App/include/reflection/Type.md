# App/include/reflection/Type.h

## Purpose

Declares the reflection type core: `Type` (runtime type descriptor with singleton-per-type lookup and a global registry), `TypeRegistrar<T>` (static-registration idiom ensuring descriptors initialize before use), `TType<T>` helper, `Variant` (the 96-byte-stack-storage tagged union powering every property/argument exchange), the Lua-shaped containers (`ValueArray`, `ValueTable`, `ValueMap`, `Tuple`), and `SignatureDescriptor` (function signatures with typed, default-valued parameters).

## Declared API

- `class RBX::Reflection::Type : public Descriptor`
  - Friends: TypeRegistrar; private `template<class T> static const Type& getSingleton();` ("Must be implemented for each type used") + `void addToAllTypes();`
  - Public: `const Name& tag; const bool isFloat, isNumber, isEnum;` `static const std::vector<const Type*>& getAllTypes();` template inline `singleton<T>()`; inline identity-based ==/!= and `isType<T>()`.
  - Protected ctors: `(name, T* dummy)` — sets isOutdated=false/isReplicable=true, isNumber/isFloat from boost traits; `(name, tag, dummy)`; `(name, tag, isNumber, isFloat, isEnum)` for non-template types. All assert non-empty tag and self-register.
- `std::ostream& operator<<(std::ostream&, const Type&);`
- Macro `RBX_REGISTER_TYPE(mType)` — defines the static registrar instantiation.
- `template<class T> class TypeRegistrar : boost::noncopyable` — private ctor(int) with GCC workaround comment ("WEIRD huh?"), BOOST_STATIC_ASSERT rejecting boost::any as a Variant payload, calls Type::getSingleton<T>(); public `static TypeRegistrar registrar;` with comment warning the defining TU must initialize on the main thread before objects are created "Otherwise the reflection database can change at runtime, which would be a disaster".
- `template<typename T> class TType : public Type` — friend Type; protected ctors passing (T*)NULL.
- `class Variant`
  - Private: `struct Storage { char data[96]; }` + `const Type* _type; rbx::placement_any<Storage> value;` — in-place storage, no heap for payloads ≤96 bytes.
  - Default/copy ctors + assignment (inline); templated ctor/assignment stamping `Type::singleton<ValueType>()`.
  - Queries: `type()`, `isVoid()`, `isFloat()`, `isNumber()`, `isString()`, `isType<ValueType>()`.
  - Extraction: `ValueType& convert();` (throws if unable); `ValueType get() const` (cast fast path, else copy+convert); `cast<T>()` const/non-const throwing `"Variant cast failed"` reinterpret_casts; `tryCast<T>()` NULL-returning variants.
  - Private `genericConvert<ValueType>()` (defined at bottom): tryCast → string-conversion via StringConverter → throws `RBX::runtime_error("Unable to cast %s to %s", ...)`. NOTE: successful string conversion MUTATES the variant (re-stores converted value + retypes).
- Typedefs/structs:
  - `typedef std::vector<Variant> ValueArray;` ("Equivalent to an array in Lua")
  - `typedef boost::unordered_map<std::string, Variant> ValueTable;` ("A limited table in Lua (keys must be strings for now)")
  - `struct Tuple { ValueArray values; Tuple(); Tuple(size_t count); copy; at(i) ×2; }` — one commented-out ctor from ValueArray.
  - `typedef std::map<std::string, Variant> ValueMap;` ("The same as a ValueTable for now... TODO: Use boost::unordered_map<> or vector<> instead?")
- `class SignatureDescriptor`
  - Nested `struct Item { const RBX::Name* name; const Type* type; const Variant defaultValue; Item(...); bool hasDefaultValue() const; }` — has-default iff defaultValue's type equals the parameter type.
  - `typedef std::list<Item> Arguments;` ("TODO: Would vector be more efficient?"); members `const Type* resultType; Arguments arguments;` methods addArgument(name,type[,defaultValue]) ×2, ctor.

## Usage notes

- Everything in the engine that crosses reflection boundaries (properties, function args, Lua bridge values) flows through Variant.
- See [../script/LuaArguments.md](../script/LuaArguments.md) for how Variants map to/from Lua.

## Gotchas

- Variant is identity-typed: int(1) != double(1.0) — isType checks are pointer comparisons against singletons.
- `genericConvert` through std::string MUTATES the source variant on success (re-stores converted value + retypes) — which is exactly why `get()` first clones the Variant ("Create a non-const copy") so the original stays untouched; only direct `convert()` calls mutate in place.
- 96-byte Storage: larger payloads (e.g. big structs) fall back to placement_any's internal handling; oversized copies are expensive.
- Registration order matters process-wide: registrar statics must init on main thread before first Instance.
