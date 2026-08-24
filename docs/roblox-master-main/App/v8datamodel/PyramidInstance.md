# PyramidInstance.cpp

## Purpose

Implements `PyramidInstance` ("PyramidPart", instance name "Pyramid") — an N-sided pyramid PartInstance variant (DescribedNonCreatable), compiled only under `#ifdef _PRISM_PYRAMID_`. Near-verbatim twin of PrismInstance (the shared-base-class complaint is a comment in PrismInstance.cpp: "This is identical to Pyramid - should descend from same object....."; this TU carries no such note).

## Key types and API

Descriptors (category "Part ", trailing space):
- `prop_sidesXML("sides")` — EnumPropDescriptor NumSidesEnum, cap STREAMING.
- `prop_sidesUI("Sides")` — same, cap UI (TU-static).
- Slices control commented out.

Ctor: default size (4, 4, 4) [prism uses (4,2,4)]; primitive GEOMETRY_PYRAMID, NumSides=8, NumSlices=8, top surface NORM_Y → NO_SURFACE.

- `GetNumSides()` reads "NumSides" param as enum; `GetNumSlices()` ALSO reads "NumSides" (copy-paste bug shared with prism).
- `SetNumSides(enum)`: raises both sides descriptors, writes NumSides=NumSlices=value, render-dirty. `SetNumSlices(int)` writes only slices (reflection-unreachable).
- `setPartSizeXml`: square X/Z footprint enforcement identical to Prism.

## Usage / reflection touchpoints

Same surface shape as PrismInstance.md; pairs with PartInstance.md here, V8World PyramidPoly.

## Gotchas

- Dead code unless _PRISM_PYRAMID_ defined.
- GetNumSlices returns sides count, not slices.
- Only the Y face is stripped of surfaces at construction; other faces keep inherited defaults.
- UNKNOWN: NumSidesEnum valid range (header-side).
