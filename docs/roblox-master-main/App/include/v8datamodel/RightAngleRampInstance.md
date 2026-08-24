# App/include/v8datamodel/RightAngleRampInstance.h

## Purpose

`RightAngleRampInstance` — ramp part (`RIGHTANGLERAMP_PART`) with no extra state; whole header gated behind `#ifdef _PRISM_PYRAMID_` like the prism/pyramid experimental family.

## Declared API

(All inside `#ifdef _PRISM_PYRAMID_`)

`class RightAngleRampInstance : public DescribedNonCreatable<RightAngleRampInstance, PartInstance, sRightAngleRamp>`

- `RightAngleRampInstance(); ~RightAngleRampInstance();`
- `/*override*/ virtual PartType getPartType() const { return RIGHTANGLERAMP_PART; }`

## Gotchas

- Dead unless `_PRISM_PYRAMID_` is defined — same optional-family gate as Prism/Pyramid/ParallelRamp.
- Pure part-type tag over PartInstance: no geometry parameters of its own.

## UNKNOWN

- Build-flag definition status in shipped vcxproj files.

## Cross-links

- Implementation: [App/v8datamodel/RightAngleRampInstance.md](../../v8datamodel/RightAngleRampInstance.md).
- Family: [PartInstance.md](PartInstance.md), [PrismInstance.md](PrismInstance.md), [PyramidInstance.md](PyramidInstance.md), [ParallelRampInstance.md](ParallelRampInstance.md).
