# App/include/v8datamodel/CornerWedgeInstance.h

## Purpose

`CornerWedgeInstance` ("CornerWedge" part) — the corner-wedge Part shape. Entire class is compiled only under `#ifdef _PRISM_PYRAMID_`.

## Declared API

`class CornerWedgeInstance : public DescribedCreatable<CornerWedgeInstance, PartInstance, sCornerWedge>`

- `CornerWedgeInstance(); ~CornerWedgeInstance();`
- `virtual PartType getPartType() const { return CORNERWEDGE_PART; }`

## Gotchas

- Gated behind the `_PRISM_PYRAMID_` build flag — absent from builds that don't define it.
- Derives directly from [PartInstance](PartInstance.md) (not FormFactorPart like BasicPartInstance).

## UNKNOWN

- Whether `_PRISM_PYRAMID_` is defined in shipping builds of this drop.

## Cross-links

- Implementation: [App/v8datamodel/CornerWedgeInstance.md](../../v8datamodel/CornerWedgeInstance.md).
- Shape family: [BasicPartInstance.md](BasicPartInstance.md), [PrismInstance.md](PrismInstance.md), [PyramidInstance.md](PyramidInstance.md).
