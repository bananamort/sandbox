# Decal.cpp

## Purpose

Implements `Decal` ("Decal") — the face-texture overlay on parts: TextureId, deprecated Specular/Shiny, Transparency plus HIDDEN_SCRIPTING LocalTransparencyModifier (combined multiplicatively for rendering) — and `DecalTexture` ("Texture" instance name) adding StudsPerTileU/V tiling. Also hosts the full Reflection template specialization set for TextureId (string conversion, XML read/write, Variant coercion, Type singleton).

## Key types and API

Descriptors (all category_Appearance, no Security:: arguments):
- `Decal::prop_Texture("Texture")` — TextureId.
- `prop_Specular("Specular", deprecated)` / `prop_Shiny("Shiny", deprecated)` — floats; setSpecular silently rejects NEGATIVE values (0 accepted), setShiny requires >0.
- `prop_Transparency("Transparency")` — float 0..1 stored unclamped here.
- `prop_LocalTransparencyModifier("LocalTransparencyModifier", HIDDEN_SCRIPTING)` — clamped 0..1; camera-distance fade writes this.
- DecalTexture: `prop_StudsPerTileU("StudsPerTileU")`/`prop_StudsPerTileV("StudsPerTileV")` — must be >0 to take effect; default tiling 2×2.

Constants: `sDecal = "Decal"`, `sDecalTexture = "Texture"`.

Behavior:
- `getTransparencyUi()` = `1 − (1−localModifier)·(1−transparency)` — effective render alpha.
- TextureId template block: convertToValue always true; Variant::convert transparently upgrades string→TextureId; XML nil-safe read; getDataSize = sizeof + url length.

## Usage / reflection touchpoints

Applied by [CharacterAppearance](CharacterAppearance.md) (torso graphic via ShirtGraphic), tiled variant used by legacy texture paths; face selection in [Surface](Surface.md)-style tooling; content resolution through ContentProvider like [FileMesh](FileMesh.md).

## Gotchas

- Specular/Shiny are deprecated AND silently ignore invalid assignments (negative for Specular, ≤0 for Shiny) — old scripts setting them see no change and no error.
- Transparency itself is not clamped by the setter; only LocalTransparencyModifier is — negative Transparency propagates into getTransparencyUi math unchecked.
- StudsPerTileU/V of exactly 0 is silently ignored (must be >0).
- The TextureId specializations live in THIS TU — removing it breaks every ContentId-derived property's reflection plumbing.
