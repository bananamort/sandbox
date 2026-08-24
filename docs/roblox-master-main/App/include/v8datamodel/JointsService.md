# App/include/v8datamodel/JointsService.h

## Purpose

`JointsService` (INTERNAL service) — the engine-side joint coordinator: listens to world joint insert/remove/auto-join/auto-destroy events, maintains assembly combiner bookkeeping, hosts the [ManualJointHelper](ManualJointHelper.md) for Studio manual joint creation, and manages the "join after move" workflow.

## Declared API

`class JointsService : public DescribedNonCreatable<JointsService, Instance, sJointsService, ClassDescriptor::INTERNAL>, public Service`

- Public member: `World* world;`
- Tree rules: only JointInstance children allowed (`askAddChild` fastDynamicCasts); overrides `onDescendantAdded/onDescendantRemoving`, `onServiceProvider`.
- World-event handlers: `onPostInsertJoint(Joint*, Primitive* unGroundedPrim, std::vector<Primitive*>& combiRoots)`, `onPostRemoveJoint(Joint*, prim0Roots, prim1Roots)`, `onAutoJoin(Joint*)`, `onAutoDestroy(Joint*)` — each backed by a scoped_connection.
- Join-after-move: `void setJoinAfterMoveInstance(shared_ptr<Instance>); void setJoinAfterMoveTarget(shared_ptr<Instance>); void showPermissibleJoints(void); void createJoinAfterMoveJoints(void); void clearJoinAfterMoveJoints(void);` state `joinAfterMoveInstance/joinAfterMoveTarget` (shared_ptr<PVInstance>).
- Members: `ConcurrencyValidator concurrencyValidator; boost::shared_ptr<IAdornableCollector> adornableCollector; ManualJointHelper manualJointHelper;`

## Gotchas

- Only joints may be parented here — the service is the canonical joint container.
- Manual-joint adornments flow through its IAdornableCollector.
- ConcurrencyValidator presence signals lock-discipline checks on joint mutation paths.

## UNKNOWN

- Combiner-root semantics in insert/remove handlers (.cpp — see [JointsService.md](../../v8datamodel/JointsService.md)).

## Cross-links

- Implementation: [App/v8datamodel/JointsService.md](../../v8datamodel/JointsService.md).
- Joints: [JointInstance.md](JointInstance.md), [ManualJointHelper.md](ManualJointHelper.md); world side v8world docs.
