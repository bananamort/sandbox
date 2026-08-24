# App/include/v8world/Assembly.h

## Purpose

An `Assembly` is the physics unit of simulation: a maximal cluster of rigidly-connected `Primitive`s rooted at one "assembly root" primitive. It rides the world tree as an `IPipelined` node, carries per-stage scratch state (spatial-filter phase, sim-job slot, sleep bookkeeping), aggregates external edges/motors, and serializes motor angles + PV for networking.

## Declared API

- `class Assembly : public IPipelined, public boost::noncopyable, public IndexedMesh, public SimulateStageHook`
  - `SimulateStageHook` = `boost::intrusive::list_base_hook<tag<SimulateStage>>` — Assemblies link into the SimulateStage's intrusive list.
  - `typedef enum { Sim_SendIfSim, Sim_BufferZone, NoSim_Send, NoSim_SendIfSim, NoSim_Send_Anim, NoSim_SendIfSim_Anim, NUM_PHASES, Fixed, NOT_ASSIGNED } FilterPhase;` — SpatialFilter phases; `Fixed`/`NOT_ASSIGNED` sit **after** `NUM_PHASES`.
  - `Assembly(); ~Assembly();`
  - `Primitive* getAssemblyPrimitive();` / const overload — root primitive of this assembly.
  - `static Assembly* getPrimitiveAssembly(Primitive* p);` / `getConstPrimitiveAssembly`; `static Assembly* getPrimitiveAssemblyFast(Primitive* p);` — no null check, primitive must already have an assembly.
  - `static bool isAssemblyRootPrimitive(const Primitive* p);`
  - `Assembly* otherAssembly(Edge* edge);` / const — assembly on the far side of an edge.
  - `bool getCanThrottle() const;` `static bool computeCanThrottle(Edge* edge);`
  - `Vector2 get2dPosition() const;`
  - `static bool computeIsGroundingPrimitive(const Primitive* p);` — anchored (`requestFixed`) or rigid-jointed to a fixed primitive.
  - `bool computeIsGrounded() const;`
  - `void notifyMovedFromInternalPhysics();` / `notifyMovedFromExternal();`
  - SpatialFilter: `FilterPhase getFilterPhase()/setFilterPhase(FilterPhase)`.
  - SimJob: `setSimJob(SimJob*)/getSimJob()/getConstSimJob()`.
  - SleepStage: `reset(Sim::AssemblyState)` (resets state, sleep count, running average), `sampleAndNotMoving()`, `preventNeighborSleep()`, `wakeUp()`; `getAssemblyState()/setAssemblyState(Sim::AssemblyState)`; `getAssemblyIsMovingState()` via `Sim::isMovingAssemblyState`.
  - Recursion helpers: `setRecursivePassId(int)/getRecursivePassId()`, `setRecursiveDepth(int)/getRecursiveDepth()`.
  - Radius cache: `float computeMaxRadius()` (ComputeProp — farthest point over primitives, feeds max-velocity math), `getLastComputedRadius()`, `isComputedRadiusDirty()`.
  - Replication: `unsigned char getNetworkHumanoidState()/setNetworkHumanoidState(unsigned char)` — "replicated attributes (essentially used as Humanoid State)".
  - `const G3D::Array<Edge*>& getAssemblyEdges();` — external edges gathered via `onLowersChanged`.
  - Physics IO: `void setPhysics(const G3D::Array<CompactCFrame>& motorAngles, const PV& pv);` `void getPhysics(G3D::Array<CompactCFrame>& motorAngles) const;`
  - Templates: `visitAssemblies(Func)`, `visitDescendentAssemblies(Func)`, `visitConstDescendentAssemblies(Func)`, `visitPrimitives(Func)`, `findFirstPrimitive(Func)` — primitive walk stops descending at any child that is itself an assembly root (stays inside this assembly).

## Gotchas

- Non-copyable by design; identity semantics throughout the pipeline.
- `visitPrimitivesImpl` recurses into `p->numChildren()` without depth guard — deep primitive trees recurse on the stack.
- `getPrimitiveAssemblyFast` skips the safety checks of `getPrimitiveAssembly`; caller must guarantee assembly membership.
- `filterPhase`, `simJob`, `recursivePassId/Depth` are stage-owned scratch space reused across passes — stale values between stages are expected, not bugs.
- `history` (`AssemblyHistory*`) is managed internally (created/cleared around reset); lifetime details live in the .cpp (not in this drop).

## UNKNOWN

- Concrete sleep thresholds and Average buffer sizing (see [AssemblyHistory.md](AssemblyHistory.md) — constants resolved in .cpp).
- Exact behavior of `notifyMovedFromInternalPhysics` vs `notifyMovedFromExternal` (implementation-only).

## Cross-links

- Kernel-side integration of assemblies: [v8kernel/SimBody.md](../v8kernel/SimBody.md), [v8kernel/Kernel.md](../v8kernel/Kernel.md).
- Pipeline placement: [IPipelined.md](IPipelined.md), [IWorldStage.md](IWorldStage.md), [SimulateStage.md](SimulateStage.md), [SleepStage.md](SleepStage.md), [SpatialFilter.md](SpatialFilter.md), [SimJob.md](SimJob.md).
