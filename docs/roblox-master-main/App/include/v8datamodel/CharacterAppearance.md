# App/include/v8datamodel/CharacterAppearance.h

## Purpose

Character-appearance family: abstract `CharacterAppearance` (an `IModelModifier` that applies itself onto a Humanoid), `LegacyCharacterAppearance`, and the concrete creatables — `ShirtGraphic` (old T-shirts), clothing pair `Shirt`/`Pants` via shared non-creatable `Clothing`, plus legacy `BodyColors` and `Skin`.

## Declared API

`class CharacterAppearance : public DescribedNonCreatable<CharacterAppearance, Instance, sCharacterAppearance>, public IModelModifier` (RBXBaseClass)

- `virtual void apply();`
- Protected: `virtual void onAncestorChanged(const AncestorChanged&); virtual bool askSetParent(const Instance*) const;`
- Pure virtual: `virtual void applyByMyself(Humanoid* humanoid) = 0;`

`class LegacyCharacterAppearance : public CharacterAppearance`

- Override `apply()` with source comment ("Hack"): must only act in the backend case because it mutates other objects' properties (Part colors, Decal images) and crosstalk must be avoided.

`class ShirtGraphic : public DescribedCreatable<ShirtGraphic, LegacyCharacterAppearance, sShirtGraphic>`

- Public field `TextureId graphic;` + `static Reflection::BoundProp<TextureId> prop_Graphic;`
- `ShirtGraphic();` protected `applyByMyself(Humanoid*)`; private `dataChanged(...)` → `CharacterAppearance::apply()`.

`class Clothing : public DescribedNonCreatable<Clothing, CharacterAppearance, sClothing>` (friend CharacterAppearance)

- Public fields `TextureId outfit1; TextureId outfit2;` + BoundProps `prop_outfit1/prop_outfit2`.
- `virtual TextureId getTemplate() const { RBXASSERT(false); return NULL; }`
- Protected `applyByMyself(Humanoid*)`; protected `dataChanged` → apply.

`class Pants : public DescribedCreatable<Pants, Clothing, sPants>` — `prop_PantsTemplate`; `getTemplate() { return outfit1; } setTemplate(TextureId)`.
`class Shirt : public DescribedCreatable<Shirt, Clothing, sShirt>` — `prop_ShirtTemplate`; `getTemplate() { return outfit2; } setTemplate(TextureId)`.

`class BodyColors : public DescribedCreatable<BodyColors, LegacyCharacterAppearance, sBodyColors>`

- Six BrickColor members (`headColor`, `leftArmColor`, `rightArmColor`, `torsoColor`, `leftLegColor`, `rightLegColor`) each with a BoundProp (`prop_HeadColor` etc.); `applyByMyself(Humanoid*)`; `dataChanged` → apply.

`class Skin : public DescribedCreatable<Skin, LegacyCharacterAppearance, sSkin>` — member `BrickColor skinColor;` BoundProp `prop_skinColor`; `applyByMyself`; `dataChanged` → apply.

## Gotchas

- Shirt maps to outfit2, Pants to outfit1 — easy to swap mentally.
- Every concrete class re-applies the whole appearance on any property change via the identical `dataChanged` → `apply()` idiom.
- `Clothing::getTemplate()` asserts false at base — subclasses must override.
- The "backend case only" hack in LegacyCharacterAppearance::apply means client-side copies must not double-mutate parts.

## UNKNOWN

- Exact part/decal targets of each applyByMyself (.cpp — see [CharacterAppearance.md](../../v8datamodel/CharacterAppearance.md)).

## Cross-links

- Implementation: [App/v8datamodel/CharacterAppearance.md](../../v8datamodel/CharacterAppearance.md).
- Related: [CharacterMesh.md](CharacterMesh.md), [Humanoid] family, [IModelModifier.md](IModelModifier.md).
