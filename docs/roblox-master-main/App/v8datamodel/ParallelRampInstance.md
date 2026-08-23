# ParallelRampInstance.cpp

## Purpose

Implements `ParallelRampInstance`, Instance name "ParallelRampPart" — a legacy prism-family ramp part whose two sloped faces are parallel. The ENTIRE file is wrapped in `#ifdef _PRISM_PYRAMID_`, so it only compiles into builds with the experimental prism/pyramid geometry enabled; in the standard build this translation unit is empty.

## Key types and API

`class ParallelRampInstance : public DescribedNonCreatable<ParallelRampInstance, PartInstance, sParallelRamp>` — NonCreatable: scripts cannot construct it via Instance.new. Default size Vector3(4, 4, 2). Ctor sets primitive geometry `GEOMETRY_PARALLELRAMP` and hard-codes surface types: NORM_X and NORM_X_NEG = UNIVERSAL, NORM_Y and NORM_Y_NEG = NO_SURFACE; marks render dirty. No reflection block of its own (inherits all PartInstance properties).

## Usage / reflection touchpoints

Registered only under the _PRISM_PYRAMID_ build flag; otherwise absent from the creator table entirely.

## Gotchas

- Compiled out by default — do not assume the class exists at runtime.
- Top/bottom surfaces are NO_SURFACE: no studs/inlets decoration and different weld/joint behavior on those faces.
- UNKNOWN: where _PRISM_PYRAMID_ is defined (build configuration outside this tree).
