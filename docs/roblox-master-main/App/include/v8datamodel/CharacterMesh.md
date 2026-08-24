# App/include/v8datamodel/CharacterMesh.h

## Purpose

`CharacterMesh` Instance — a CharacterAppearance that overlays an asset mesh+textures onto one body part of a Humanoid (the classic "character mesh" clothing/accessory path).

## Declared API

`class CharacterMesh : public DescribedCreatable<CharacterMesh, CharacterAppearance, sCharacterMesh>`

- `enum BodyPart { HEAD=0, TORSO=1, LEFTARM=2, RIGHTARM=3, LEFTLEG=4, RIGHTLEG=5 };`
- `BodyPart getBodyPart() const { return bodyPart; } void setBodyPart(BodyPart value);`
- Public int fields: `int baseTextureAssetId; int overlayTextureAssetId; int meshAssetId;` with BoundProps `prop_baseTextureAssetId`, `prop_overlayTextureAssetId`, `prop_meshAssetId`.
- Typed getters: `TextureId getBaseTextureId() const; TextureId getOverlayTextureId() const; MeshId getMeshId() const;`
- Overrides: protected `applyByMyself(Humanoid*)`, `onPropertyChanged(const Reflection::PropertyDescriptor&)`.

## Gotchas

- Asset ids are plain `int` members exposed publicly — the typed Texture/MeshId views are produced by getters (.cpp conversion).
- BodyPart enum is serialized; order is fixed.

## UNKNOWN

- What applyByMyself attaches (MeshPart wiring in .cpp — see [CharacterMesh.md](../../v8datamodel/CharacterMesh.md)).

## Cross-links

- Implementation: [App/v8datamodel/CharacterMesh.md](../../v8datamodel/CharacterMesh.md).
- Base: [CharacterAppearance.md](CharacterAppearance.md).
