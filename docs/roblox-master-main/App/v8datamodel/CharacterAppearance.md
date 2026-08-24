# CharacterAppearance.cpp

## Purpose

Implements the character-appearance family in one TU: base `CharacterAppearance` ("CharacterAppearance") plus `ShirtGraphic` ("Shirt Graphic"), `Clothing` ("Clothing") with `Shirt` ("Shirt") / `Pants` ("Pants") templates, `Skin` ("Skin"), and `BodyColors` ("Body Colors") — each able to paint itself onto a parented Humanoid's body parts, with R15 15-part name mapping behind `humanoid->getUseR15()`.

## Key types and API

Descriptors (all category_Appearance, no Security:: arguments):
- `ShirtGraphic::prop_Graphic("Graphic")` — TextureId BoundProp.
- `Clothing::prop_outfit1("Outfit1", LEGACY)`, `prop_outfit2("Outfit2", LEGACY)` — TextureId; `Shirt::prop_ShirtTemplate("ShirtTemplate")` forwards INTO outfit2, `Pants::prop_PantsTemplate("PantsTemplate")` into outfit1.
- `Skin::prop_skinColor("SkinColor")` — BrickColor, default brick_226.
- `BodyColors`: prop_HeadColor/LeftArmColor/RightArmColor/TorsoColor/LeftLegColor/RightLegColor — BrickColor each; defaults 226/226/226/28/23/23.

Constants: sCharacterAppearance, sShirt, sPants, sShirtGraphic, sClothing, sSkin, sBodyColors. Declared flag `DYNAMIC_FASTFLAG(UseR15Character)`.

Behavior:
- `CharacterAppearance::apply()` — resolves `Humanoid::modelIsCharacter(getParent())`, delegates to virtual applyByMyself.
- `onAncestorChanged` — re-applies on BOTH new and old parent when moved between characters.
- `askSetParent` — ModelInstance parents only.
- `LegacyCharacterAppearance::apply()` — backend-processing gate before Super::apply.
- ShirtGraphic.applyByMyself — first Decal on visible torso gets `setTexture(graphic)`.
- Clothing.applyByMyself / CharacterMesh-style — fireOutfitChanged on legs/torso/arms.
- Skin.applyByMyself — setColor(skinColor) across all six R6 limbs.
- BodyColors.applyByMyself — skipped entirely if a Skin modifier exists higher up (`findFirstModifierOfType<Skin>`); R15 path colors by literal child NAMES ("LowerTorso"/"UpperTorso"/"Head"/"RightUpperArm"…15 parts), R6 path via Humanoid limb accessors.

## Usage / reflection touchpoints

Applied during player spawn/appearance loading; pairs with [Decal](Decal.md) (torso graphic), [Humanoid](CharacterMesh.md)-adjacent docs, and [ModelInstance](ModelInstance.md) parenting rules.

## Gotchas

- ShirtTemplate/PantsTemplate are aliases over legacy Outfit2/Outfit1 — serializing both names round-trips but scripts see two properties for one value.
- BodyColors silently does NOTHING when any Skin ancestor-modifier exists — skin color wins unconditionally.
- R15 mapping is by hardcoded part-name strings — renamed/custom rigs get no color.
- askSetParent allows ANY ModelInstance, not just character models; apply() silently no-ops without a Humanoid sibling.
