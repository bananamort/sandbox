# App/include/v8datamodel/Decal.h

## Purpose

`Decal` Instance — a texture applied to one face of a part (extends [FaceInstance](FaceInstance.md)) with specular/shiny/transparency controls; `DecalTexture` subclass adds tiling via StudsPerTile U/V.

## Declared API

`class Decal : public DescribedCreatable<Decal, FaceInstance, sDecal>`

- Props: `prop_Texture` (TextureId; `getTexture()/setTexture`), `prop_Specular`, `prop_Shiny`, `prop_Transparency` (`getTransparencyUi()` separate from raw getter), `prop_LocalTransparencyModifier` (getter/setter).
- Members: `TextureId texture; float specular, shiny, transparency, localTransparencyModifier;`
- `Decal(void);`

`class DecalTexture : public DescribedCreatable<DecalTexture, Decal, sDecalTexture>`

- Tiling: `const G3D::Vector2& getStudsPerTile()` (non-const ref return), per-component props `prop_StudsPerTileU/V` with getters/setters over `studsPerTile.x/.y`.
- `DecalTexture(void);`

## Gotchas

- Two transparency reads: raw value vs `getTransparencyUi()` (UI view combines localTransparencyModifier presumably — .cpp).
- DecalTexture's non-const getStudsPerTile returns a mutable reference to internal state.
- LocalTransparencyModifier is the per-client fade channel (used by proximity fades).

## UNKNOWN

- Exact UI-vs-raw transparency math (.cpp — see [Decal.md](../../v8datamodel/Decal.md)).

## Cross-links

- Implementation: [App/v8datamodel/Decal.md](../../v8datamodel/Decal.md).
- Base: [FaceInstance.md](FaceInstance.md); kin: [TextureTrail] (T–Z half), [CharacterAppearance.md](CharacterAppearance.md) (ShirtGraphic uses TextureId on parts).
