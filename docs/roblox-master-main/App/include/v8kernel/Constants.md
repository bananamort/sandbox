# App/include/v8kernel/Constants.h

## Purpose

Physics-tuning constants for the v8 kernel: the step-hierarchy clock (UI → world → kernel/free-fall steps and their dts), impulse-solver iteration/accuracy limits, gravity, joint spring constants (K) derived from part sizes, and legacy LEGO joint force tables.

## Declared API

- `class Constants` — private ctor (static-only class).
  - Private: `JOINT_FORCE_DATA = 7`; static arrays `MAX_LEGO_JOINT_FORCES_THEORY[7]` / `MAX_LEGO_JOINT_FORCES_MEASURED[7]`; functions `LEGO_GRID_MASS()` (kg), `LEGO_JOINT_K()` (kg/s²), `LEGO_DEFAULT_ELASTIC_K()`, `unitJointK()`, `getJointKMultiplier(const Vector3& clippedSortedSize, bool ball)`.
  - Timestep block: `uiStepsPerSec()` inline = `longUiStepsPerSec() * 2`; `longUiStepsPerSec()` inline = **30** (so uiStepsPerSec = 60); declared elsewhere: `worldStepsPerUiStep`, `worldStepsPerLongUiStep`, `kernelStepsPerWorldStep`, `freeFallStepsPerWorldStep`, `worldStepsPerSec`, `kernelStepsPerSec`, `kernelStepsPerUiStep`, `freeFallStepsPerSec`, `impulseSolverMaxIterations`, `float impulseSolverAccuracy`, `int impulseSolverAccuracyScalar`, `impulseSolverSymStateTorqueBound`, `impulseSolverSymStateForceBound`, `uiDt`, `longUiStepDt`, `worldDt`, `kernelDt`, `freeFallDt`, `const Vector3& denormalSmall()`.
  - Dimensions/K block: `getKmsGravity()` inline → **−9.81f**; `getKmsMaxJointForce(float grid1, float grid2)`; `getElasticMultiplier(float elasticity)`; `getJointK(const Vector3& size, bool ball)` (kg/s²).

## Gotchas

- Gravity is negative-Y convention baked here (`−9.81`); code adding "gravity" must not negate again.
- The LEGO_* names are historical: values now parameterize general Roblox joints; force tables are private and only reachable via `getKmsMaxJointForce`.
- Only three functions are defined in-header (`uiStepsPerSec`, `longUiStepsPerSec`, `getKmsGravity`); everything else resolves in Constants.cpp outside App/include.

## UNKNOWN

- Actual values of the declared-elsewhere timestep/solver constants (defined in App/v8kernel/Constants.cpp).
