# App/include/solver/SolverConfig.h

## Purpose

Single aggregate of every tunable the PGS solver reads: iteration counts, collision/friction parameters, per-constraint-type correction limits, SOR over-relaxation modulation, caching damping, and inconsistency-detector thresholds. Also defines the solver's compile-time feature macros at the top of the file.

## Declared API

Compile-time switches (defined/undefined at lines 3–13, in this header itself):
- Enabled: `ENABLE_SOR_CONSTRAINTS`, `ENABLE_SOR_COLLISIONS`, `ENABLE_LOCAL_SOR_MODULATION`, `ENABLE_HINGE_FRICTION`, `ENABLE_IMPULSE_CACHE_DAMPING_PER_EQUATION`, `ENABLE_SOLVER_DEBUG_SERIALIZER`.
- Commented out: `ENABLE_SOLVER_PROFILER`, `MIN_NORM_REPROJECT`, `PGS_MIN_NORM`, `DISABLE_ANGULAR_CONSTRAINTS`.

- `class SolverConfig`
  - `enum Type { Type_Default, Type_InconsistencyDetector, Type_PositionalCorrection }`; ctor `SolverConfig(Type type = Type_Default)` (defaults live in the .cpp).
  - Kernel: `unsigned pgsIterations`.
  - Collisions: `collisionRestitutionThreshold`, `collisionPenetrationMargin`, variable-margin trio `collisionPenetrationMarginMax/Min` + `collisionPenetrationMarginMaxBumpProportions` ("max height of a bump a rolling sphere can have … due to hitting an edge between two primitives"), `collisionPenetrationResolutionDamping`, `collisionPenetrationVelocityForMinMargin`, friction `collisionFrictionStaticToDynamicThreshold` / `collisionFrictionStaticScale` / `collisionFrictionDynamicScale`.
  - Align2Axes: `align2AxesFrictionConstant`, `align2AxesPositionStageFrictionConstant`, `align2AxesMaxCorrectiveAngle` (degrees), `align2AxesCorrectionDamping`.
  - BallInSocket: `ballInSocketMaxCorrectionByStabilization`, `ballInSocketCorrectionDamping`.
  - `struct ModulationParams { float thresholdMax, thresholdMin, aggressiveValue, conservativeValue, easingUpToAggressive, easingDownToConservative; }`; instances `sorConstraintsModulation`, `sorCollisionsModulation`, `cacheVStageModulation`, `cachePStageModulation`.
  - Stabilization: `stabilizationMassReductionPower`, `stabilizationInertiaScale`.
  - Cache: `velCacheDamping`, `posCacheDamping`, `bool constraintCachingEnabled`.
  - Integration: `float angularDamping`, `bool updateSimBodies`, `bool integrateOnlyPositions`.
  - Block PGS: `bool blockPGSEnabled` (default source of each constraint's `useBlock[i]`, see [Constraint.md](Constraint.md)).
  - SOR: `float velocityStageSOREnabled`, `positionStageSOREnabled` (floats despite the name).
  - Virtual masses: `bool virtualMassesEnabled`; islands: `bool useSimIslands`.
  - Inconsistency detector: `inconsistentConstraintDetectorEnabled`, `inconsistentConstraintMaxIterations`, per-type thresholds `inconsistentConstraintBallInSocketResidualThreshold` / `...DeltaThreshold` / `...Align2AxesThreshold` / `...CollisionThreshold` / `...CollisionBaseThreshold`, `bool printConvergenceDiagnostics`.

## Gotchas

- The feature macros live *inside* this header, so including it changes global build flags — any TU that defines its own combination before including gets redefinition warnings or silently different behavior.
- `velocityStageSOREnabled` is named like a bool but is a float (SOR factor gate).
- All defaults are set in the SolverConfig.cpp constructor; the header shows no initializers, so reading fields on a zero-initialized config is not meaningful.
