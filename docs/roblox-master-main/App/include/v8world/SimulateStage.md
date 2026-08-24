# App/include/v8world/SimulateStage.h

## Purpose

Pipeline stage (`IStage::SIMULATE_STAGE`, "used to be called SimJobStage.h") that owns the intrusive lists of moving assemblies — dynamic and realtime buckets — and feeds the first/last moving roots in and out of SendPhysics for replication.

## Declared API

- `class SimulateStage : public IWorldStage`
  - `typedef boost::intrusive::list<Assembly, base_hook<SimulateStageHook>> Assemblies;` (hook lives on [Assembly.md](Assembly.md)).
  - Members: `AssemblyMap movingAssemblyRoots;` — `std::map<Assembly*, int>` chosen via `#if 0` over `boost::unordered_map`; `Assemblies movingDynamicAssemblies, realTimeAssemblies;`
  - `SimulateStage(IStage* upstream, World* world); ~SimulateStage();`
  - `/*override*/ getStageType() → IStage::SIMULATE_STAGE;`
  - Edge lifecycle: `onEdgeAdded(Edge*)` / `onEdgeRemoving(Edge*)` (+ private `validateEdge`).
  - Assembly lifecycle: `onAssemblyAdded(Assembly*)` / `onAssemblyRemoving(Assembly*)`.
  - SendPhysics coupling (private): `putFirstMovingRootInSendPhysics(Assembly*)`, `removeLastMovingRootFromSendPhysics(Assembly*)`, `removeFromSendPhysics(Assembly*)`.
  - Accessors: moving-dynamic size/begin/end iterators; realTime begin/end iterators.

## Gotchas

- The assembly map is a plain `std::map` by deliberate `#if 0` choice — an earlier unordered variant was disabled, so lookup cost is O(log n) by intent.
- Iterators expose live intrusive lists — mutation during iteration must go through stage APIs.

## Cross-links

- Pipeline terminal stages: [v8kernel/IStage.md](../v8kernel/IStage.md), [v8kernel/Kernel.md](../v8kernel/Kernel.md); replication: [SendPhysics.md](SendPhysics.md), [SimJob.md](SimJob.md); hook source: [Assembly.md](Assembly.md).
