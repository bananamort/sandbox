# App/include/reflection/member.h

## Purpose

Declares the member-descriptor infrastructure shared by Property/Function/Event/Callback descriptors: `MemberDescriptor` (Descriptor + owner ClassDescriptor + UI category + security permissions), `MemberException`, string hashing predicates for DenseHashMap, and the template `MemberDescriptorContainer<MemberDescriptorType>` — the sorted, inheritance-propagating registry that handles member hiding/overriding and keeps per-class plus global ("allDescriptors") ordered collections with bound-member iterators.

## Declared API

- `struct StringHashPredicate { size_t operator()(const char* s) const; }` / `struct StringEqualPredicate` (inline strcmp equality).
- `class RBXBaseClass MemberDescriptor : public Descriptor`
  - Public static: `static void (*memberHidingHook)(MemberDescriptor*, MemberDescriptor*);`
  - Public members: `const RBX::Name& category;` ("Category is a name used to group properties in the UI") `const ClassDescriptor& owner; const Security::Permissions security;`
  - Protected inline ctor `(owner, name, category, attributes, security)`; virtual dtor.
  - `bool isMemberOf(const ClassDescriptor&) const; bool isMemberOf(const DescribedBase*) const;`
- `class MemberException : public std::runtime_error` — carries `const MemberDescriptor& desc;`
- `template<class MemberDescriptorType> class MemberDescriptorContainer`
  - Private static compare by name; nested `class Collection : public std::vector<MemberDescriptorType*> {}`; typedef `DenseHashMap<const char*, MemberDescriptorType*, StringHashPredicate, StringEqualPredicate> DescriptorLookup`; ConstMemberType/MemberType from MemberDescriptorType's typedefs.
  - Nested `ConstIterator`/`Iterator` (friend ClassDescriptor) — forward iterators that materialize bound `ConstMemberType`/`MemberType(descriptor, instance)` on dereference.
  - Protected: `Collection descriptors; DescriptorLookup descriptorLookup; std::vector<MemberDescriptorContainer*> derivedContainers; MemberDescriptorContainer* const base;`
  - Ctor `(base)` — merges base members recursively and registers itself in base->derivedContainers ("Subsequent members declared in a base class will be pushed down in the declare() function").
  - `declareSub(descriptor, replaceable)` — sorted insert into derived containers, honoring replaceable-hiding and firing memberHidingHook when a declared base member would hide this one.
  - Public `void declare(MemberDescriptorType* descriptor);` — idempotent re-declare guard, sorted insert or hide-replace (comment: "TODO: Eventually we'd like to nuke this feature, but it is required for some legacy things, like BoolValue"), recursion into derived containers, then deterministic-order insert into thread-once static allDescriptors() (ordered by member name then owner class name via RBX::Name::compare).
  - Enumeration: descriptors_begin/end/size; statics all_begin/all_end; `findDescriptor(const char*)` via lookup map; members_begin/members_end for both const/non-const instances.
  - Protected `mergeMembers(source)` recursive.

## Usage notes

- Instantiated per member kind inside [Type.md](Type.md) ClassDescriptor (PropertyContainer, FunctionContainer, ...).
- The container graph mirrors class inheritance: declaring a member late on a base pushes it into already-created derived containers.

## Gotchas

- Member hiding is legal but hooked (`memberHidingHook`) — legacy classes like BoolValue depend on it; do not remove.
- All global ordering relies on `RBX::Name::compare` — Name identity/interning semantics are load-bearing.
- Iterators hold raw instance pointers; lifetime must exceed enumeration.
