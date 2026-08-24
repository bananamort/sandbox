# JointsService.cpp

## Purpose

Implements `JointsService` ("JointsService") — the non-archivable service that mirrors engine joint lifecycle into Instances: auto-creates JointInstance wrappers (Snap/Weld/Glue/Rotate/RotateP/RotateV) when the V8World auto-joins parts, destroys their wrappers on auto-destroy, maintains network ownership across joint insert/remove topology changes, and implements the studio drag-to-join workflow (SetJoinAfterMoveInstance/Target → ShowPermissibleJoints → CreateJoinAfterMoveJoints) via ManualJointHelper. Carries a large comment block documenting the four joint lifetime paths (world-created, replication-created, world-destroyed, replication-destroyed) plus known spurious-event cases.

## Key types and API

Descriptors (all Security::None): `SetJoinAfterMoveInstance(joinInstance)`, `SetJoinAfterMoveTarget(joinTarget)` (both stored as PVInstance dynamic_casts), `ShowPermissibleJoints()`, `CreateJoinAfterMoveJoints()`, `ClearJoinAfterMoveJoints()`.

Flag: DFFlag::NetworkOwnershipRuleReplicates.

Behavior:
- ctor: Service(true), propArchivable=false.
- onServiceProvider: binds to Workspace's World — postInsertJointSignal/postRemoveJointSignal for ownership migration, autoJoinSignal/autoDestroySignal for wrapper create/destroy; grabs adornableCollector; onDescendantAdded/Removing registers IAdornable descendants with the collector (joint adorn rendering).
- onAutoJoin(joint): switches on JointType creating the matching DescribedCreatable wrapper around the EXISTING engine joint, parents under the service; default case asserts (Motor/Motor6D excluded by design — see [JointInstance](JointInstance.md) RBXASSERT(0)).
- onAutoDestroy(joint): setParent(NULL) on the wrapper via its IJointOwner; concurrency validator deliberately DISABLED with comment ("onAutoDestroy might be called as a result of setParent(NULL)... would think there's threading issue").
- Ownership migration on postInsertJoint: checkConsistentOwnerAndRuleResetRoots over combiRoots; grounded case sets owner/rule on the root moving primitive's PartInstance (skipping player character parts); unGroundedPrim case walks child assemblies that are moving roots under the ungrounded primitive. Under NetworkOwnershipRuleReplicates uses setNetworkOwnerNotifyIfServer(consistentAddress, hasConsistentManualOwnershipRule); legacy path setNetworkOwner + conditional setNetworkOwnershipRule(Manual) gated on serverIsPresent||flag.
- onPostRemoveJoint: fast path when both primitives have root-moving prims and prim0Roots non-empty — both sides inherit prim0Roots[0]'s owner/rule (player-character side forced back to Auto); else per-side consistent-owner reset. Comment explains doing it per-primitive because joints can connect a Primitive to a NON-primitive.

## Usage / reflection touchpoints

Parent of all reflected [JointInstance](JointInstance.md)s; World signals from [Workspace](Workspace.md); ManualJointHelper ([ManualJointHelper](ManualJointHelper.md)) drives studio manual joining; ownership APIs on PartInstance / NetworkOwnership.h.

## Gotchas

- Only 6 of the joint types get wrappers here — Motor/Motor6D/Manual* joints never appear under JointsService from auto-join (default: RBXASSERT).
- The whole file assumes JointsService exists as the wrapper parent; wrappers created by replication instead arrive through the serialization path documented in the lifetime comment (#2), not onAutoJoin.
- Player character parts are exempt from ownership inheritance but ARE force-reset to Auto on the split fast path.
- joinAfterMoveInstance/target are raw member shared_ptrs — SetJoinAfterMoveTarget alone without instance is silently ignored by Show/Create paths.
- UNKNOWN: who calls the five Lua funcs (studio drag tooling outside this TU); whether adornableCollector null-checks are guaranteed by Workspace attach order.
