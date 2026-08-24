# App/include/v8datamodel/PartOperationAsset.h

## Purpose

`PartOperationAsset` — lightweight `Instance` (not a part) that holds the serialized CSG payload (`childData`, `meshData` BinaryStrings) of a saved union/negate asset, plus a render-mesh cache and static Studio-side publish helpers.

## Declared API

`class PartOperationAsset : public DescribedCreatable<PartOperationAsset, Instance, sPartOperationAsset>`

- Inline ctor `PartOperationAsset() {}`.
- Static descriptors: `desc_ChildData`, `desc_MeshData` (both `PropDescriptor<..., BinaryString>`).
- Blob accessors: `getChildData/setChildData`, `getMeshData/setMeshData` — all inline over private `BinaryString meshData/childData`.
- Render cache: `boost::shared_ptr<CSGMesh> getRenderMesh()` / `setRenderMesh(...)`.
- Static publish: `static bool publishAll(DataModel* dataModel, int timeoutMills = -1)`, `static bool publishSelection(DataModel* dataModel, int timeoutMills = -1)`.

## Gotchas

- Unlike [PartOperation.md](PartOperation.md) this is a plain Instance container — no physics blob, no collision fidelity, no size overrides; do not confuse the two when wiring CSG pipelines.
- `publish*` take a DataModel + millisecond timeout (-1 default) — synchronous-flavored publish API used by tooling.
- No reflection descriptors for the render mesh (runtime cache only).

## UNKNOWN

- Return-false conditions of `publishAll/publishSelection` (network/serialization details out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/PartOperationAsset.md](../../v8datamodel/PartOperationAsset.md).
- In-world counterpart: [PartOperation.md](PartOperation.md); mesh: [CSGMesh.md](CSGMesh.md).
