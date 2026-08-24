# App/include/v8world/GroundStage.h

## Purpose

Pipeline stage (`IStage::GROUND_STAGE`) implementing anchoring: maintains implicit ground joints for primitives that are fixed (`requestFixed`) or rigidly connected to fixed primitives, choosing the *heaviest* rigid path to ground when several exist.

## Declared API

- `class GroundStage : public IWorldStage`
  - `GroundStage(IStage* upstream, World* world); ~GroundStage();`
  - `/*override*/ IStage::StageType getStageType() const {return IStage::GROUND_STAGE;}`
  - Primitive lifecycle: `onPrimitiveAdded(Primitive*)`, `onPrimitiveRemoving(Primitive*)`.
  - Anchored edits: `onPrimitiveFixedChanging(Primitive*)`, `onPrimitiveFixedChanged(Primitive*)`.
  - Edge lifecycle: `/*override*/ onEdgeAdded(Edge*)`, `onEdgeRemoving(Edge*)` — re-evaluates grounding when rigid joints appear/disappear.
  - Private machinery: `kernelJointHere(Primitive*)`, `addGroundJoint(Primitive*, bool grounded)` / `removeGroundJoint`, `onKernelJointAdded/Removing(KernelJoint*)`, `checkForFreeGroundJoint(RigidJoint*)`, `rebuildFreeGround(Primitive*)`, `rebuildOthers(Primitive* changedP)`, `RigidJoint* heaviestRigidToGround(Primitive*)`.

## Gotchas

- Ground joints are synthesized here — they don't correspond to user-created joints; expect them to appear/disappear as anchoring and weld topology change.
- "Heaviest" selection means which primitive owns the ground connection can change without any direct edit to it.

## Cross-links

- Pipeline: [v8kernel/IStage.md](../v8kernel/IStage.md), [IWorldStage.md](IWorldStage.md); joints: [RigidJoint.md](RigidJoint.md), [KernelJoint.md](KernelJoint.md).
- Assembly grounding queries: [Assembly.md](Assembly.md) `computeIsGrounded/computeIsGroundingPrimitive`.
