# App/include/v8datamodel/DataModelMesh.h

## Purpose

`DataModelMesh` (non-creatable) — base for all part-decoration meshes: scale, vertex color, offset, and per-axis LOD selection. Root of the BevelMesh/BlockMesh/CylinderMesh/FileMesh/SpecialMesh family.

## Declared API

`class DataModelMesh : public DescribedNonCreatable<DataModelMesh, Instance, sDataModelMesh>`

- `enum LODType { LOW_LOD=0, MEDIUM_LOD=1, HIGH_LOD=2 };` — comment: "Do not change these integer values, they correlate to the enum on the RBXViewNew side".
- LOD: `LODType getLevelOfDetailX()/setLevelOfDetailX(LODType)`; same for Y.
- Transform/surface: `const G3D::Vector3& getScale() / setScale(const Vector3&)`; `getVertColor()/setVertColor(...)`; `float getAlpha() const`; `getOffset()/setOffset(...)`.
- Protected state: `Vector3 scale, vertColor, offset; LODType LODx, LODy;`
- Protected override: `bool askSetParent(const Instance*) const;`

## Gotchas

- LOD enum values are cross-system ABI (RBXViewNew) — never reorder.
- `vertColor` is Vector3 (RGB float) while alpha comes separately via getAlpha().
- Parent rules enforced in .cpp via askSetParent (meshes must sit under parts presumably).

## UNKNOWN

- Alpha derivation from vertColor (.cpp — see [DataModelMesh.md](../../v8datamodel/DataModelMesh.md)).

## Cross-links

- Implementation: [App/v8datamodel/DataModelMesh.md](../../v8datamodel/DataModelMesh.md).
- Family: [BevelMesh.md](BevelMesh.md), [BlockMesh.md](BlockMesh.md), [CylinderMesh.md](CylinderMesh.md), [FileMesh.md](FileMesh.md), [SpecialMesh.md](SpecialMesh.md) (S-family sibling).
