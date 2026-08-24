# App/include/v8kernel/Kernel.h

## Purpose

The kernel itself: terminal `IStage` (`KERNEL_STAGE`) owning `KernelData` (bodies/points/connectors) and running the physics step — normal or throttled paths, plus "Funny Physics" special-case stepping. Hosts a public [PGSSolver](../solver/Solver.md) instance, energy diagnostics, and per-phase code profilers.

## Declared API

- `class Kernel : public IStage, public BodyPvSetter`
  - `Kernel(IStage* upstream)`; dtor; static `int numKernels;`
  - IStage overrides: `getStageType()` → `KERNEL_STAGE`; `Kernel* getKernel()` → this.
  - **`void step(bool throttling, int numThreads, boost::uint64_t debugTime);`**
  - Registration: `insertBody/insertPoint/insertConnector`, `removeBody/removePoint/removeConnector`.
  - Points: `Point* newPointLocal(Body*, const Vector3& worldPos); Point* newPoint(Body*, worldPos); void deletePoint(Point*);` — header comment: "double up on points if same body, position.... TODO: move this to the point class - reference counted pointer".
  - Private stepping: `preStep()`, `preStepThrottled()`, `stepWorld(distDebugTime)`, `stepWorldThrottled(debugTime)`; Funny Physics trio `stepWorldFunnyPhysics(int worldStepId) / stepFunnyPhysics(const Vector3& move) / stepFunnyPhysicsBody(Body*, const Vector3&)`; validation `validateBody/validateConnector/validateConnectorBody`; `searchForDuplicatePoint(Point*)`; state `int maxBodies; bool inStepCode; int numLastIterations, numOfMaxIterations; float error, maxError; KernelData* kernelData; bool usingPGSSolver;`
  - Public member: **`PGSSolver pgsSolver;`**
  - Debug: `void report();` ("system energy to log file"), static `reportMemorySizes()`, energy queries `connectorSpringEnergy/bodyPotentialEnergy/bodyKineticEnergy/totalEnergy/totalKineticEnergy` (inline combos).
  - Counts: `numFreeFallBodies/numRealTimeBodies/numJointBodies/numContactBodies`, inline `numBodies()` (sum of the four), `numBodiesMax()`, `numLeafBodies/numPoints/numConnectors/numHumanoidConnectors/numRealTimeConnectors/numSecondPassConnectors/numJointConnectors/numBuoyancyConnectors/numContactConnectors`.
  - Solver telemetry: inline `numIterations()/numMaxIterations()/getSolverError()/getMaxSolverError()`; **`fakeDeceptiveSolverIterations()` / `fakeDeceptiveMatrixSize()`**.
  - Profiling: public `boost::scoped_ptr<Profiling::CodeProfiler> profilingKernelBodies/profilingKernelConnectors;`
  - Solver switch: `setUsingPGSSolver(bool)/getUsingPGSSolver()`, forwarding `dumpLog(bool)` to pgsSolver.

## Gotchas

- `pgsSolver` is public — external code can drive it directly; `usingPGSSolver` flag gates which solver path `step` takes (legacy vs PGS).
- The "FakeDeceptive*" names are intentional anti-tamper telemetry: they report plausible-looking but fake iteration counts/matrix sizes to clients probing solver internals.
- `inStepCode` guards re-entrant mutation; inserting/removing bodies during step likely asserts via validate helpers.
- numThreads parameter exists on step but threading policy is internal.
