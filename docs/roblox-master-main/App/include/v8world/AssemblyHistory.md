# App/include/v8world/AssemblyHistory.h

## Purpose

Sleep-detection memory for one Assembly: keeps a rolling `Average<PhysicsCoord>` of the assembly's physics coordinate and answers "has this assembly been still long enough to sleep?" Used by SleepStage through `Assembly::sampleAndNotMoving`.

## Declared API

- `class AssemblyHistory`
  - Members: `Average<PhysicsCoord> average; int stepsSinceSample; int awakeSteps; float maxDeviationSquared;`
  - Private statics (values resolved in .cpp): `sampleSkip()`, `bufferSize()`, `sleepTolerance()`, `sleepToleranceSquared()`.
  - Private: `bool notMoving(); void updateMaxDeviationSquared(); PhysicsCoord getAssemblyPhysicsCoord(Assembly& a);`
  - `AssemblyHistory(Assembly& a); ~AssemblyHistory();`
  - `void clear(Assembly& a);` — re-seed the average.
  - `bool sampleAndNotMoving(Assembly& a);` — sample current coord, report stillness.
  - `bool preventNeighborSleep();` — true while this assembly should keep neighbors awake.
  - `void wakeUp();` — reset awake counters.

## Gotchas

- All tuning constants (`sampleSkip`, `bufferSize`, `sleepTolerance*`) are defined in the .cpp — header alone gives no numbers.

## UNKNOWN

- Actual values of `sleepTolerance()` / `bufferSize()` / `sampleSkip()` and whether `preventNeighborSleep` is keyed on `awakeSteps` or on external animation flags.

## Cross-links

- Consumer: [Assembly.md](Assembly.md) (SleepStage section), [SleepStage.md](SleepStage.md).
- Averaging primitive: Base `rbx::Average` — see [v8kernel/Constants.md](../v8kernel/Constants.md) for step-rate context.
