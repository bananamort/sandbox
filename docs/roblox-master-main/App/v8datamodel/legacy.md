# legacy.cpp

## Purpose

Registers one enum descriptor: `Legacy::SurfaceConstraint` ("SurfaceConstraint"), the four-value legacy surface-constraint vocabulary that maps pre-refactor constraint ids onto user-facing joint names (`None`/`Hinge`/`SteppingMotor`/`Motor`). 19-line TU, no classes, no properties — a short doc is correct here.

## Key types and API

No class descriptors; no Security:: tiers.

- `RBX::Reflection::EnumDesc<Legacy::SurfaceConstraint>::EnumDesc()` — constructs `EnumDescriptor("SurfaceConstraint")` and fills the name pairs:
  - `NO_CONSTRAINT` → "None"
  - `ROTATE_LEGACY` → "Hinge"
  - `ROTATE_P_LEGACY` → "SteppingMotor"
  - `ROTATE_V_LEGACY` → "Motor"
- The enum itself is defined in [util/SurfaceType.h](../../include/util/SurfaceType.md) under `namespace RBX::Legacy` (0-based: NO_CONSTRAINT=0, ROTATE_LEGACY, ROTATE_P_LEGACY, ROTATE_V_LEGACY, plus `NUM_CONSTRAINT_TYPES` sentinel) with an in-header TODO about Joint.cpp ordering.
- Registry insertion happens separately via `RBX_REGISTER_ENUM(Legacy::SurfaceConstraint)` in [factoryregistration](factoryregistration.md) — this TU only supplies the display-name pairs.

## Usage / reflection touchpoints

Dead vocabulary in the kept tree: grep shows `SurfaceConstraint` referenced ONLY by this TU, the RBX_REGISTER_ENUM line in factoryregistration.cpp, and its defining header — no property descriptor, function signature, or runtime branch consumes it.

## Gotchas

- `V8DataModel/legacy.h` — the TU's own include — is EMPTY (literally `// empty`); all content was migrated to Util/SurfaceType.h and only the EnumDesc specialization stayed behind.
- The registered names are historical labels for what the values MEANT, not pointers at existing classes; nothing deserializes into this enum in current code.
