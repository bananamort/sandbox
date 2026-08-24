# App/include/v8datamodel/Light.h

## Purpose

Part-attached lighting effects (Effect family): abstract `Light` base (enabled/shadows/color/brightness) with creatables `PointLight` (+range), `SpotLight` (+range/angle/face), `SurfaceLight` (same surface trio as SpotLight).

## Declared API

`class Light : public DescribedNonCreatable<Light, Instance, sLight>, public Effect`

- Props: prop_Enabled, prop_Shadows, prop_Color (Color3), prop_Brightness (float) with getters/setters.
- Protected tree rules: askSetParent/askAddChild (.cpp).
- `explicit Light(const char* name); virtual ~Light();`

`class PointLight : DescribedCreatable<PointLight, Light, sPointLight>` — `prop_Range`; get/setRange(float).

`class SpotLight : DescribedCreatable<..., sSpotLight>` — Range + Angle floats and `NormalId face` (`prop_Face` EnumProp) with getters/setters.

`class SurfaceLight : DescribedCreatable<..., sSurfaceLight>` — identical surface to SpotLight (Range/Angle/Face).

## Gotchas

- Face selection means lights emit from a specific part face (NormalId), not free orientation.
- Base is non-creatable; only the three shapes are script-visible.
- No intensity falloff controls beyond brightness/range in this drop.

## UNKNOWN

- Shadow implementation limits per light type (.cpp / GfxCore — see [Light.md](../../v8datamodel/Light.md)).

## Cross-links

- Implementation: [App/v8datamodel/Light.md](../../v8datamodel/Light.md).
- Kin: [Fire.md](Fire.md)/[Smoke.md]/[Sparkles.md], base [Effect.md](Effect.md).
