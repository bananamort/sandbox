# ExtrudedPartInstance.cpp

## Purpose

Implements `ExtrudedPartInstance` ("TrussPart", instance name "Truss") — the climbable truss beam part: all six surfaces UNIVERSAL at construction, Style enum (truss visual cross-beams), and size constraints forcing an extruded shape (two axes pinned at 2 studs, third ≤64).

## Key types and API

Descriptors (category "Part " via `category_ExtrudedPart`, no Security:: arguments):
- `ExtrudedPartInstance::prop_styleXml("style", STREAMING)` + `prop_styleUi("Style", UI)` — enum VisualTrussStyle (registered in [Enums](Enums.md) as "Style").

Constants: `sExtrudedPart = "TrussPart"`; MinExtrudedDimensionSize=2, MaxExtrudedDimensionSize=64.

Behavior:
- ctor sets all six Primitive surface types to UNIVERSAL (climbable from every face), default style FULL_ALTERNATING_CROSS_BEAM.
- `setPartSizeXml` — accepts only when ≥2 dimensions are exactly 2 AND largest ≤64; otherwise clamps to [2,64] per axis, and if fewer than 2 dims are minimal, collapses the two smaller axes to 2 (keeping the longest as the beam axis); non-finite sizes fall into the z-branch via assert fallback.
- `getResizeHandleMask` — cube truss (2×2×2): all faces resizable; extruded: only the two faces of the long axis.
- `getResizeIncrement` — 2.

## Usage / reflection touchpoints

Sibling of [CornerWedgeInstance](CornerWedgeInstance.md)/ramp family under PartInstance; Humanoid climbing consumes UNIVERSAL surfaces ([CharacterMesh](CharacterMesh.md)-adjacent humanoid docs).

## Gotchas

- The size validator uses EXACT float equality against 2 for the "min dimension" count — a size of 2.000001 counts as non-minimal and gets re-clamped.
- Setting Style never touches geometry — it's purely visual render data (shouldRenderSetDirty).
- Non-finite input silently produces a 2-stud cube path through the else branch.
