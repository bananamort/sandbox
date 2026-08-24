# Light.cpp

## Purpose

Implements the dynamic-light family: base `Light` ("Light", non-creatable — Enabled/Color/Brightness/Shadows), `PointLight` (Range 0..60, default 8), `SpotLight` and `SurfaceLight` (Range + Angle 0..180° + Face NormalId; defaults range 16, angle 90, front face). All clamped setters; lights parent to Parts only. GA "LightingObjects" tracked once per process.

## Key types and API

Descriptors (all category_Appearance, no Security:: arguments):
- Light statics: prop_Enabled("Enabled", true), prop_Color("Color", white), prop_Brightness("Brightness", 1.0 — setter floors at 0, NO upper clamp), prop_Shadows("Shadows", false).
- PointLight::prop_Range("Range"); SpotLight/SurfaceLight: prop_Range + prop_Angle + prop_Face(NormalId).

Constants: sLight/sPointLight/sSpotLight/sSurfaceLight.

Behavior:
- askSetParent — PartInstance only (`isA` check); askAddChild always true.
- All three Range setters share the same 0..60 clamp with comment "Limit range due to rendering constraints".

## Usage / reflection touchpoints

Rendered by the lighting pipeline ([Lighting](Lighting.md) service owns ambient/sky settings, these are per-part sources).

## Gotchas

- Brightness has a lower clamp only — huge values accepted (renderer-dependent blowout).
- SurfaceLight vs SpotLight differ ONLY in registered class name/ctor defaults in this TU — actual cone-vs-face rendering is renderer-side.
