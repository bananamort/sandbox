# App/include/v8world/StepJointsStage.h

## Purpose

Pipeline stage (`IStage::STEP_JOINTS_STAGE`) that steps world-driven joints (e.g. dynamic rotate joints) once per physics step, tracking them in an intrusive list keyed off each Joint's `StepJointsStageHook`.

## Declared API

- `class StepJointsStage : public IWorldStage`
  - `typedef boost::intrusive::list<Joint, base_hook<StepJointsStageHook>> Joints;` member `Joints worldStepJoints;` (hook from [Joint.md](Joint.md)).
  - `StepJointsStage(IStage* upstream, World* world); ~StepJointsStage();`
  - `/*override*/ getStageType() → IStage::STEP_JOINTS_STAGE;`
  - `/*override*/ void onEdgeAdded(Edge*)` / `onEdgeRemoving(Edge*)` — maintains the list (private `addJoint/removeJoint`).
  - `void onSimulateAssemblyAdded(Assembly*)` / `onSimulateAssemblyRemoving(Assembly*)`.
  - `void jointsStepWorld();` — the per-step joint update pass.
  - Public profiler: `boost::scoped_ptr<Profiling::CodeProfiler> profilingJointUpdate;`

## Gotchas

- Which joints land in `worldStepJoints` is decided by the edge hooks (can-step-capable joints); see [DynamicRotateJoint](RotateJoint.md) (`canStepWorld → true`) as the primary registrant.

## Cross-links

- Pipeline: [v8kernel/IStage.md](../v8kernel/IStage.md), [IWorldStage.md](IWorldStage.md); UI-thread counterpart: [MovingAssemblyStage.md](MovingAssemblyStage.md) (`jointsStepUi`).
