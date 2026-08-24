# App/include/v8datamodel/BlockMesh.h

## Purpose

`BlockMesh` Instance ("BlockMesh") — the classic beveled-block mesh decoration; adds no state of its own, inheriting bevel/roundness/bulge from [BevelMesh](BevelMesh.md).

## Declared API

`class BlockMesh : public DescribedCreatable<BlockMesh, BevelMesh, sBlockMesh>`

- `BlockMesh() {}` — entire class.

## Gotchas

- All observable properties (Scale via DataModelMesh, Bevel/Roundness/Bulge) come from ancestors — see those docs.
- Empty-body constructor defined inline; no .cpp needed for this class beyond descriptor registration.

## Cross-links

- Implementation: [App/v8datamodel/BlockMesh.md](../../v8datamodel/BlockMesh.md).
- Bases: [BevelMesh.md](BevelMesh.md), [DataModelMesh.md](DataModelMesh.md).
