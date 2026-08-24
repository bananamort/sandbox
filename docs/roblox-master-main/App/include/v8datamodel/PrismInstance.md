# App/include/v8datamodel/PrismInstance.h

## Purpose

`PrismInstance` — experimental prism part (`PRISM_PART`) with configurable side count (3–20) and slice count. Entire file gated behind `#ifdef _PRISM_PYRAMID_`; shape parameters deliberately live in the V8World `Poly`, not on the instance.

## Declared API

(All inside `#ifdef _PRISM_PYRAMID_`)

`class PrismInstance : public DescribedNonCreatable<PrismInstance, PartInstance, sPrism>`

- `enum NumSidesEnum { sides3 = 3, sides4 ... sides20 }`.
- `static const Reflection::EnumPropDescriptor<PrismInstance, NumSidesEnum> prop_sidesXML;`
- `void SetNumSides(const NumSidesEnum num); NumSidesEnum GetNumSides() const;`
- `void SetNumSlices(const int num); int GetNumSlices() const;`
- Overrides: `virtual PartType getPartType() const { return PRISM_PART; }`, `virtual void setPartSizeXml(const Vector3& rbxSize)`.
- Private comment block: "These are redundant with data in the Poly" — commented-out NumSides/NumSides members.

## Gotchas

- Dead code unless `_PRISM_PYRAMID_` is defined (same gate as [ParallelRampInstance.md](ParallelRampInstance.md)/[PyramidInstance.md](PyramidInstance.md)).
- Setters named PascalCase (Set/Get) unlike the camelCase house style — legacy/experimental surface.
- Comment in Pyramid sibling confirms: num sides/slices stored in the Poly "just like size and other stuff" — instance-level setters are thin proxies into world geometry.

## UNKNOWN

- Whether `_PRISM_PYRAMID_` is set anywhere in this drop's build files.

## Cross-links

- Implementation: [App/v8datamodel/PrismInstance.md](../../v8datamodel/PrismInstance.md).
- Family: [PartInstance.md](PartInstance.md), [PyramidInstance.md](PyramidInstance.md), [ParallelRampInstance.md](ParallelRampInstance.md), [RightAngleRampInstance.md](RightAngleRampInstance.md).
