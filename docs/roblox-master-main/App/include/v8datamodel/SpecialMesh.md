# App/include/v8datamodel/SpecialMesh.h

## Purpose

`SpecialShape` (the class behind the "SpecialMesh" Lua name) — creatable `FileMesh` subclass that either references one of the built-in legacy mesh shapes or a file mesh; MeshType enum values ARE the XML serialization encoding ("Only append, never change").

## Declared API

`class SpecialShape : public DescribedCreatable<SpecialShape, FileMesh, sSpecialShape>`

- `typedef enum { HEAD_MESH=0, TORSO_MESH=1, WEDGE_MESH=2, SPHERE_MESH=3, CYLINDER_MESH=4, FILE_MESH=5, BRICK_MESH=6, PRISM_MESH=7, PYRAMID_MESH=8, PARALLELRAMP_MESH=9, RIGHTANGLERAMP_MESH=10, CORNERWEDGE_MESH=11 } MeshType;`
- Private `MeshType meshType;` with inline `getMeshType()` / `setMeshType(MeshType)`.
- Overrides: `/*** Override ***/ void setMeshId(const MeshId& value)`, `/*** Override ***/ void setTextureId(const TextureId& value)` — presumably validate/refresh per mesh type.
- Ctor.

## Gotchas

- Enum order is a serialization contract — appending only, per in-header warning.
- Note the prism-family mesh types (PRISM/PYRAMID/PARALLELRAMP/RIGHTANGLERAMP) exist regardless of `_PRISM_PYRAMID_` compile gating of their part classes.
- [PartCookie.md](PartCookie.md)'s getFileMesh treats FILE_MESH-typed SpecialShape as a FileMesh equivalent.

## UNKNOWN

- Which MeshTypes ignore MeshId/TextureId (built-in shapes) — behavior out-of-line.

## Cross-links

- Implementation: [App/v8datamodel/SpecialMesh.md](../../v8datamodel/SpecialMesh.md).
- Base: [FileMesh.md](FileMesh.md); family: [DataModelMesh.md](DataModelMesh.md), [BlockMesh.md](BlockMesh.md), [CylinderMesh.md](CylinderMesh.md), [BevelMesh.md](BevelMesh.md); consumer: [PartCookie.md](PartCookie.md).
