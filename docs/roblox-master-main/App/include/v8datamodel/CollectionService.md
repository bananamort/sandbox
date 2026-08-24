# App/include/v8datamodel/CollectionService.h

## Purpose

`CollectionService` (non-creatable service) — tag-based instance grouping: instances are filed into named collections with copy-on-write member lists, and add/remove events fire for observers.

## Declared API

`class CollectionService : public DescribedNonCreatable<CollectionService, Instance, sCollectionService>, public Service`

- `CollectionService();`
- Signals: `itemAddedSignal<void(shared_ptr<Instance>)>`, `itemRemovedSignal<void(shared_ptr<Instance>)>`.
- Lookups: `shared_ptr<const Instances> getCollection(std::string type);` `getCollection(const Name& className);` template `template<class T> shared_ptr<const Instances> getCollection()` forwarding to `T::classDescriptor()`.
- Membership: `void removeInstance(shared_ptr<Instance> instance); void addInstance(shared_ptr<Instance> instance);`
- Storage: `typedef std::map<std::string, shared_ptr<copy_on_write_ptr<Instances>>> CollectionMap; CollectionMap collections;`

## Gotchas

- Source TODO at the map: "Lookup by const RBX::Name*" — string-keyed lookups are known-slow.
- Returned collections are `const` + copy-on-write — callers must treat them as immutable snapshots.
- Tagging semantics (which string tags vs class names) resolved in .cpp.

## UNKNOWN

- How instances enter/leave collections automatically on parent changes (.cpp — see [CollectionService.md](../../v8datamodel/CollectionService.md)).

## Cross-links

- Implementation: [App/v8datamodel/CollectionService.md](../../v8datamodel/CollectionService.md).
