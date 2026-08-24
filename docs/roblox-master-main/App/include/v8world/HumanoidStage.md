# App/include/v8world/HumanoidStage.h

## Purpose

Pipeline stage (`IStage::HUMANOID_STAGE`) that tracks assemblies currently animated as humanoids, maintaining the set of *moving* humanoid assemblies so downstream simulation can treat them specially (humanoid vs dynamics state transitions).

## Declared API

- `class HumanoidStage : public IWorldStage`
  - `HumanoidStage(IStage* upstream, World* world); ~HumanoidStage();`
  - `/*override*/ IStage::StageType getStageType() const {return IStage::HUMANOID_STAGE;}`
  - `void onAssemblyAdded(Assembly* assembly);` / `onAssemblyRemoving(Assembly*)`.
  - `const std::set<Assembly*>& getMovingHumanoidAssemblies();`
  - Private state machine: `toDynamics(Assembly*)`, `toHumanoid(Assembly*)`, `fromDynamics(Assembly*)`, `fromHumanoid(Assembly*)`; member `std::set<Assembly*> movingHumanoidAssemblies`.

## Gotchas

- The exposed set is a live reference — iterate without mutating; mutation happens via stage callbacks only.
- Which assemblies qualify as "humanoid" is decided by callers of the to/from transitions (implementation-side), not by anything in this header.

## UNKNOWN

- Trigger conditions for `toDynamics`/`toHumanoid` (implementation-only; presumably humanoid state changes from the datamodel side).

## Cross-links

- Pipeline: [v8kernel/IStage.md](../v8kernel/IStage.md), [IWorldStage.md](IWorldStage.md); assemblies: [Assembly.md](Assembly.md) (`networkHumanoidState`).
