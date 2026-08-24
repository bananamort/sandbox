# App/include/v8datamodel/PartOperation.h

## Purpose

`PartOperation` — CSG result part (`PartInstance` subclass) carrying BinaryString blobs (`childData` = original children snapshot, `meshData` = CSG mesh, `physicsData` = decomposition) plus a lazily built `CSGMesh` cache, collision-fidelity control and asset identity. Defines `enum CollisionFidelity {Default, Hull, Box}`, the creatable subclasses `UnionOperation` and `NegateOperation`, and free helper `getCSGVertexPositions`.

## Declared API

- `enum CollisionFidelity { CollisionFidelity_Default, CollisionFidelity_Hull, CollisionFidelity_Box }`
- `class PartOperation : public DescribedCreatable<PartOperation, PartInstance, sPartOperation>`
  - Protected state: `BinaryString childData/meshData/physicsData`, `CollisionFidelity collisionFidelity`, `boost::shared_ptr<CSGMesh> cachedMesh`, `Vector3 initialSize`, `bool usePartColor`, `FormFactor formFactor`, `bool hasAssetId`, `ContentId assetId`; protected `hasMeshData()`.
  - Static: `bool renderCollisionData`; descriptors `desc_InitialSize/desc_UsePartColor/desc_FormFactor(EnumPropDescriptor<FormFactor>)/desc_AssetId(ContentId)` + blob props `desc_ChildData/desc_MeshData/desc_PhysicsData` + `prop_CollisionFidelity`.
  - Blob API: `peekChildData(RBX::Instance* context=NULL)`, `getChildData() const`, `getChildDataBlocking(context=NULL)`, `setChildData(...)`, `getMeshData()/setMeshData(...)`, `getPhysicsData()/setPhysicsData(...)/hasPhysicsData()`.
  - Mesh: `setMesh(CSGMesh*)`, `refreshMesh()`, `shared_ptr<CSGMesh> getMesh()`, `shared_ptr<CSGMesh> getRenderMesh()`.
  - Fidelity/identity: `set/getCollisionFidelity`, `virtual void clearData()`, `get/setInitialSize(Vector3)`, `get/setUsePartColor(bool)`, `hasAsset()/getAssetId()/setAssetId(ContentId)`, `getSizeDifference()`.
  - Size overrides mirroring PartInstance UI/XML duality: `setPartSizeXml`, `hasThreeDimensionalSize`, `getMinimumYDimension`, `getMinimumXOrZDimension`, `getMinimumUiSize`, `uiToXmlSize`; `getFormFactor()` returns member; `setFormFactor(FormFactor)`.
  - Physics build pipeline: `static size_t getMaximumTriangleCount()`, `static size_t getMaximumMeshStreamSize()`, `bool createPhysicsData(const CSGMesh*)`, `void createPlaceholderPhysicsData()`, `void trySetPhysicsData()`, `bool checkDecompExists()`, `void processOutOfDateData()`, `void setBulletCollisionObject()`, `std::string getNonKeyPhysicsData() const`, `std::string generateHashKey(const std::string&) const`, `void setBulletObjectsScale(const Vector3&)`, `Vector3 calculateSizeDifference(const Vector3&)`, `Vector3 calculateAdjustedSizeDifference(const Vector3&)`.
  - `/*override*/ virtual PartType getPartType() const` (out-of-line); protected `onServiceProvider` override.
- `static std::vector<btVector3> getCSGVertexPositions(const std::vector<CSGVertex>& vertices)` — file-static (internal-linkage!) converter to Bullet vectors.
- `class UnionOperation : public DescribedCreatable<UnionOperation, PartOperation, sUnionOperation>` — ctor only.
- `class NegateOperation : public DescribedCreatable<NegateOperation, PartOperation, sNegateOperation>` — ctor only.

## Gotchas

- `getCSGVertexPositions` is declared `static` at file scope in a header — each including TU gets its own copy; harmless but surprising.
- Blob getters are sync-looking but `peekChildData`/`getChildDataBlocking` imply the plain path can be async/content-fetch gated (dictionary service interaction — see [NonReplicatedCSGDictionaryService.md](NonReplicatedCSGDictionaryService.md)).
- Bullet types (`btVector3`) leak into a data-model header via this declaration.
- `hasMeshData()` checks both `!= ""` and `.size() != 0` on the same string — redundant belt-and-suspenders.

## UNKNOWN

- Where mesh/physics blobs are decoded (CSGDictionaryService / CSGMesh internals — see certified doc).

## Cross-links

- Implementation: [App/v8datamodel/PartOperation.md](../../v8datamodel/PartOperation.md).
- Base: [PartInstance.md](PartInstance.md); mesh layer: [CSGMesh.md](CSGMesh.md), [DataModelMesh.md](DataModelMesh.md); dictionary: [NonReplicatedCSGDictionaryService.md](NonReplicatedCSGDictionaryService.md), [CSGDictionaryService.md](CSGDictionaryService.md); asset side: [PartOperationAsset.md](PartOperationAsset.md).
