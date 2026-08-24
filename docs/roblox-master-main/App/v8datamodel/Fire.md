# Fire.cpp

## Purpose

Implements `Fire` ("Fire") — the classic fire particle effect: Enabled, Color/SecondaryColor, Size (clamped 2..30) and Heat (−25..25, negative = blue-ish). Dual UI/XML property pairs with clamped UI setters over raw STREAMING storage; new-particle default colors behind RenderNewParticles2Enable.

## Key types and API

Descriptors:
- `Fire::prop_Enabled("Enabled", "Data")` — BoundProp bool, default true.
- `prop_Color("Color")`, `prop_SecondaryColor("SecondaryColor")` — Color3; defaults orange/red, or (236,139,70)/(139,80,55)/255 under flag.
- Size pair: `prop_SizeUi("Size", UI)` + deprecated lowercase alias `dep_SizeUi("size")` → clamped setter; `prop_Size("size_xml", STREAMING)` → raw `setSize`.
- Heat pair: `prop_HeatUi("Heat", UI)` + `prop_Heat("heat_xml", STREAMING)` — same split.
No Security:: arguments.

Constants: `sFire = "Fire"`, `MaxHeat = 25`, `MaxSize = 30`; defaults size 5, heat 9. Flag `RenderNewParticles2Enable(true)`.

Behavior:
- UI setters clamp BEFORE compare; if clamp equals current raw but differs from input, they re-raise the UI prop (snapping UI feedback without state change). Raw setters raise BOTH xml and UI props.

## Usage / reflection touchpoints

Sibling effect of [Smoke](Smoke.md)/[Sparkles](Sparkles.md); superseded by [CustomParticleEmitter](CustomParticleEmitter.md).

## Gotchas

- The xml path accepts UNCLAMPED values (setSize has no clamp) — only the UI path enforces bounds; serialization can carry out-of-range sizes.
- Heat is signed: negative heat inverts flame behavior renderer-side.
- Triple-brace `{{{ }}}` flag blocks are the house style for conditional defaults.
