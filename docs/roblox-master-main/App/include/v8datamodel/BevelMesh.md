# App/include/v8datamodel/BevelMesh.h

## Purpose

`BevelMesh` (non-creatable) — [DataModelMesh](DataModelMesh.md) subclass adding the classic bevel/roundness/bulge surface parameters shared by the SpecialMesh-style part decorations.

## Declared API

`class BevelMesh : public DescribedNonCreatable<BevelMesh, DataModelMesh, sBevelMesh>`

- `BevelMesh();`
- `const float getRoundness() const; void setRoundness(const float roundness);`
- `const float getBevel() const; void setBevel(const float bevel);`
- `const float getBulge() const; void setBulge(const float bulge);`
- Protected members: `float bevel; float roundness; float bulge;` — `bulge` carries the source comment "TODO : note, quick hack putting it in here."

## Gotchas

- `bulge` is admitted by the author to not belong on this base class — it was parked here for convenience.
- Non-creatable: concrete mesh types (e.g. SpecialMesh family) subclass it.

## UNKNOWN

- Value ranges/clamping for the three floats (.cpp — see [BevelMesh.md](../../v8datamodel/BevelMesh.md)).

## Cross-links

- Implementation: [App/v8datamodel/BevelMesh.md](../../v8datamodel/BevelMesh.md).
- Base: [DataModelMesh.md](DataModelMesh.md); sibling meshes [FileMesh.md](FileMesh.md), [CylinderMesh.md](CylinderMesh.md), [BlockMesh.md](BlockMesh.md).
