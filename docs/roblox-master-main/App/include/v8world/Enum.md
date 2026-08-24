# App/include/v8world/Enum.h

## Purpose

Simulation-state enums shared across the world slice: assembly sleep lifecycle, throttle eligibility, and per-edge sim state. Consumed by [Assembly.md](Assembly.md), [Edge.md](Edge.md), SleepStage, and the kernel.

## Declared API

- `namespace RBX::Sim`
  - `typedef enum { ANCHORED, RECURSIVE_WAKE_PENDING, WAKE_PENDING, AWAKE, SLEEPING_CHECKING, SLEEPING_DEEPLY, REMOVING } AssemblyState;`
    - Inline helpers: `isMovingAssemblyState` (AWAKE, RECURSIVE_WAKE_PENDING, WAKE_PENDING), `isSleepingAssemblyState` (SLEEPING_CHECKING, SLEEPING_DEEPLY), `outOfKernelAssemblyState` (sleeping ∪ REMOVING).
  - `ThrottleType { CAN_NOT_THROTTLE = 0, CAN_THROTTLE, NUM_THROTTLE_TYPE, UNDEFINED_THROTTLE }` — on `_WIN32` declared as `enum : unsigned char`.
  - `EdgeState { UNDEFINED, STEPPING, SLEEPING, CONTACTING, CONTACTING_SLEEPING }` — also `unsigned char`-backed on `_WIN32`.

## Gotchas

- The closing namespace comment says `// namespace WORLD` — stale; everything here lives in `Sim`.
- Only Windows gets the fixed-underlying-type (`unsigned char`) variants; other platforms use plain ints — serialization/ABI code must not assume 1-byte enums cross-platform.
- `NUM_THROTTLE_TYPE` sits *before* `UNDEFINED_THROTTLE`, so counting loop idioms must not treat the last enumerator as a valid state bucket.

## Cross-links

- Users: [Assembly.md](Assembly.md) (`getAssemblyIsMovingState`, filter/sleep sections), [Edge.md](Edge.md) (`get/setEdgeState`, throttle), [SleepStage.md](SleepStage.md).
