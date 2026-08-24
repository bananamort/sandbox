# Sky.cpp

## Purpose

Implements `Sky` ("Sky"), the skybox Instance: six cubemap face textures, star count, celestial-bodies toggle, sun/moon texture ids and angular sizes. Pure data holder — rendering consumes the properties; setters are change-tracked only.

## Key types and API

Descriptors (all category_Appearance, no security tier ⇒ default):
- `prop_SkyUp/Lf/Rt/Bk/Ft/Dn("SkyboxUp"/"SkyboxLf"/"SkyboxRt"/"SkyboxBk"/"SkyboxFt"/"SkyboxDn")` — TextureId each; defaults `textures/sky/sky512_{up,lf,rt,bk,ft,dn}.tex`.
- `prop_StarCount("StarCount")` — int default 3000.
- `prop_CelestialBodiesShown("CelestialBodiesShown")` — BoundProp bool default true.
- `prop_SunTexture("SunTextureId")` / `prop_MoonTexture("MoonTextureId")` — defaults `sky/sun.jpg`, `sky/moon.jpg`.
- `prop_SunAngularSize("SunAngularSize")` — float default 21; `prop_MoonAngularSize("MoonAngularSize")` — float default 11.

Analytics: `setSkyboxFt` fires a once-per-process GA "SkyBox" event with the asset id (only the FRONT face is tracked).

## Usage / reflection touchpoints

Script-facing property bag. Consumers: Lighting (replaceSky per RootInstance.md), render pipeline sky pass under [Rendering](../../Rendering/).

## Gotchas

- Only SkyboxFt changes report analytics — partial instrumentation.
- No validation on angular sizes or star count (negatives accepted).
- Defaults reference .tex/.jpg assets that must exist in content — missing files degrade silently renderer-side (UNKNOWN fallback behavior).
