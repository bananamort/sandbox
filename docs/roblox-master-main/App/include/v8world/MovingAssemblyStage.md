# App/include/v8world/MovingAssemblyStage.h

## Purpose

Pipeline stage (`IStage::MOVING_ASSEMBLY_STAGE`) that steps *animated* joints (motors) on the UI thread and tracks the sets of moving grounded / moving animated assemblies for the simulation loop.

## Declared API

- `class MovingAssemblyStage : public IWorldStage`
  - Containers: `boost::intrusive::list<Joint, base_hook<MovingAssemblyStageHook>> uiStepJoints;` (Joints hook from [Joint.md](Joint.md)), `boost::unordered_set<Joint*> animatedJoints;` `std::set<Assembly*> movingGroundedAssemblies, movingAnimatedAssemblies;`
  - `MovingAssemblyStage(IStage* upstream, World* world); ~MovingAssemblyStage();`
  - `/*override*/ getStageType() → IStage::MOVING_ASSEMBLY_STAGE;`
  - Edge lifecycle: `onEdgeAdded(Edge*)` / `onEdgeRemoving(Edge*)` — maintains `uiStepJoints`.
  - Animation registry: `addAnimatedJoint(Joint*)` / `removeAnimatedJoint(Joint*)`; stepping: `void jointsStepUi(double distributedGameTime);` private `jointsStepUiInternal(double, Joint*, bool fromAnimation)`.
  - Assembly registry: `onSimulateAssemblyAdded/Removing(Assembly*)`; `add/removeMovingGroundedAssembly`, `add/removeMovingAnimatedAssembly`.
  - Accessors: `getMovingGroundedAssembliesSize()`, begin/end iterators, const refs to both assembly sets.

## Gotchas

- A joint can be in `uiStepJoints` without being in `animatedJoints` — the intrusive list holds all step-capable joints; the unordered_set marks which are animation-driven (`fromAnimation` flag in internal step).
- Exposed mutable-set accessors (`getMovingGroundedAssembliesBegin` etc.) allow external iteration with mutation risk.

## Cross-links

- Pipeline: [v8kernel/IStage.md](../v8kernel/IStage.md), [IWorldStage.md](IWorldStage.md); joints stepped here: [MotorJoint.md](MotorJoint.md), [Motor6DJoint.md](Motor6DJoint.md); assemblies: [Assembly.md](Assembly.md).
