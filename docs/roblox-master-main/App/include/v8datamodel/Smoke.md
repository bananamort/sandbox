# App/include/v8datamodel/Smoke.h

## Purpose

`Smoke` — creatable legacy particle `Effect` (Instance + Effect mix-in) parented to parts: color, size, opacity, rise velocity with UI/raw setter pairs and clamped getters; enabled toggle.

## Declared API

`class Smoke : public DescribedCreatable<Smoke, Instance, sSmoke>, public Effect`

- Statics: `const float MaxRiseVelocity`, `MaxSize` (defined out-of-line) with static getters `getMaxRiseVelocity()/getMaxSize()`.
- Reflection: `static Reflection::BoundProp<bool> prop_Enabled`; inline `bool getEnabled() const`; `void onChangedEnabled(const PropertyDescriptor&)`.
- Properties with dual setters (Ui vs engine) + raw/clamped getter pairs:
  - Color: `setColor(Color3)` / inline `getColor()`.
  - Size: `setSizeUi(float)`, `setSize(float)`, inline `getSizeRaw()`, `getClampedSize()`.
  - Opacity: `setOpacityUi(float)`, `setOpacity(float)`, `getOpacityRaw()`, `getClampedOpacity()`.
  - RiseVelocity: `setRiseVelocityUi(float)`, `setRiseVelocity(float)`, `getRiseVelocityRaw()`, `getClampedRiseVelocity()`.
- Parenting: inline protected `askSetParent` requires a PartInstance parent; `askAddChild {return true;}`.

## Gotchas

- Ui vs raw setter split mirrors the old Studio grid scaling — Ui variants rescale before clamping.
- Must be child of a PartInstance; parenting elsewhere is rejected.
- Only Enabled has a BoundProp in this header — other props' descriptors live elsewhere or are registered dynamically.

## UNKNOWN

- MaxSize/MaxRiseVelocity numeric values (constants out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/Smoke.md](../../v8datamodel/Smoke.md).
- Sibling effects: [Fire.md](Fire.md), [Sparkles.md](Sparkles.md); base: [Effect.md](Effect.md).
