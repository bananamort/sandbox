# App/include/v8world/IWorldStage.h

## Purpose

World-side stage base: extends [v8kernel/IStage.md](../v8kernel/IStage.md) with a back-pointer to the owning `World`, typed upstream/downstream casts, edge-notification defaults, and a metrics pass-through.

## Declared API

- `class RBXBaseClass IWorldStage : public IStage`
  - `typedef enum { NUM_CONTACTSTAGE_CONTACTS, NUM_STEPPING_CONTACTS, NUM_TOUCHING_CONTACTS, MAX_TREE_DEPTH } MetricType;`
  - `IWorldStage(IStage* upstream, IStage* downstream, World* world);`
  - `IWorldStage* getUpstreamWS();` / `getDownstreamWS()` ×2 — unchecked `rbx_static_cast`s.
  - `World* getWorld();`
  - Virtuals: `void onEdgeAdded(Edge*)` / `onEdgeRemoving(Edge*)`; `int getMetric(MetricType)` — recurses downstream (asserts downstream exists), so the last stage implements the counters.

## Gotchas

- `getUpstreamWS/getDownstreamWS` assume every neighbor is an IWorldStage — mixing plain kernel stages into a world pipeline breaks these casts silently.
- `getMetric` default implementation walks downstream without null guard beyond an assert.

## Cross-links

- Enum ordering & ownership rules: [v8kernel/IStage.md](../v8kernel/IStage.md) (dtor deletes downstream chain).
- Concrete stages: [CleanStage.md](CleanStage.md), [JointStage.md](JointStage.md), [GroundStage.md](GroundStage.md), [EdgeStage.md](EdgeStage.md), [ContactStage.md](ContactStage.md), [TreeStage.md](TreeStage.md), [MovingStage.md](MovingStage.md), [MechToAssemblyStage.md](MechToAssemblyStage.md), [AssemblyStage.md](AssemblyStage.md), [MovingAssemblyStage.md](MovingAssemblyStage.md), [StepJointsStage.md](StepJointsStage.md), [HumanoidStage.md](HumanoidStage.md), [SleepStage.md](SleepStage.md), [SimulateStage.md](SimulateStage.md).
