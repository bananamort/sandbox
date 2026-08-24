# App/include/v8world/AssemblyStage.h

## Purpose

Pipeline stage (`IStage::ASSEMBLY_STAGE`) that maintains the set of assemblies as parts move between anchored (fixed), no-simulate, and simulate states. Derived from `EdgeBuffer`, so it inherits the edge-buffer bookkeeping machinery; the World notifies it of every assembly root/descendent transition and engine edits.

## Declared API

- `class AssemblyStage : public EdgeBuffer`
  - `AssemblyStage(IStage* upstream, World* world); ~AssemblyStage();`
  - `/*override*/ IStage::StageType getStageType() const { return IStage::ASSEMBLY_STAGE; }`
  - Fixed roots: `onFixedAssemblyRootAdded(Assembly*)` / `onFixedAssemblyRootRemoving(Assembly*)`.
  - No-simulate roots: `onNoSimulateAssemblyRootAdded/Removing(Assembly*)` — inline **forwards to the Fixed handlers**.
  - No-simulate descendents: `onNoSimulateAssemblyDescendentAdded/Removing(Assembly*)`.
  - Simulate: `onSimulateAssemblyRootAdded/Removing(Assembly*)`; `onSimulateAssemblyDescendentAdded/Removing(Assembly*)`.
  - Engine edits: `Assembly* onEngineChanging(Primitive* p);` / `void onEngineChanged(Assembly* a);`

## Gotchas

- `onNoSimulateAssembly{Root}{Added,Removing}` deliberately alias the fixed-root handlers — no-simulate assembly roots are treated exactly like fixed ones by this stage; only the *descendent* variants are distinct.
- All mutation entry points are notification-style callbacks from World/state transitions; calling them out of band will desync stage state.

## UNKNOWN

- What `onEngineChanging` returns in edge cases (presumably the owning Assembly to be re-pushed on `onEngineChanged`); implementation-only.

## Cross-links

- Pipeline base: [v8kernel/IStage.md](../v8kernel/IStage.md) (16-stage enum), [EdgeBuffer.md](EdgeBuffer.md), [IWorldStage.md](IWorldStage.md).
- Consumers of its output: [SimulateStage.md](SimulateStage.md), [v8kernel/Kernel.md](../v8kernel/Kernel.md).
