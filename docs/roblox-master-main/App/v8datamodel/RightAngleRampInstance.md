# RightAngleRampInstance.cpp

## Purpose

Implements `RightAngleRampInstance` ("RightAngleRampPart", instance name "RightAngleRamp") — a right-triangle ramp PartInstance variant (DescribedNonCreatable), compiled only under `#ifdef _PRISM_PYRAMID_`. Constructor-only TU: sets geometry and surface defaults; no properties of its own.

## Key types and API

- Ctor: default size (4, 4, 2); primitive GEOMETRY_RIGHTANGLERAMP; surfaces: NORM_X_NEG → UNIVERSAL, NORM_Y_NEG → UNIVERSAL, NORM_Y → NO_SURFACE; immediate `shouldRenderSetDirty()`.
- Dtor empty. No reflection descriptors at all.

## Usage / reflection touchpoints

No script surface beyond inherited PartInstance behavior. Pairs with PrismInstance.md/PyramidInstance.md (same _PRISM_PYRAMID_ gating family) and PartInstance.md in this folder; V8World RightAngleRampPoly collision geometry.

## Gotchas

- Dead code unless _PRISM_PYRAMID_ defined.
- Unlike its prism/pyramid siblings it exposes NO sides/slices property — shape is fixed.
- Surface defaults differ from plain parts: both bottom and back faces UNIVERSAL, top NO_SURFACE — affects weld/join tooling that reads surface types.
