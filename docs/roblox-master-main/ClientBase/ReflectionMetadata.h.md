# ReflectionMetadata.h

Source: `roblox-sandbox/ClientBase/ReflectionMetadata.h` (223 lines)

## Purpose

Declares the `RBX::Reflection::Metadata` namespace: an `Instance` tree (Reflection/Classes/Class/Member/Enums/Enum/EnumItem) that mirrors the engine's reflection descriptors and carries author-facing documentation metadata (summaries, deprecation, browseability, explorer ordering) loaded from `ReflectionMetadata.xml`. This is the data behind Studio's object browser, API dumps, and tool tips.

## API

Key types, all in `RBX::Reflection::Metadata`:

```cpp
void writeEverything(std::ostream& stream);   // full API dump incl. duplicate-declaration report

class Reflection : public DescribedCreatable<Reflection, Instance, sReflection>
{
    static shared_ptr<Reflection> singleton();          // boost::call_once-guarded; loads XML on first use
    static void registerClasses();
    void save(const boost::filesystem::path& filePath);
    void load(const boost::filesystem::path& file);
    Class*  get(const ClassDescriptor& d, bool findBestMatch) const;
    Member* get(const PropertyDescriptor&) const;
    Member* get(const FunctionDescriptor&) const;
    Member* get(const YieldFunctionDescriptor&) const;
    Member* get(const EventDescriptor&) const;
    Member* get(const CallbackDescriptor&) const;
    Enum*     get(const EnumDescriptor&) const;
    EnumItem* get(const EnumDescriptor::Item&) const;
};

class Classes : public DescribedCreatable<Classes, Instance, sClasses> { Class* get(const ClassDescriptor&, bool findBestMatch); };

class Item : public DescribedNonCreatable<Item, Instance, sItem>   // base of Class/Member/Enum/EnumItem
{
    bool browsable; bool deprecated; bool backend;
    std::string description; double minimum; double maximum;   // UIMinimum/UIMaximum
    static bool isDeprecated(const Item*, const Descriptor&);
    static bool isBackend(const Item*, const Descriptor&);
    static bool isBrowsable(const Item*, const Descriptor&);
    bool isBrowsable() const;
};

class Class : public DescribedCreatable<Class, Item, sClass>
{
    int explorerOrder;      // -1 hide, 0 unspecified, 1+ order
    int explorerImageIndex; // -1 unspecified, 0 generic
    std::string preferredParent;
    bool insertable;
    int  getExplorerOrder() const;        // inherits from base class entry when 0
    bool isExplorerItem() const;          // getExplorerOrder() >= 0
    int  getExplorerImageIndex() const;   // never returns -1
};

// Thin Instance wrappers: Members (base), Properties, Functions, YieldFunctions, Events,
// Callbacks, Enums, Enum, EnumItem — each DescribedCreatable with a default ctor.
```

Extern name constants (`sReflection`, `sClasses`, `sItem`, `sClass`, `sProperties`, `sFunctions`, `sYieldFunctions`, `sEvents`, `sCallbacks`, `sMember`, `sEnums`, `sEnum`, `sEnumItem`) hold the XML class names ("ReflectionMetadata", "ReflectionMetadataClass", ...).

## Usage

- The header is included by its own .cpp; consumers reach the data through `Metadata::Reflection::singleton()` and the descriptor-based `get()` overloads. UNKNOWN: which other translation units call singleton() directly in this pruned tree — the include-graph search only surfaced WindowsClient users of sibling headers; Studio-side consumers were largely pruned.
- `writeEverything(std::ostream&)` is the API-dump writer used by tooling to emit the textual API listing.
- The XML it loads ships next to the executable: `ReflectionMetadata.xml` (see this directory).

## Gotchas

- `get(ClassDescriptor&, true)` walks up the inheritance chain to find the nearest ancestor's metadata when no exact match exists — so summaries/deprecation flags can come from a base class.
- Singleton initialization is `boost::call_once` guarded but the underlying function-local static pattern means first call performs disk I/O (XML parse); avoid calling it on hot paths.
- `Item::isBrowsable(item, descriptor)` is OR-with-item semantics (item flag wins if set), while instance method `isBrowsable()` reads only the member — the TODO comments note intended AND/OR refinements that never landed.
