# JointInstance.cpp

## Purpose

Implements the `JointInstance` ("JointInstance") family — Instance wrappers over V8World Joint objects: base class (Part0/Part1/C0/C1, world insert/remove on ancestor/co-parent change, spanning-tree debug rendering), `Snap`, `Weld`, `ManualSurfaceJointInstance` (non-creatable) with `ManualWeld`/`ManualGlue` (Surface0/1 + selected-face intersection rendering), `Glue` (F0..F3 face points), `Rotate`, `DynamicRotate` (BaseAngle) → `RotateP`/`RotateV`, and `Motor`/`Motor6D` (DesiredAngle/CurrentAngle/MaxVelocity animation plumbing).

## Key types and API

Descriptors:
- JointInstance: Part0 / Part1 (RefPropDescriptor→PartInstance, public statics) + hidden deprecated lowercase `part1`; C0/C1 (CoordinateFrame, delegate to joint->get/setJointCoord(0|1)).
- ManualSurfaceJointInstance: Surface0/Surface1 int props (STREAMING attribute) — getters return −1 for non-manual joint types.
- Glue: F0/F1/F2/F3 Vector3 face points via CREATE_GLUE_FACE macro.
- DynamicRotate: BaseAngle float.
- Motor: MaxVelocity, DesiredAngle, CurrentAngle (UI attribute); func SetDesiredAngle(value) Security::None — "Non replicating local function" that updates desiredAngle but only raises prop_CurrentAngle (local-only UI path).

Lifecycle: JointInstance owns the raw Joint* (ctor sets jointOwner + captures part shared_ptrs from primitives; dtor RBXASSERTs parent==NULL && world==NULL then deletes). askSetParent allows JointsService or PartInstance parents. computeWorld: parent==JointsService → workspace world; else getWorldIfInWorkspace. handleWorldChanged removes from oldWorld/inserts into newWorld, NULLing primitives whose PartInstance died ("need to check it explicitly" — no destruction notification outside world). writeXml omits the joint unless BOTH parts are in scope.

Rendering: render3dAdorn draws the spanning-tree line when PartInstance::showSpanningTree && isSpanningTreeJoint && inSpanningTree (or spring): cyan for normal joints, green/blue for springs; iOS/Android skip entirely via shouldRender3dAdorn (~2% frame cost comment). ManualWeld draws WHITE polygon = intersection of part1's surface-1 polygon projected into part0's surface-0 face; ManualGlue same in BROWN; both only when Selection has part0/part1/joint selected.

Motor/Motor6D: Motor wraps MOTOR_1D (maxVelocity/desiredAngle/currentAngle on MotorJoint), Motor6D wraps MOTOR_6D exposing only the Z axis (maxZAngleVelocity/desiredZAngle/getCurrentZAngle); setDesiredAngle debounces within 2 degrees and also raises CurrentAngle "only local"; setCurrentAngleUi is a command-style setter (not replicated/streamed — source comment). Both implement IAnimatableJoint: getParentName=Part0 name, getPartName=Part1 name, applyPose(CachedPose) (Motor6D includes translation), setIsAnimatedJoint flags Assembly::setAnimationControlled. AutoJoin constructors RBXASSERT(0) ("creating a motor by AutoJoin").

Constants: sJointInstance/sSnap/sWeld/sManualSurfaceJointInstance/sManualWeld/sManualGlue/sGlue/sRotate/sDynamicRotate/sRotateP/sRotateV/sMotor/sMotor6D; LOGGROUP JointInstanceLifetime.

## Usage / reflection touchpoints

Joints live under [JointsService](JointsService.md) or directly on [PartInstance](PartInstance.md)s; engine side V8World/{Glue,Weld,Snap,Rotate,Motor,Motor6D}Joint + Clump + Assembly; selection-aware adorn via Workspace Selection; animation system consumes IAnimatableJoint pose application ([AnimationController](AnimationController.md)/Animator era).

## Gotchas

- setDesiredAngle's 2° debounce silently swallows small scripted changes — callers must exceed 2 degrees to guarantee replication of the property raise.
- CurrentAngle is UI-attributed: setting it never replicates; reading reflects sim state.
- Deprecated `part1` lowercase alias retained for old saves/scripts (HIDDEN_SCRIPTING).
- Surface0/Surface1 are meaningless (−1) unless the underlying joint type is MANUAL_WELD/MANUAL_GLUE; setters silently no-op otherwise.
- handleWorldChanged explicitly NULLs primitives for dead parts — a joint whose parts died outside the world would otherwise insert with dangling primitives.
- Motor auto-join constructor asserts in dev (RBXASSERT(0)) — Motors are expected to be created explicitly, not by surface auto-joining.
- UNKNOWN: where Clump/assembly rebuild triggers on Part0 reassignment mid-simulation (V8World side).
