# App/include/v8datamodel/NonReplicatedCSGDictionaryService.h

## Purpose

`NonReplicatedCSGDictionaryService` — flyweight store for CSG geometry data of `PartOperation`s that is **not** replicated to clients (the non-replicated sibling of [CSGDictionaryService](CSGDictionaryService.md)): stores/retrieves per-part-operation mesh data by reference counting, and can bulk store/retrieve an instance's whole descendant tree.

## Declared API

`class NonReplicatedCSGDictionaryService : public DescribedCreatable<NonReplicatedCSGDictionaryService, FlyweightService, sNonReplicatedCSGDictionaryService, Reflection::ClassDescriptor::PERSISTENT, Security::Roblox>`

- `void storeData(PartOperation& partOperation, bool forceIncrement = false)`
- `void retrieveData(PartOperation& partOperation)`
- `void storeAllDescendants(shared_ptr<RBX::Instance> instance)` / `void retrieveAllDescendants(shared_ptr<RBX::Instance> instance)`
- Protected overrides/helpers: `virtual void refreshRefCountUnderInstance(RBX::Instance* instance)`, `void reparentChildData(shared_ptr<RBX::Instance> childInstance)`.
- Header includes `Util/BinaryString.h`, `V8DataModel/FlyweightService.h`; forward-declares `RBX::PartOperation`. Uses `boost::unordered_map` (map member lives in `FlyweightService`, not here).

## Gotchas

- Security::Roblox + PERSISTENT creatable service — script-invisible construction surface; data keyed off PartOperation identity via BinaryStrings.
- The refcount refresh and reparent hooks imply stored data follows instance lifecycle; callers must pair store/retrieve or leak dictionary entries.

## UNKNOWN

- Whether `forceIncrement=true` has any caller in-tree (dictionary body lives in the .cpp / FlyweightService).

## Cross-links

- Implementation: [App/v8datamodel/NonReplicatedCSGDictionaryService.md](../../v8datamodel/NonReplicatedCSGDictionaryService.md).
- Base: [FlyweightService.md](FlyweightService.md); replicated twin: [CSGDictionaryService.md](CSGDictionaryService.md); consumers: [PartOperation.md](PartOperation.md), [PartOperationAsset.md](PartOperationAsset.md), [CSGMesh.md](CSGMesh.md).
