# App/include/v8world/SurfaceData.h

## Purpose

Per-surface legacy controller binding stored on a Primitive's faces ([Primitive.md](Primitive.md) `surfaceData`): which `LegacyController::InputType` a surface feeds and its two float parameters.

## Declared API

- `class SurfaceData`
  - Members: `LegacyController::InputType inputType; float paramA; float paramB;`
  - Defaults: `inputType(NO_INPUT), paramA(-0.5), paramB(0.5)` *(note: −0.5/0.5 asymmetric defaults)*.
  - `bool operator==(const SurfaceData&) const` — exact float equality on all three fields.
  - `static const SurfaceData& empty();` — function-local static singleton.
  - `bool isEmpty() const {return *this == empty();}`

## Gotchas

- `isEmpty` relies on exact float equality against default-constructed values — any arithmetic on params breaks it.
- Header includes [Controller.md](Controller.h→Controller.md) **before** `#pragma once` — harmless here but unusual include placement.

## Cross-links

- Enum source: [Controller.md](Controller.md); storage: [Primitive.md](Primitive.md) (`get/setSurfaceData`, NULL → `SurfaceData::empty()`).
