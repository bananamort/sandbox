# ReflectionMetadata.cpp

Source: `roblox-sandbox/ClientBase/ReflectionMetadata.cpp` (522 lines)

## Purpose

Implements the `RBX::Reflection::Metadata` classes declared in ReflectionMetadata.h: registers them with the reflection system, binds their serializable properties, loads the metadata tree from `ReflectionMetadata.xml` next to the executable, provides all descriptor-to-metadata lookups, and contains the `Writer` helper that renders the whole reflection database as an API dump text format.

## API

Registered class names (string constants defined here):

- `sReflection = "ReflectionMetadata"`, `sClasses = "ReflectionMetadataClasses"`, `sItem = "ReflectionMetadataItem"`, `sClass = "ReflectionMetadataClass"`, `sProperties = "ReflectionMetadataProperties"`, `sFunctions = "ReflectionMetadataFunctions"`, `sYieldFunctions = "ReflectionMetadataYieldFunctions"`, `sEvents = "ReflectionMetadataEvents"`, `sCallbacks = "ReflectionMetadataCallbacks"`, `sMember = "ReflectionMetadataMember"`, `sEnums = "ReflectionMetadataEnums"`, `sEnum = "ReflectionMetadataEnum"`, `sEnumItem = "ReflectionMetadataEnumItem"`.

Bound properties:

- `Metadata::Item`: `prop_browsable("Browsable")`, `prop_deprecated("Deprecated")`, `prop_backend("IsBackend")`, `prop_description("summary")`, `prop_minimum("UIMinimum")`, `prop_maximum("UIMaximum")` — all category "Reflection".
- `Metadata::Class`: `prop_ExplorerOrder`, `prop_ExplorerImageIndex`, `prop_PreferredParent`, `prop_Insertable`.

All 13 types registered via `RBX_REGISTER_CLASS`. Key functions:

```cpp
shared_ptr<Metadata::Reflection> Metadata::Reflection::safe_static_do_get_singleton();
void Metadata::Reflection::load(const boost::filesystem::path& filePath);
void Metadata::Reflection::save(const boost::filesystem::path& filePath);
Metadata::Class* Metadata::Classes::get(const ClassDescriptor& d, bool findBestMatch);
void Metadata::writeEverything(std::ostream& stream);
void Metadata::Reflection::registerClasses();   // touches Properties::classDescriptor() so registration survives /OPT:ICF
```

Lookup overloads (`Reflection::get(...)`) resolve Property/Function/YieldFunction/Event/Callback descriptors by walking `Class -> Properties|Functions|... container -> findFirstChildByNameDangerous(memberName)`; Enum lookups go through the `Enums` child.

## Usage

- Loads `ReflectionMetadata.xml` from the executable's directory on Windows (`GetModuleFileNameW` + `remove_filename`) or from the Qt resources folder under `QT_ROBLOX_STUDIO`.
- Uses `v8xml/Serializer.h` + `TextXmlParser`/`TextXmlWriter` with `EngineCreator` and a `MergeBinder` for deserialization; logs via `LOGGROUP(ReflectionMetadata)` at verbosity 1.
- The local `Writer` class produces the plain-text API dump: one line per member, e.g. `\tProperty <type> <Class>.<name> [deprecated] [readonly] [security...]`, classes as `Class <Name> : <Base>` recursing derived classes, plus enums. Tags emitted: `[notbrowsable] [deprecated] [backend] [hidden] [readonly] [writeonly] [noyield] [notCreatable]` and security tags `[PluginSecurity] [RobloxPlaceSecurity] [RobloxScriptSecurity] [LocalUserSecurity] [WritePlayerSecurity] [RobloxSecurity]` or raw `[securityN]`.
- `writeEverything()` first calls `writeConflicts()` (reports ERROR lines for duplicate class/enum/member declarations across the reflection database) then `writeAPI()`.

## Gotchas

- Member lookup uses exact-name match only; inherited members are found only because `get(descriptor.owner, false)` returns NULL for derived-class-only queries — i.e., property metadata does NOT inherit unless you pass findBestMatch=true on the class-level overload.
- `Mouse.Origin` has two entries in the shipped XML (duplicate `<Item>` blocks), and `Humanoid` nests several property summaries inside ONE `ReflectionMetadataMember` block (malformed nesting: NameOcclusion/Health/MaxHealth/TargetPoint share one item). Lookups will return only the first matching child.
- `load()` asserts `binder.resolveRefs()` succeeded but proceeds silently if classes/enums children are absent (lookups just return NULL).
- `registerClasses()` exists purely to defeat linker dead-stripping of the registration units.
- Duplicate-declaration detection writes `ERROR:` lines into the dump stream rather than failing.
