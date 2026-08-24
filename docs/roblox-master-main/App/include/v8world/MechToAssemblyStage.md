# App/include/v8world/MechToAssemblyStage.h

## Purpose

Pipeline stage (`IStage::MECH_TO_ASSEMBLY_STAGE`) relaying assembly-root add/remove notifications between mechanism-level tracking and the [AssemblyStage.md](AssemblyStage.md), split by fixed / simulate / no-simulate categories.

## Declared API

- `class MechToAssemblyStage : public IWorldStage`
  - `MechToAssemblyStage(IStage* upstream, World* world); ~MechToAssemblyStage();`
  - `/*override*/ IStage::StageType getStageType() const {return IStage::MECH_TO_ASSEMBLY_STAGE;}`
  - Notifications: `onFixedAssemblyAdded(Assembly*)` / `onFixedAssemblyRemoving`; `onSimulateAssemblyRootAdded/Removing`; `onNoSimulateAssemblyRootAdded/Removing`.
  - Private: `AssemblyStage* getAssemblyStage();`

## Gotchas

- Unlike [AssemblyStage.md](AssemblyStage.md) (which aliases no-simulate roots to fixed handlers), this stage keeps all three categories as distinct entry points.

## Cross-links

- Pipeline: [v8kernel/IStage.md](../v8kernel/IStage.md), [IWorldStage.md](IWorldStage.md); mechanisms: [Mechanism.md](Mechanism.md).
