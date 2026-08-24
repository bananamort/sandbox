# Sparkles.cpp

## Purpose

Implements `Sparkles` ("Sparkles"), the legacy particle-effect Instance: Enabled toggle plus SparkleColor with a lossy legacy Color compatibility mapping. Data holder only — rendering consumes properties.

## Key types and API

Descriptors:
- `prop_Enabled("Enabled")` — BoundProp bool, category "Data", default true.
- `prop_Color("SparkleColor")` — Color3, category_Data; default Color3(144,25,255)/255 (purple).
- `prop_LegacyColor("Color")` — Color3, cap **LEGACY_SCRIPTING** — LOSSY round-trip: setter maps incoming (r,g,b) → (r·144/255, g·25/255, b) [integer math truncation]; getter inverts approximately via (r·255/144, g·255/25, b).

## Usage / reflection touchpoints

Script-facing effect instance. Pairs with Fire.md/Smoke.md in this folder.

## Gotchas

- Legacy Color writes destroy information (only blue channel survives intact) — old places using Color get re-clamped into the purple/green plane.
- Integer division in both conversion directions means values drift on repeated legacy reads/writes.
