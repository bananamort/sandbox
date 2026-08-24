# Smoke.cpp

## Purpose

Implements `Smoke` ("Smoke"), the legacy particle-effect Instance parented to parts: Enabled toggle, Color, Size, Opacity, RiseVelocity with dual UI/XML descriptor pairs and clamping helpers consumed by the renderer.

## Key types and API

Descriptors:
- `prop_Enabled("Enabled")` — BoundProp bool, category "Data", default true.
- `prop_Color("Color")` — Color3 category_Data, default white.
- UI pair (cap **UI**): "Size" / "Opacity" / "RiseVelocity" → setSizeUi/setOpacityUi/setRiseVelocityUi.
- XML pair (cap **STREAMING**, serialized names literally `size_xml`, `opacity_xml`, `riseVelocity_xml`): same getters, raw setters.
- Constants: MaxSize 100.0, MaxRiseVelocity 25.0.

Clamp ladder: UI setters clamp (size 0.1–100; opacity 0–1; rise −25..25) then delegate to raw setters which raise BOTH xml+UI change events; when clamped value equals current raw but differed from input, only the UI descriptor re-raises (UI snaps back). getClamped* accessors for renderer reads. Defaults: size 1, opacity 0.5, riseVelocity 1.

## Usage / reflection touchpoints

Script-facing effect instance. Pairs with Sparkles.md/Fire.md in this folder; particle rendering under [Rendering](../../Rendering/).

## Gotchas

- The STREAMING descriptors serialize under odd names (`size_xml` etc.) while Lua sees Size/Opacity/RiseVelocity — file-format vs script-name mismatch is intentional legacy.
- Raw setters accept UNCLAMPED values via replication path — only UI writes clamp; renderer must use getClamped*.
- Negative size possible through streaming setter despite 0.1 floor on UI path.
