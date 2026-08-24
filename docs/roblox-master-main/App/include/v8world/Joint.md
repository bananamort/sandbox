# App/include/v8world/Joint.h

## Purpose

The `Edge` subtype binding two primitives (or one, for anchor/free) with a placement relationship. Defines the full `JointType` taxonomy in *precedence order*, a large family of static classification/auto-join predicates, and the spanning-tree participation used to pick assembly roots. Also defines trivial `AnchorJoint`/`FreeJoint`.

## Declared API

- `class RBXInterface IJointOwner { virtual Joint* getJoint(void) /*asserts*/; }`
- Intrusive hooks: `StepJointsStageHook`, `MovingAssemblyStageHook` (in-header TODO: "Can we share the same hooks?").
- `class Joint : public Edge, public SpanningEdge, public StepJointsStageHook, public MovingAssemblyStageHook`
  - `typedef enum { ANCHOR_JOINT, WELD_JOINT, MANUAL_WELD_JOINT, SNAP_JOINT, MOTOR_1D_JOINT, MOTOR_6D_JOINT, ROTATE_JOINT, ROTATE_P_JOINT, ROTATE_V_JOINT, GLUE_JOINT, MANUAL_GLUE_JOINT, FREE_JOINT, KERNEL_JOINT, NO_JOINT } JointType;` — in-header matrix maps each type to GROUND / KINEMATIC / SPRING / KERNEL columns ("In precedence order - greatest to least").
  - Coords: protected `jointCoord0/jointCoord1` ("this coord is aligned with Coord0, so it points into the body"); `setJointCoord(int, const CoordinateFrame&)`, `getJointCoord(int)`, `CoordinateFrame getJointWorldCoord(int)`.
  - `void notifyMoved();` owner: `setJointOwner(IJointOwner*)/getJointOwner()`.
  - Edge override: `getEdgeType() → JOINT`; `setPrimitive(int, Primitive*)`.
  - Virtuals: `getJointType()` (base asserts, returns NO_JOINT), `isBreakable/isBroken` (false), `joinsFace(Primitive*, NormalId)` (false), `isAligned()` (true), `align(pMove, pStay)` (asserts), `setPhysics()` no-op ("occurs after networking read"), `canStepWorld/canStepUi` (false), `stepWorld()`, `bool stepUi(double distributedGameTime)`, `Link* resetLink()` (asserts "Not Implemented").
  - Static classifiers (all take `const Edge*` unless noted):
    - `isJoint`; `getJointType(const Edge*) → NO_JOINT` if not a joint.
    - `isGroundJoint` = FREE ∪ ANCHOR ("alternately, created by AutoJoin"); `isRigidJoint` = WELD ∪ SNAP ∪ MANUAL_WELD; `isKinematicJoint` = enum range [WELD..MOTOR_6D]; `isSpringJoint` = [ROTATE..GLUE] ∪ MANUAL_GLUE; `isMotorJoint` = [MOTOR_1D..MOTOR_6D]; `isKernelJoint`; `isManualJoint` = MANUAL_WELD ∪ MANUAL_GLUE; `isSpanningTreeJoint` = kinematic ∪ spring ∪ ground; `isAutoJoint(const Joint*)` = not ground/kernel/manual.
  - Lookup: `static Joint* getJoint(Primitive*, JointType)` / const / `findConstJoint`.
  - `NormalId getNormalId(int i)` — side 0 = `Matrix3ToNormalId(jointCoord0.rotation)`, side 1 = **opposite** of that of coord1.
  - Face-compat helpers (static): `canBuildJointLoose/Tight(p0,p1,nId0,nId1)` (public), private `canBuildJoint(..., float angleMax, float planarMax)`, plus `FacesOverlapped/FaceVerticesOverlapped/FaceEdgesOverlapped` (`adjustPartTolerance` defaulting to 1.0 on FacesOverlapped), `findTouchingSurfacesConvex`, `compatibleForGlue/Weld/Hinge/StudAutoJoint`, `inCompatibleForAnyJoint`, `positionedForStudAutoJoint`, `getSurfaceTypeFromNormal(primitive, normalId)`.
  - SpanningEdge impl (private): `isHeavierThan`, `otherNode/otherConstNode`, `getNode/getConstNode`.
- `class AnchorJoint : public Joint` — ctor `(Primitive* prim)` with NULL second primitive; `isAnchorJoint(const Joint*)`.
- `class FreeJoint : public Joint` — same shape; `isFreeJoint`.

## Gotchas

- The classifier ranges depend on **enum order** — inserting a new JointType mid-list silently reclassifies neighbors (e.g. `isSpringJoint` uses [ROTATE..GLUE] range arithmetic).
- `getNormalId` on side 1 returns the *opposite* face — callers comparing both sides must account for this asymmetry.
- Anchor/Free joints have a NULL second primitive — any code calling `otherPrimitive` on them must handle NULL ([Edge.md](Edge.md) accessors don't).
- Base `align()` and `resetLink()` assert — only some joint types support them.

## UNKNOWN

- Exact loose/tight angle & planar tolerances (private `canBuildJoint` params resolved at call sites/.cpp).

## Cross-links

- Subtypes: [WeldJoint.md](WeldJoint.md), [SnapJoint.md](SnapJoint.md), [GlueJoint.md](GlueJoint.md), [RotateJoint.md](RotateJoint.md), [MotorJoint.md](MotorJoint.md), [Motor6DJoint.md](Motor6DJoint.md), [MultiJoint.md](MultiJoint.md), [KernelJoint.md](KernelJoint.md), [RigidJoint.md](RigidJoint.md).
- Kernel-side link machinery: [v8kernel/Link.md](../v8kernel/Link.md), [v8kernel/Connector.md](../v8kernel/Connector.md). Stage: [JointStage.md](JointStage.md).
