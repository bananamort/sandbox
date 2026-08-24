# CharacterMesh.cpp

## Purpose

Implements `CharacterMesh` ("CharacterMesh") — a CharacterAppearance subclass that layers an arbitrary mesh asset (with base+overlay textures) onto one named R6/R15 body part, reusing the outfit-changed signal to trigger re-rendering.

## Key types and API

Descriptors (no Security:: arguments):
- `prop_bodyPart("BodyPart", category_Data)` — enum "BodyPart": Head, Torso, LeftArm, RightArm, LeftLeg, RightLeg (+ Variant/StringConverter template plumbing).
- `CharacterMesh::prop_baseTextureAssetId("BaseTextureId", "Data")` — int BoundProp.
- `prop_overlayTextureAssetId("OverlayTextureId", "Data")` — int.
- `prop_meshAssetId("MeshId", "Data")` — int.

Constants: `sCharacterMesh = "CharacterMesh"`; defaults HEAD / 0 / 0 / 0.

Behavior:
- Asset-id ints convert lazily: `getBaseTextureId`/`getOverlayTextureId` format `rbxassetid://%d` or nullTexture at 0; `getMeshId` returns empty MeshId at 0.
- `onPropertyChanged(ANY descriptor)` → static `CharacterAppearance::apply()` — every property touch re-applies the whole appearance stack.
- `applyByMyself(Humanoid*)` — fires `fireOutfitChanged()` on left/right leg, torso, left/right arm (comment: "re-using fireOutfitChanged. consider: own event… reuse for now").

## Usage / reflection touchpoints

Sibling of Shirt/Pants/Skin/BodyColors in [CharacterAppearance](CharacterAppearance.md); mesh ids resolve like [FileMesh](FileMesh.md)-style assets.

## Gotchas

- The BodyPart enum is NOT enforced against the mesh content — assigning a leg mesh to Head is accepted; rendering sorts it out (or doesn't).
- Any property change (even unrelated reads that raise) triggers full-appearance reapply via onPropertyChanged's unconditional apply().
- Overlay/base texture of 0 means NULL texture, not asset id 0 lookup.
