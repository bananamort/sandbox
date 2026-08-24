# App/include/reflection/Property.h

## Purpose

Declares the property side of reflection: `PropertyDescriptor` (functionality bitmasks, mutability/replication/XML/scriptability flags, Variant/string/XML get-set contracts), the typed wrapper `TypedPropertyDescriptor<V>` with its pluggable `GetSet` interface, the descriptor+instance handles `ConstProperty`/`Property`, specializations `EnumPropertyDescriptor` and `RefPropertyDescriptor` (Instance references), and `BoundProp<V, Mutability>` — the workhorse template binding a raw C++ member pointer (+ optional changed-callback) into a descriptor.

## Declared API

- `typedef enum { READONLY, READWRITE } Mutability;`
- `class RBXBaseClass PropertyDescriptor : public MemberDescriptor`
  - Private bitfields: bIsPublic, bIsEditable, bCanReplicate, bCanXmlRead, bCanXmlWrite, bIsScriptable, bAlwaysClone. Comment: "isPublic == PropertyUI shown, and Can BaseScript against. ToDo: possibly split?"
  - `enum Functionality` — inline-documented combos: STANDARD(31), NO_XML_WRITE(23), UI(21) ("Remove canXmlRead from UI"), SCRIPTING(19), STREAMING(14), CLUSTER(12), LEGACY(4), REPLICATE_ONLY(2), LEGACY_SCRIPTING(20), HIDDEN_SCRIPTING(16), PUBLIC_SERIALIZED(13), REPLICATE_CLONE(34, adds alwaysClone bit 32), STANDARD_NO_REPLICATE(29), STANDARD_NO_SCRIPTING(15), PUBLIC_REPLICATE(3).
  - Nested Attributes : Descriptor::Attributes — default STANDARD; static deprecated(preferred[, flags=UI]) ×2.
  - Members: `const Type& type; const bool bIsEnum;` protected ctor + inline checkFlags() (write-only ⇒ no xmlWrite/noReplicate; read-only ⇒ no xmlRead/noReplicate).
  - Queries: isPublic/isScriptable/setEditable/isEditable/canXmlRead/canXmlWrite/canReplicate/alwaysClone (asserts tie flag consistency to virtual isReadOnly/isWriteOnly); pure virtuals isReadOnly/isWriteOnly.
  - Core contracts (pure virtual): equalValues(a,b); getVariant(instance, Variant&)/setVariant; copyValue(source, dest); getDataSize(instance).
  - String interface: hasStringValue(); getStringValue/setStringValue base implementations debugAssert-fail with messages "you must implement ..." / "don't call ... when hasStringValue()==false".
  - XML: `XmlElement* write(const DescribedBase*, bool ignoreWriteProtection = false) const;` `virtual void read(DescribedBase*, const XmlElement*, RBX::IReferenceBinder&) const;` private pure writeValue/readValue.
- `template <typename V> class TypedPropertyDescriptor : public PropertyDescriptor`
  - Nested `class RBXInterface GetSet { isReadOnly(); isWriteOnly(); V getValue(const DescribedBase*); setValue(DescribedBase*, const V&); }`
  - Protected: `std::auto_ptr<GetSet> getset;` two ctors (explicit Type or Type::singleton<V>()); both call checkFlags when getset present.
  - Implements: get/set<V>, getVariant/setVariant (setVariant via value.get<V>(), comment "TODO: This might be inefficient..."), copyValue, isReadOnly/isWriteOnly forwarding, getValue/setValue, equalValues via operator== on V; declares getDataSize/hasStringValue/getStringValue/setStringValue/readValue/writeValue (defined in .cpp).
- `class ConstProperty` — descriptor + const instance pair: default/copy ctors, assignment, ==; getInstance/getDescriptor; getName; isValueType<V>(); getValue<V>() asserting then static_cast to TypedPropertyDescriptor<V>; hasStringValue/getStringValue; write().
- `class Property : public ConstProperty` — mutable flavor: getInstance() const_casts; setValue<V>; setStringValue; read(element, binder); != added.
- `std::size_t hash_value(const ConstProperty& prop);` — boost hash support.
- `class RBXInterface EnumPropertyDescriptor : public PropertyDescriptor` — member `const EnumDescriptor& enumDescriptor;` pure virtuals getIndexValue/setIndexValue ("throws an exception if value is illegal")/getEnumValue/setEnumValue/getEnumItem; inline setEnumItem validates item.owner; getDataSize = sizeof(int); protected ctor passes isEnum=true.
- `class RBXBaseClass RefPropertyDescriptor : public PropertyDescriptor` — pure virtuals getRefValue/setRefValue/setRefValueUnsafe; getDataSize=0; string methods defer to base asserts; statics `isRefPropertyDescriptor(const Type&)` (name lookup "Object") and `(const PropertyDescriptor&)` (dynamic_cast cross-checked assertion; "See RefType in reflection.h").
- `template<typename V, Mutability mutability = READWRITE> class BoundProp : public TypedPropertyDescriptor<V>`
  - Private nested BoundPropGetSet<Class>: holds member pointer `V Class::*member` + ChangedMember callback; isReadOnly from template param; isWriteOnly false; getValue direct member read; setValue throws `"can't set value"` when READONLY, else assigns-if-different, invokes changed callback, then `c->raisePropertyChanged(desc)`.
  - Ctors (both templated on Class): (name, category, member, changed, flags=STANDARD, security=None) and without changed.

## Usage notes

- This is how every Instance property in v8datamodel is declared (`static const Reflection::PropDescriptor<...>` / BoundProp statics).
- XML paths feed [../v8xml/](../v8xml/) serializers.

## Gotchas

- Functionality bit values are positional (1=isPublic, 2=canReplicate, 4=canXmlRead, 8=canXmlWrite, 16=isScriptable, 32=alwaysClone) — the sums are load-bearing.
- checkFlags silently clears contradictory bits (e.g., read-only props lose replicate/xmlRead).
- Property equality = same descriptor AND same instance pointer.
- RefPropertyDescriptor detection by TYPE NAME lookup of "Object" — renaming the root class name breaks reference serialization detection.
