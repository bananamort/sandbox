# App/include/v8world/MotorJoint.h

## Purpose

1-DOF hinge motor (`MOTOR_1D_JOINT`): drives a `RevoluteLink` between two primitives toward `desiredAngle` at `maxVelocity`, with a pose overlay system (angle delta + mask weight + freshness countdown) used by animation.

## Declared API

- `class MotorJoint : public Joint`
  - Members: private `RevoluteLink* link; float currentAngle; float poseAngleDelta; float poseMaskWeight; int poseFreshness;` public **`float maxVelocity; float desiredAngle;`**
  - `static const int poseDuration = 32;` — "tweak this to adjust how long a pose stays applied in the absence of a fresh call to applyPose()".
  - Angle: `getCurrentAngle()`, `bool setCurrentAngle(float)`, private `setJointAngle(float)`, `int getParentId() const`.
  - Pose: `void applyPose(float poseAngle, float poseWeight, float maskWeight);`
  - Queries/stepping: `CoordinateFrame getMeInOther(Primitive* me);` `isAligned()` override; `canStepUi() → true`; `bool stepUi(double distributedGameTime);`
  - `size_t hashCode() const;` `Link* resetLink()` override.
  - `static bool isMotorJoint(const Edge* e);` (checks MOTOR_1D_JOINT).
- Joint overrides: `getJointType() → MOTOR_1D_JOINT`, `isBroken() → false` (motors never "break").

## Gotchas

- Two names collide: `MotorJoint::isMotorJoint` static vs [Joint.md](Joint.md)'s generic `Joint::isMotorJoint` (which covers both motor types).
- Pose state expires after `poseDuration` UI steps without re-application — stale poses silently decay rather than persist.

## Cross-links

- Kernel link: [v8kernel/Link.md](../v8kernel/Link.md) (RevoluteLink); base: [Joint.md](Joint.md); stepping stage: [MovingAssemblyStage.md](MovingAssemblyStage.md), [StepJointsStage.md](StepJointsStage.md). 6-DOF sibling: [Motor6DJoint.md](Motor6DJoint.md).
