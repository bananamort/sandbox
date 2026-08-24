# PrismInstance.cpp

## Purpose

Implements `PrismInstance` ("PrismPart", instance name "Prism") — an N-gon prism PartInstance variant (DescribedNonCreatable). Entire file compiled only under `#ifdef _PRISM_PYRAMID_`. Manages the NumSides geometry parameter (slices forced equal to sides), with square-footprint enforcement in size changes.

## Key types and API

Descriptors (category "Part " — note trailing space):
- `prop_sidesXML("sides")` — EnumPropDescriptor NumSidesEnum, cap STREAMING.
- `prop_sidesUI("Sides")` — same binding, cap UI (static, TU-local).
- Slices descriptor commented out ("Disable slice control for now").

Ctor: default size (4, 2, 4); sets primitive GEOMETRY_PRISM with parameters NumSides=8, NumSlices=8.

- `GetNumSides()`: reads geometryParameter "NumSides" cast to enum. `GetNumSlices()` returns "NumSides" too (NOT "NumSlices" — copy-paste).
- `SetNumSides(enum)`: raises BOTH sides descriptors' change events, then writes NumSides AND NumSlices = value; marks render dirty.
- `SetNumSlices(int)`: writes only "NumSlices"; render dirty (unreachable from reflection).
- `setPartSizeXml`: enforces square X/Z footprint — changing X forces Z=X; else changing Z forces X=Z; no-op path refreshes UI only.

Source comment: "This is identical to Pyramid - should descend from same object....."

## Usage / reflection touchpoints

Script surface limited to the two sides properties (STREAMING replicates). Pairs with PyramidInstance.md and PartInstance.md in this folder; V8World PrismPoly geometry.

## Gotchas

- Whole class is dead unless _PRISM_PYRAMID_ is defined — check build flags before assuming availability.
- GetNumSlices lies: reports NumSides value.
- SetNumSlices can produce desync (slices≠sides) that SetNumSides immediately clobbers.
- Category string is "Part " with a trailing space — property-grid grouping quirk preserved verbatim.
