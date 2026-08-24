# PartOperation.cpp

## Purpose

Implements `PartOperation`, the abstract base class for CSG results (`UnionOperation` = "Union", `NegateOperation` = "NegativePart"). A PartOperation IS a Part-like Instance carrying its render mesh (`MeshData`) and collision decomposition (`PhysicsData`) as `BinaryString` hash keys resolved through the two CSG dictionaries, plus optional indirection to a published web asset (`AssetId`). Owns Bullet triangle-mesh lifecycle: generating decomposition/hull/box collision data per `CollisionFidelity`, applying scale to Bullet objects, and regenerating stale physics data in Studio. Subclass ctors live here too.

## Key types and API

Descriptors (`Security::` tiers verbatim):
- `desc_ChildData("ChildData")` — BinaryString, category_Data, cap CLUSTER, **Security::Roblox**.
- `desc_MeshData("MeshData")` — BinaryString, category_Data, cap STREAMING, **Security::Roblox**.
- `desc_PhysicsData("PhysicsData")` — BinaryString, category_Data, cap STREAMING, **Security::Roblox**.
- `desc_InitialSize("InitialSize")` — Vector3, cap STREAMING, **Security::Roblox** (reference size for relative scaling).
- `desc_UsePartColor("UsePartColor")` — bool, no capability/security args (descriptor default).
- `desc_FormFactor("FormFactor")` — enum FormFactor, cap STREAMING, **Security::Roblox**; default `SYMETRIC`.
- `desc_AssetId("AssetId")` — ContentId, cap STREAMING, **Security::Roblox**.
- `prop_CollisionFidelity("CollisionFidelity")` — category_Behavior, cap PUBLIC_SERIALIZED, **no explicit security tier** (descriptor default).
- Enum `CollisionFidelity`: Default / Hull / Box.

Class surface (beyond inherited PartInstance machinery):
- `onServiceProvider(old,new)`: on attach stores ChildData/MeshData into both `CSGDictionaryService` and `NonReplicatedCSGDictionaryService`; on detach retrieves (inflates) it back.
- Data accessors: `getChildData/setChildData`, `setMeshData`, `peekChildData(context)` (dictionary lookup honoring FlyweightService hash keys, NR-dict fallback), `getChildDataBlocking(context)` (under FFlag StudioCSGAssets + hasAssetId blocks on `SolidModelContentProvider`), `setPhysicsData` (raises change then `trySetPhysicsData`), `clearData()` (empties all three blobs).
- Mesh: `getMesh()` (cached; under StudioCSGAssets+assetId returns `PartOperationAsset::getRenderMesh()`; otherwise dictionary `getMesh`; clears mesh server-side when bad or > `getMaximumTriangleCount()` while `Workspace::serverIsPresent`), `getRenderMesh()` (returns NULL when hasAssetId under flag), `refreshMesh()`, `setMesh(CSGMesh*)` (also re-serializes into MeshData).
- Physics: `createPhysicsData(const CSGMesh*)` — flag-gated LOD branch builds `TriangleMesh::generateDecompositionData` (Default) / `generateConvexHullData` (Hull) / `getBlockData`+GEOMETRY_BLOCK reset (Box); legacy branch decomposes existing primitive mesh; rejects > `getMaximumMeshStreamSize()` (512000). `createPlaceholderPhysicsData()` (version-0 placeholder), `trySetPhysicsData()` (applies compound+static mesh data w/ shrunken vs raw scale, falls back to GEOMETRY_BLOCK for block-data placeholders or version<PHYSICS_SERIAL_VERSION → `processOutOfDateData`), `checkDecompExists()`, `processOutOfDateData()` (Studio: regenerate from mesh + propagate to identical-mesh descendants via `visitDescendentsSetPhysics`; runtime: geometry degrades to GEOMETRY_BLOCK), `setBulletCollisionObject()`, `getNonKeyPhysicsData()`, `generateHashKey()`, `setBulletObjectsScale(newSize)` (Bullet margin-adjusted rescale).
- Sizing overrides: `setPartSizeXml`, `getSizeDifference`, `calculateSizeDifference` (forces uniform scale when SYMETRIC), `calculateAdjustedSizeDifference` (subtracts `2*bulletCollisionMargin`), `hasThreeDimensionalSize` (formFactor != SYMETRIC), min-size 0.2³, `uiToXmlSize` (passes through under CSGRemoveScriptScaleRestriction, refuses zero size under CSGUnionsSizeShouldNeverBe000).
- `setCollisionFidelity` prints MESSAGE_WARNING when RunState is RUNNING/PAUSED ("Cannot change … during Run-Time") but still applies.
- `setAssetId(ContentId)`: sets `hasAssetId` when the id is a URL; raises AssetId change only when value actually changed AND DFFlag TeamCreateRaiseChangedOperationForAssetId AND `Network::Players::isCloudEdit`.
- Statics/free: `renderCollisionData=false`; `visitDescendentsSetPhysics` (copies source physics data to descendants sharing the same mesh, version-guarded under the LOD flag); `getCSGVertexPositions`.

Flags declared here: `CSGRemoveScriptScaleRestriction(false)`, `StudioCSGAssets(false)`, `CSGLoadFromCDN(false)`, `CSGLoadBlocking(false)` (the latter two referenced only in headers/elsewhere — not used in this TU body), `CSGPhysicsLevelOfDetailEnabled(false)`, `CSGUnionsSizeShouldNeverBe000(false)`, DFFlag `TeamCreateRaiseChangedOperationForAssetId(true)`.

Subclass ctors: `UnionOperation` names itself "Union"; `NegateOperation` names itself "NegativePart" with transparency 0.1, anchored=true, canCollide=false. Base ctor sets primitive geometry GEOMETRY_TRI_MESH, surfaces NO_SURFACE, white color.

## Usage / reflection touchpoints

Consumers: CSG tooling (union/negate/separate flows), `PartOperationAsset` publishing (same folder), `SolidModelContentProvider`/`FlyweightService` content resolution, V8World TriangleMesh/Bullet geometry pool. Script-facing properties are the descriptors above; the data blobs are Roblox-security so scripts see only AssetId/CollisionFidelity/UsePartColor-style surface. Pairs with `CSGDictionaryService.md`, `NonReplicatedCSGDictionaryService.md`, `PartCookie.md` in this folder.

## Gotchas

- `ChildData` replicates via CLUSTER while `MeshData`/`PhysicsData` are STREAMING-only — clients receive mesh keys without child data.
- Server-side mesh clearing (>2500 triangles or `isBadMesh`) silently empties cachedMesh — unions over the cap collide/render as nothing rather than erroring.
- `processOutOfDateData` regenerates physics ONLY in Studio; in live games stale-version data permanently degrades the part to a GEOMETRY_BLOCK.
- `getRenderMesh()` deliberately returns NULL whenever an AssetId is present under StudioCSGAssets — render mesh must come through the asset pipeline.
- `setCollisionFidelity` logs but does NOT reject runtime changes.
- Legacy (non-LOD-flagged) `createPhysicsData` no-ops (returns false) unless the primitive geometry is already GEOMETRY_TRI_MESH.
- UNKNOWN: `PHYSICS_SERIAL_VERSION`, `bulletCollisionMargin`, and the FormFactor enum's full member list live in headers outside this file; exact behavior of `CSGLoadFromCDN`/`CSGLoadBlocking` is not observable in this TU.
