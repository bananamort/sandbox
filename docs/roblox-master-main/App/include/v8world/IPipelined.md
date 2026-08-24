# App/include/v8world/IPipelined.h

## Purpose

Mixin giving Primitives/Assemblies/Edges pipeline membership: tracks which `IStage` currently owns the object, supports stage-by-stage insertion/removal, kernel entry/exit hooks, and stage-order queries (enum-comparison based).

## Declared API

- `class RBXBaseClass IPipelined`
  - Member: `IStage* currentStage;` — NULL when outside the pipeline.
  - `IPipelined();` virtual dtor asserts `currentStage == NULL` then stamps `Debugable::badMemory()`.
  - Membership: `void putInPipeline(IStage*)`, `removeFromPipeline(IStage*)`, `putInStage(IStage*)`, `removeFromStage(IStage*)`; private `removeFromStage(StageType)`, `getStage(StageType)` (walks downstream).
  - Queries: `bool inPipeline()`, `const IStage* getCurrentStage()`, `inStage(StageType)` / `inStage(IStage*)`, `inOrDownstreamOfStage(...)` ×2 (**`>=` enum compare**), `downstreamOfStage(IStage*)` (`>`), `bool inKernel()` = inStage(KERNEL_STAGE), `Kernel* getKernel() const` ("should never fail").
  - Kernel hooks: `virtual void putInKernel(Kernel*)`, `virtual void removeFromKernel();`
  - `World* findWorld()` — from current stage, or upstream of KERNEL_STAGE; unchecked `rbx_static_cast<IWorldStage*>`.

## Gotchas

- Stage-order comparisons rely on the [v8kernel/IStage.md](../v8kernel/IStage.md) enum ordering — renumbering stages silently changes `inOrDownstreamOfStage` semantics everywhere.
- Dtor while still in the pipeline is an asserted programming error.
- `findWorld()` on an object in KERNEL_STAGE casts its *upstream* to IWorldStage — valid only because every world pipeline ends in a Kernel whose upstream is an IWorldStage.

## Cross-links

- Stages: [IWorldStage.md](IWorldStage.md), [v8kernel/IStage.md](../v8kernel/IStage.md); users: [Assembly.md](Assembly.md), [Edge.md](Edge.md); terminal: [v8kernel/Kernel.md](../v8kernel/Kernel.md).
