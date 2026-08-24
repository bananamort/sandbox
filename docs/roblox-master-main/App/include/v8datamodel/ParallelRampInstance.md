# App/include/v8datamodel/ParallelRampInstance.h

## Purpose

`ParallelRampInstance` — a `PartInstance` subtype reporting `PARALLELRAMP_PART`. Entire header is gated behind `#ifdef _PRISM_PYRAMID_`; without that build flag the class does not exist at all.

## Declared API

`class ParallelRampInstance : public DescribedNonCreatable<ParallelRampInstance, PartInstance, sParallelRamp>`

- `ParallelRampInstance()` / `~ParallelRampInstance()`
- `/*override*/ virtual PartType getPartType() const { return PARALLELRAMP_PART; }`

## Gotchas

- Dead unless `_PRISM_PYRAMID_` is defined — the whole prism/pyramid ramp family (see [PrismInstance](PrismInstance.md), [PyramidInstance](PyramidInstance.md)) is compile-time optional.
- No geometry/size properties of its own: pure part-type tag over PartInstance.

## UNKNOWN

- Whether `_PRISM_PYRAMID_` is defined in any shipped vcxproj of this drop.

## Cross-links

- Implementation: [App/v8datamodel/ParallelRampInstance.md](../../v8datamodel/ParallelRampInstance.md).
- Family: [PartInstance.md](PartInstance.md), [BasicPartInstance.md](BasicPartInstance.md), [PrismInstance.md](PrismInstance.md), [PyramidInstance.md](PyramidInstance.md), [RightAngleRampInstance.md](RightAngleRampInstance.md).
