# App/include/reflection/Object.h

## Purpose

Declares `ClassDescriptor` (the per-class reflection node: inheritance-linked, member-container multiply-inherited, functionality flags, replication/scriptability bits, CRC checksums over the whole database) and `DescribedBase` (base of every reflectable object: descriptor pointer, xmlId storage, fast descriptor-driven casts replacing dynamic_cast, and per-instance member enumeration).

## Declared API

- `enum ReplicationLevel { NEVER_REPLICATE=0, STANDARD_REPLICATE=1, PLAYER_REPLICATE=2 };`
- `class ClassDescriptor : public Descriptor, public MemberDescriptorContainer<PropertyDescriptor>, <EventDescriptor>, <FunctionDescriptor>, <YieldFunctionDescriptor>, <CallbackDescriptor>`
  - Typedef `ClassDescriptors = std::vector<ClassDescriptor*>;`
  - `enum Functionality` — bitmask combos documented inline: PERSISTENT (0x1B: isPublic+Replicate+canXmlWrite+isScriptable), PERSISTENT_PLAYER (0x1D), PERSISTENT_LOCAL (0x19), RUNTIME (0x13), RUNTIME_PLAYER (0x15), RUNTIME_LOCAL (0x11), INTERNAL (0x3), INTERNAL_PLAYER (0x5), INTERNAL_LOCAL (0x1), PERSISTENT_HIDDEN (0xB), PERSISTENT_LOCAL_INTERNAL (0x9).
  - Nested `struct Attributes : Descriptor::Attributes { Functionality flags; Attributes(Functionality); static Attributes deprecated(Functionality, const ClassDescriptor* preferred); }`
  - Members: `const Security::Permissions security;` private default ctor; statics allClasses()/count; `ClassDescriptors derivedClasses; ClassDescriptor* const base;` bitfields `bReplicateType:2, bCanXmlWrite:1, bIsScriptable:1`.
  - Public ctor `(base, name, attributes, security)`; dtor decrements count.
  - Hierarchy queries: getBase(), isBaseOf(ClassDescriptor|char*), isA(ClassDescriptor|char*).
  - Inline flag accessors: getReplicationLevel/isScriptCreatable/isSerializable.
  - `static ClassDescriptor& rootDescriptor();` ("The root ClassDescriptor of all other Descriptors" — function-local static root)
  - Enumeration: statics all_begin/all_end/all_size; derivedClasses_begin/end; checksum() overloads for the whole DB / PropertyDescriptor / EventDescriptor / ClassDescriptor / Type (boost::crc_32_type).
  - Member finders: findPropertyDescriptor/FunctionDescriptor/YieldFunctionDescriptor/EventDescriptor/CallbackDescriptor(name) forwarding to containers; template begin<T>()/end<T>().
  - operator==/!= declared (defined in .cpp).
- Iterator typedefs: ConstPropertyIterator/PropertyIterator/FunctionIterator/YieldFunctionIterator/ConstSignalIterator/SignalIterator/CallbackIterator.
- `class RBXBaseClass DescribedBase : public EventSource, public boost::enable_shared_from_this<DescribedBase>`
  - Protected: `const ClassDescriptor* descriptor; boost::scoped_ptr<std::string> xmlId;`
  - Static inline classDescriptor() → rootDescriptor(); ctor sets `Descriptor::lockedDown = true` ("See Descriptor::checkLockedDown() for an explanation") and defaults descriptor to root; virtual dtor.
  - getDescriptor(); template instance/static isA<T>(); slower string isA(className).
  - Cast family with rationale comment ("Regular dynamic_casts are very slow..."): fastDynamicCast<T>() ×4 (member/static × const/non-const), fastSharedDynamicCast<T,U>(shared_ptr<U>) via shared_static_cast.
  - Member enumeration bound to this: properties/functions/yield_functions/callbacks/signals begin/end + finders (findSignalDescriptor is the Event-flavored finder name).
  - Xml id: getXmlId()/setXmlId(newId) (lazy alloc).
  - Pure virtual: `virtual const RBX::Name& getClassName() const = 0;`

## Usage notes

- DescribedCreatable/DescribedNonCreatable templates (in reflection.h) build on these; Instance inherits DescribedBase via its chain.
- The Functionality bitmask legend (0x1 isPublic, 0x2 Replicate, 0x4 ReplicatePlayer, 0x8 canXmlWrite, 0x10 isScriptable) is spelled out in the enum comments.

## Gotchas

- First DescribedBase CONSTRUCTION locks the reflection database — all descriptors must be registered before any instance exists (pairs with Descriptor::checkLockedDown crash).
- fastDynamicCast trusts the descriptor graph; if a class's classDescriptor() lies about its base chain you get silent bad casts.
- ClassDescriptor multiply inherits five MemberDescriptorContainers sharing the Descriptor base — watch ambiguity when naming base members explicitly.
