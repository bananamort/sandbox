# App/include/v8datamodel/Sparkles.h

## Purpose

`Sparkles` — creatable legacy particle `Effect` (Instance + Effect) parented to parts: enabled toggle plus color, with an extra legacy-color conversion pair.

## Declared API

`class Sparkles : public DescribedCreatable<Sparkles, Instance, sSparkles>, public Effect`

- Private: `bool enabled; Color3 color;`
- Ctor; empty inline virtual dtor.
- API: inline `bool getEnabled() const`; `setColor(Color3)` / inline `getColor()`; legacy pair `setLegacyColor(Color3)` / `Color3 getLegacyColor() const`.
- Descriptors: `static BoundProp<bool> prop_Enabled`, `static PropDescriptor<Sparkles, Color3> prop_Color`.
- `void onChangedEnabled(const Reflection::PropertyDescriptor&)`.
- Parenting: inline protected `askSetParent` requires PartInstance parent; `askAddChild {return true;}`.

## Gotchas

- Same Part-only parenting rule as [Smoke.md](Smoke.md)/[Fire.md](Fire.md).
- Legacy color getter/setter suggests palette-era compatibility mapping distinct from raw color.

## UNKNOWN

- What setLegacyColor maps to/from (out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/Sparkles.md](../../v8datamodel/Sparkles.md).
- Sibling effects: [Smoke.md](Smoke.md), [Fire.md](Fire.md); base: [Effect.md](Effect.md).
