# App/include/v8datamodel/PartCookie.h

## Purpose

`RBX::PartCookie` — a cached bit-flags summary of a `PartInstance`'s decorations (decals, humanoid membership, special/file/head mesh) plus inline helpers that consult those bits before walking children: `getSpecialShape`, `getFileMesh`, `getHumanoid`, `getPartReflectance`. Pure header (all helpers inline); the only out-of-line piece is `PartCookie::compute`.

## Declared API

`class PartCookie` (flag enum, anonymous enum):
- `HAS_DECALS = 1<<0`, `IS_HUMANOID_PART = 1<<1`, `HAS_SPECIALSHAPE = 1<<2`, `HAS_FILEMESH = 1<<3`, `HAS_HEADMESH = 1<<4`, `HAS_DECALS_Z_NEG = 1<<5`
- `static unsigned int compute(RBX::PartInstance* part)` — populates the cookie (defined elsewhere).

Free inline helpers in namespace RBX:
- `DataModelMesh* getSpecialShape(PartInstance* part)` — gated on HAS_SPECIALSHAPE; returns the **LAST** child castable to `DataModelMesh` (in-header comment: "i.e. the LAST child of type DataModelMesh").
- `FileMesh* getFileMesh(DataModelMesh* specialShape)` / `FileMesh* getFileMesh(PartInstance* part)` — accepts a `SpecialShape` with `getMeshType()==SpecialShape::FILE_MESH` or a plain `FileMesh`.
- `Humanoid* getHumanoid(PartInstance* part)` — gated on IS_HUMANOID_PART, then `Humanoid::modelIsCharacter(part->getParent())`.
- `float getPartReflectance(PartInstance* part)` — `clamp(reflectance,0,1) * 0.8f`.

## Gotchas

- Cookie is advisory cache: if callers mutate children without recomputing via `compute`, `getSpecialShape` can return stale/no results. The "last child" rule means multiple meshes silently shadow earlier ones.
- `getHumanoid` walks to the parent model — NULL unless the part's parent passes `modelIsCharacter`.
- Reflectance helper hard-caps at 0.8× — rendering-side clamp, not a property clamp.
- Header drags in Humanoid/Humanoid.h and all mesh headers — heavyweight include.

## UNKNOWN

- Who calls `compute()` and when cookies are invalidated (out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/PartCookie.md](../../v8datamodel/PartCookie.md).
- Consumers/data: [PartInstance.md](PartInstance.md), [SpecialMesh.md](SpecialMesh.md), [FileMesh.md](FileMesh.md), [Decal.md](Decal.md), [CharacterMesh.md](CharacterMesh.md).
