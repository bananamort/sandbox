# CornerWedgeInstance.cpp

## Purpose

Implements `CornerWedgeInstance` ("CornerWedgePart") — the corner-wedge PartInstance variant. Entire TU is inside `#ifdef _PRISM_PYRAMID_` (the same gate as the prism/pyramid/ramp family). Ctor-only: sets CORNERWEDGE geometry and blanks three surfaces.

## Key types and API

Descriptors: none of its own — inherits the full [PartInstance](PartInstance.md) reflection surface. Constants: `sCornerWedge = "CornerWedgePart"`, `category_CornerWedge = "Part "`, initial size Vector3(2,2,2).

Behavior:
- ctor `DescribedCreatable<CornerWedgeInstance, PartInstance, sCornerWedge>(InitialCornerWedgePartSize)` — sets name "CornerWedge" (NOTE: differs from registered class name!), geometry GEOMETRY_CORNERWEDGE on its Primitive, then NO_SURFACE on NORM_X_NEG, NORM_Y_NEG, NORM_Y; marks render dirty.

## Usage / reflection touchpoints

Sibling of PrismInstance/PyramidInstance/RightAngleRampInstance under the _PRISM_PYRAMID_ flag family; geometry lands in V8World CornerWedgePoly ([Base](../../Base/)).

## Gotchas

- Instance default NAME is "CornerWedge" while the class registers as "CornerWedgePart" — new instances don't match their class name unlike most parts.
- Three faces are force-cleared to NO_SURFACE at construction; scripts CAN set them back via normal Surface properties.
- Compiled out entirely without _PRISM_PYRAMID_.
