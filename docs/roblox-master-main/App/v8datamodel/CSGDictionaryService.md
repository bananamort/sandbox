# CSGDictionaryService.cpp

## Purpose

Implements `CSGDictionaryService` ("CSGDictionaryService") — the REPLICATED flyweight dictionary for CSG union blobs (FlyweightService subclass): dedupes PartOperation MeshData/PhysicsData into shared BinaryStringValue children keyed by content hash, resolves "CSGK"-prefixed local keys into cached meshes, and — under CSGLoadFromCDN — strips inline mesh data from asset-backed unions at workspace load so clients fetch from CDN.

## Key types and API

Descriptors: none. Constants: `sCSGDictionaryService`; internal `localKeyTag = "CSGK"`, `minKeySize = 4`. Flags consumed: `StudioCSGAssets`, `CSGLoadFromCDN`, `IgnoreBlankDataOnStore`.

Behavior:
- `storeData(PartOperation&, forceIncrement)` — takes mesh/physics BinaryStrings; with IgnoreBlankDataOnStore only non-empty strings are interned via `storeStringData(tmp, forceIncrement, "MeshData"/"PhysicsData")` then written back.
- `retrieveData` / `retrieveMeshData` / `retrievePhysicsData` — resolve hash-key placeholders back to real data via `retrieveStringData`.
- `storeAllDescendants` / `retrieveAllDescendants` — recursive PartOperation walks; `refreshRefCountUnderInstance` re-stores with forceIncrement=true (refcount bump for duplicated subtrees).
- `reparentAllChildData` / `reparentChildData` — migrates child BinaryStringValues to NonReplicatedCSGDictionaryService and drops their keys from instanceMap (local-only promotion).
- Mesh caches: `insertMesh(key, meshData)` builds a CSGMesh via CSGMeshFactory into cachedMeshMap; `insertMesh(PartOperation&)` moves live BREP meshes from an operation into cachedBREPMeshMap (evicting cachedMeshMap twin); `getMesh(PartOperation&)` resolution order BREP cache → mesh cache → weak-ref BinaryStringValue under this service (`instanceMap[key].ref.lock()` → rebuild+cache).
- CDN path: onServiceProvider connects workspaceLoadedSignal once; `onWorkspaceLoaded` visits all descendants, and for PartOperations WITH an asset but non-empty inline mesh data collects + blanks the data (`setMeshData(BinaryString())`) after removing the dictionary entries (`removeStringData`) — the asset URL is the source of truth thereafter.

## Usage / reflection touchpoints

Paired sibling [NonReplicatedCSGDictionaryService](NonReplicatedCSGDictionaryService.md) (local-only twin); consumers are [PartOperation](PartOperation.md)/[PartOperationAsset](PartOperationAsset.md)/[CSGMesh](CSGMesh.md); ChangeHistory requests clean both dictionaries ([ChangeHistory](ChangeHistory.md)).

## Gotchas

- storeData writes back MESH data only when the flag-gated non-empty check passes, but PHYSICS data is set back UNCONDITIONALLY (blank physics wipes through when flag off or empty).
- getMesh returns empty shared_ptr silently for non-"CSGK" keys — remote/asset keys resolve elsewhere.
- instanceMap holds WEAK refs; a collected BinaryStringValue makes getMesh fall through to empty without error.
