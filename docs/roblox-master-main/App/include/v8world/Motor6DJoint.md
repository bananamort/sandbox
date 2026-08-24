# App/include/v8world/Motor6DJoint.h

## Purpose

6-DOF motor (`MOTOR_6D_JOINT`) over a `D6Link`: animatable offset + axis-angle rotation between two primitives, with pose overlay (offset delta, axis-angle delta, mask weight, freshness) — the joint behind Animator-driven R6/R15-style part motion.

## Declared API

- `class Motor6DJoint : public Joint`
  - Members: private `D6Link* link; Vector3 poseOffsetDelta; Vector3 poseAxisAngleDelta; float poseMaskWeight; int poseFreshness; Vector3 currentOffset; Vector3 currentAxisAngle;` public **`float maxZAngleVelocity;`** and **`float desiredZAngle;`** — both commented "for support of legacy animate scripts".
  - Z-angle legacy path: `getCurrentZAngle()`, `setCurrentZAngle(float)`.
  - Full state: `Vector3 getCurrentOffset() const;` `Vector3 getCurrentAngle() const` (returns axis angles); `bool setCurrentOffsetAngle(const Vector3 offset, const Vector3 axisAngle);`
  - Pose: `void applyPose(const Vector3& poseOffset, const Vector3& poseAxisAngle, float poseWeight, float maskWeight);`
  - Queries/stepping: `CoordinateFrame getMeInOther(Primitive* me);` `isAligned()` override; `canStepUi() → true`; `bool stepUi(double distributedGameTime);` private `setJointOffsetCFrame`, `getParentId`.
  - `size_t hashCode() const;` `Link* resetLink()` override.
  - `static bool isMotor6DJoint(const Edge* e);`
- Joint overrides: `getJointType() → MOTOR_6D_JOINT`, `isBroken() → false`.

## Gotchas

- Rotation is stored as axis-angle `Vector3`, not quaternion/Euler — conversions happen in the D6 link.
- `maxZAngleVelocity/desiredZAngle` exist purely for old animate scripts; new code should drive via `setCurrentOffsetAngle`/poses.

## Cross-links

- Kernel link: [v8kernel/Link.md](../v8kernel/Link.md) (D6Link); base: [Joint.md](Joint.md); sibling: [MotorJoint.md](MotorJoint.md); stepping: [MovingAssemblyStage.md](MovingAssemblyStage.md).
