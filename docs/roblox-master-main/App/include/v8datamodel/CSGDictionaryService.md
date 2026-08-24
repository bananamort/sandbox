# App/include/v8datamodel/CSGDictionaryService.h

## Purpose

`CSGDictionaryService` (PERSISTENT, Security::Roblox) — the solid-modeling dedup store: PartOperations hand their mesh/physics data to this service, which interns `CSGMesh` blobs by hash in flyweight maps so identical geometry is stored once per place.

## Declared API

`class CSGDictionaryService : public DescribedCreatable<CSGDictionaryService, FlyweightService, sCSGDictionaryService, Reflection::ClassDescriptor::PERSISTENT, Security::Roblox>`

- Storage: `typedef boost::unordered_map<std::string, boost::shared_ptr<CSGMesh>> CSGMeshMap; CSGMeshMap cachedBREPMeshMap; CSGMeshMap cachedMeshMap;`
- Core exchange with a PartOperation: `void storeData(PartOperation&, bool forceIncrement = false);` `void retrieveData(PartOperation&);`
- Bulk: `void storeAllDescendants(shared_ptr<Instance>); retrieveAllDescendants(shared_ptr<Instance>); reparentAllChildData();`
- Mesh access: `void insertMesh(PartOperation&); shared_ptr<CSGMesh> getMesh(PartOperation&); shared_ptr<CSGMesh> getCachedMesh(PartOperation&); void retrieveMeshData(PartOperation&);`
- Physics: `void storePhysicsData(PartOperation&, bool forceIncrement = false); retrievePhysicsData(PartOperation&);`
- Lifecycle: `CSGDictionaryService(); virtual onServiceProvider(old,new) override; void onWorkspaceLoaded();`
- Protected internals: `reparentChildData(shared_ptr<Instance>)`, `virtual refreshRefCountUnderInstance(Instance*)`, `insertMesh(const std::string key, const RBX::BinaryString& meshData)` and `insertCachedMesh(...)` (overloads of public insertMesh).

## Gotchas

- Security::Roblox descriptor: only engine code may create it.
- Two maps (BREP vs render mesh) — store/retrieve must keep refcounts consistent via `refreshRefCountUnderInstance`.
- Keys are hash strings (`createHash` from [CSGMesh](CSGMesh.md)); BinaryString payloads.

## UNKNOWN

- Ref-count eviction policy when meshes leave the place (.cpp — see [CSGDictionaryService.md](../../v8datamodel/CSGDictionaryService.md)).

## Cross-links

- Implementation: [App/v8datamodel/CSGDictionaryService.md](../../v8datamodel/CSGDictionaryService.md).
- Kin: non-replicated variant [NonReplicatedCSGDictionaryService.md](NonReplicatedCSGDictionaryService.md) (N–Z half), base [FlyweightService.md](FlyweightService.md), consumers [PartOperation.md](PartOperation.md)/[CSGMesh.md](CSGMesh.md).
