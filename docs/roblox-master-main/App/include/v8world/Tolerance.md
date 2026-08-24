# App/include/v8world/Tolerance.h

## Purpose

Static tolerance constants for joint building, snapping, dragger overlap, and resize checks — plus one deliberately obfuscated "no-clip hack" max-extents cube.

## Declared API

- `class Tolerance` — all static:
  - `static const Extents& maxExtents()` — see Gotchas; a ~10⁶-unit cube used as the "whole world" extents.
  - Joining grid: `mainGrid() = 0.1f`; alignment: `jointMaxUnaligned() = 0.05f`; `pointsUnaligned(p0,p1)` = squared-distance test against it.
  - Overlap minimums: `jointOverlapMin() = 0.35f` ("plate thickness is 0.4"), `jointOverlapMin2() = 0.1f`.
  - Snap-tight params ("Joint, Spawn: tight parameters, only achieved by a snap"): `jointAngleMax() = 0.01f` radians, `jointPlanarMax() = 0.01f`.
  - Rotate-loose params: `rotateAngleMax() = jointMaxUnaligned() × 0.5` ("length of the axle is always == 2"), `rotatePlanarMax() = jointMaxUnaligned()`.
  - Glue-loose params: `glueAngleMax()/gluePlanarMax() = jointMaxUnaligned()`.
  - Dragger/fuzzy-extents coupling: `maxOverlapOrGap() = ContactConnector::overlapGoal()` with in-header admission "For now this is nasty - it equals the connector overlap tolerance"; `maxOverlapAllowedForResize() = 3 × that`.

## Gotchas

- **`maxExtents()` is process-random**: `fuzzyMil = 1e6 + 1777.7 + (*((int*)(__DATE__ + 2)) % 1000)` mixes a compile-date-derived value (strict-aliasing-hostile int read of the `__DATE__` string literal) and each corner component gets `± rand()%65536` jitter, evaluated once at first call (static local). In-header comment: "cds: this is the no-clip hack patch. 1777.7 is arbitrary." Consequences: (a) values differ per build *and per run*; (b) any code persisting or comparing these extents across processes misbehaves; (c) reading `__DATE__+2` as `int` is UB by the letter of the standard but works in practice on the targeted toolchains.
- The rotate/glue tolerances are derived from `jointMaxUnaligned`, not independent constants — changing one shifts three features.
- `maxOverlapOrGap` creates a compile-time dependency from world-side tolerance to [v8kernel/ContactConnector.md](../v8kernel/ContactConnector.md).

## Cross-links

- Consumers of the angle/planar limits: [Joint.md](Joint.md) (`canBuildJoint(angleMax, planarMax)`), [RotateJoint.md](RotateJoint.md), [GlueJoint.md](GlueJoint.md); overlapGoal source: [v8kernel/ContactConnector.md](../v8kernel/ContactConnector.md).
