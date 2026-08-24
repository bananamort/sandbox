# App/include/v8datamodel/PyramidInstance.h

## Purpose

`PyramidInstance` — experimental pyramid part (`PYRAMID_PART`) with configurable side count (3–20) and slice count; same `#ifdef _PRISM_PYRAMID_` gating as the prism family. Shape data lives in the V8World Poly, not on the instance.

## Declared API

(All inside `#ifdef _PRISM_PYRAMID_`)

`class PyramidInstance : public DescribedNonCreatable<PyramidInstance, PartInstance, sPyramid>`

- `enum NumSidesEnum { sides3 = 3, sides4 ... sides20 }`.
- `static const Reflection::EnumPropDescriptor<PyramidInstance, NumSidesEnum> prop_sidesXML;`
- `void SetNumSides(const NumSidesEnum num); NumSidesEnum GetNumSides(void) const;`
- `void SetNumSlices(const int num); int GetNumSlices(void) const;`
- Overrides: `virtual PartType getPartType() const { return PYRAMID_PART; }`, `virtual void setPartSizeXml(const Vector3& rbxSize)`.
- Private note: "num sides, num slices — no redundant data — stored in the Poly just like size and other stuff".

## Gotchas

- Dead unless `_PRISM_PYRAMID_` defined; PascalCase Set/Get naming breaks house style (experimental-era code).
- setPartSizeXml override implies pyramid size interacts with the Poly representation, diverging from plain PartInstance sizing.

## UNKNOWN

- Build-flag definition status in shipped vcxproj files.

## Cross-links

- Implementation: [App/v8datamodel/PyramidInstance.md](../../v8datamodel/PyramidInstance.md).
- Family: [PartInstance.md](PartInstance.md), [PrismInstance.md](PrismInstance.md), [ParallelRampInstance.md](ParallelRampInstance.md), [RightAngleRampInstance.md](RightAngleRampInstance.md).
