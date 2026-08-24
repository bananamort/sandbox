# App/include/v8datamodel/Gyro.h

## Purpose

The BodyMover family — Instances that inject forces/torques into the physics kernel each step: abstract `BodyMover` (a KernelJoint), then `BodyGyro` (PD orientation hold), `BodyForce` (world-space constant force), `BodyThrust` (body-space force at offset), `BodyPosition` (PD position hold + reached event), `BodyVelocity`, `BodyAngularVelocity`, and `Rocket` (thrust + guided steering). Free function `registerBodyMovers()`.

## Declared API

`class BodyMover : public DescribedNonCreatable<BodyMover, Instance, sBodyMover>, public KernelJoint`

- Internal `computeForce(bool throttling, Body*& root, Vector3& force, Vector3& torque)`; Connector override `computeForce(bool throttling)`; Joint `canStepWorld() → true`; KernelJoint overrides `getEngineBody()`, `stepWorld()`, `putInKernel(Kernel*)`, `removeFromKernel()`; Instance `onAncestorChanged`.
- Subclass contract: pure virtual `computeForceImpl(bool throttling, Body* body, Body* root, Vector3& force, Vector3& torque)`.
- State: `World* world; weak_ptr<PartInstance> part; Vector3 lastWakeForce/lastWakeTorque;` virtual `bool duplicateBodyMoverExists(Primitive*, Primitive*)`.

`class BodyGyro : DescribedCreatable<..., BodyMover, sBodyGyro>` — props kP/kD BoundProps (comments: torque = kP·I·rotation, kD·I·rotVelocity), maxTorque + deprecated twin, cframe + deprecated twin; getters/setters getMaxTorque/setMaxTorque/getCFrame/setCFrame; private balance/orientation-torque computation, `ConstraintBodyAngularVelocity*`, MovingRegression instability detectors per axis, update()/stepWorld(), onPDChanged.

`class BodyForce : DescribedCreatable<..., sBodyForce>` — "constant force at COM (world coordinates)"; prop_Force (+Deprecated); get/setBodyForce(Vector3); duplicateBodyMoverExists → false.

`class BodyThrust : DescribedCreatable<..., sBodyThrust>` — "constant force in body coordinates" with location offset; props force/location (+deprecated twins); get/setForce/get/setLocation.

`class BodyPosition : DescribedCreatable<...> , public IStepped` — PD position hold: kP/kD (force = kP·mass·position etc.), maxForce(+dep), position(+dep); remote signal `reachedTargetSignal<void()>`; getLastForce/get/setMaxForce/get/setPosition; ConstraintLinearSpring*, firedEvent flag, stepped hookup, stepWorld.

`class BodyVelocity : DescribedCreatable<..., sBodyVelocity>` — kP ("TODO: should this be maxAccel?"), maxForce(+dep), velocity(+dep); getLastForce/get/setMaxForce/get/setVelocity; ConstraintLinearVelocity*.

`class BodyAngularVelocity : DescribedCreatable<..., sBodyAngularVelocity>` — kP, maxTorque(+dep), angularvelocity(+dep, lowercase verbatim member); getMaxTorque/set/getAngularVelocity/set; ConstraintLegacyAngularVelocity*.

`class Rocket : DescribedCreatable<..., sRocket>, public IStepped` — "Steers a part by rotating it and applying thrust along the Part's -z axis"; target RefProp + targetOffset/targetRadius; thrust knobs MaxThrust/ThrustP/ThrustD/MaxSpeed; turn knobs MaxTorque/TurnP/TurnD/CartoonFactor ("0 - realistic. 1 - cartoony"); funcs Fire/Abort (`fire()/abort()`); remote reachedTargetSignal; private prop_Active; onGoalChanged resets firedEvent; computeTorque helper.

## Gotchas

- Every mover keeps a *Deprecated* twin descriptor for its main vector/cframe props — old saves/scripts bind to those.
- BodyMover participates directly in physics stepping as a KernelJoint; duplicate-mover detection exists but several subclasses disable it (return false).
- Rocket fires events once per goal (`firedEvent`) reset on target change.
- PD gains are unit-scaled by mass/momentOfInertia — comments document the formulas.

## UNKNOWN

- Instability-detector response in BodyGyro (what triggers when regression flags instability — .cpp).

## Cross-links

- Implementation: [App/v8datamodel/Gyro.md](../../v8datamodel/Gyro.md).
- Physics kin: solver [Constraint.md](../../include/solver/Constraint.md), joints [JointInstance.md](JointInstance.md), [Feature.md](Feature.md) VelocityMotor.
