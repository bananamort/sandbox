# App/include/v8datamodel/CylinderMesh.h

## Purpose

`CylinderMesh` Instance ("CylinderMesh") — beveled-cylinder mesh decoration; adds no state beyond [BevelMesh](BevelMesh.md).

## Declared API

`class CylinderMesh : public DescribedCreatable<CylinderMesh, BevelMesh, sCylinderMesh>`

- `CylinderMesh() {}` — entire class.

## Gotchas

- All observable surface (Scale, Bevel/Roundness/Bulge) is inherited.

## Cross-links

- Implementation: [App/v8datamodel/CylinderMesh.md](../../v8datamodel/CylinderMesh.md).
- Bases/siblings: [BevelMesh.md](BevelMesh.md), [DataModelMesh.md](DataModelMesh.md), [BlockMesh.md](BlockMesh.md).
