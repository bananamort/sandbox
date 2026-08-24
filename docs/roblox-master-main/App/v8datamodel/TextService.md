# TextService.cpp

## Purpose

Implements `TextService`, the per-DataModel font/text-metrics service: owns the Typesetter array indexed by Font, registers/providers them to the renderer, exposes the script-facing GetTextSize measure call, and defines the Font/FontSize/TextXAlignment/TextYAlignment enums used across the GUI stack.

## Key types and API

Descriptor:
- `func_getTextSize("GetTextSize(string, fontSize:int, font:Font, frameSize:Vector2):Vector2")` — **Security::RobloxScript**; returns Vector2::zero for out-of-range fonts or missing typesetter (no error).

Enums registered here:
- `FontSize`: Size8,9,10,11,12,14,18,24,36,48,28,32,42,60,96 — NOTE registration order puts Size28 AFTER Size48 etc. (non-monotonic listing, legacy order preserved).
- `Font`: Legacy, Arial, ArialBold, SourceSans, SourceSansBold, SourceSansLight, SourceSansItalic.
- `TextXAlignment`: Left/Center/Right; `TextYAlignment`: Top/Center/Bottom.

Conversions: FromTextFont/ToTextFont map between engine Text::Font and service enum (default→LEGACY with RBXASSERT); ToTextXAlign/YAlign likewise.

Typesetter lifecycle: ctor calls clearTypesetters(); under FFlag TypesettersReleaseResources(true) it RELEASES resources of existing typesetters instead of reallocating (else fresh array). registerTypesetter/getTypesetter index-guarded by RBXASSERT only.

FFlags declared: TypesettersReleaseResources(true), UseDynamicTypesetterUTF8(false) [consumed elsewhere].

## Usage / reflection touchpoints

GetTextSize is the script text-measure API. Pairs with GuiObject text family docs in this folder; Typesetter implementation under GfxBase.

## Gotchas

- getTextSize silently returns zero rather than erroring on unregistered fonts — a missing platform typesetter looks like empty text metrics.
- clearTypesetters under the flag releases GPU resources but keeps pointers — reuse-after-release ordering matters (UNKNOWN renderer contract header-side).
