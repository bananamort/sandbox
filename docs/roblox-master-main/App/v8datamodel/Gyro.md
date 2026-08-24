# Gyro.cpp

## Purpose

Implements the entire legacy `BodyMover` family in one TU: base `BodyMover` ("BodyMover", kernel-joint lifecycle, force accumulation, wake tickling, duplicate detection) plus DescribedCreatable subclasses `BodyGyro` ("BodyGyro"), `BodyPosition` ("BodyPosition"), `BodyVelocity` ("BodyVelocity"), `BodyAngularVelocity` ("BodyAngularVelocity"), `BodyForce` ("BodyForce"), `BodyThrust` ("BodyThrust"), and `Rocket` ("RocketPropulsion"). Each computes PD/P-controller force/torque against the assembly (branch) body each physics step, with dual code paths for the PGS solver including constraint-based variants behind FFlag::PGSUsesConstraintBasedBodyMovers.

## Key types and API

Registration: RBX_REGISTER_CLASS ×7 + registerBodyMovers() forcing className() static init. Flags: DFFlag::PGSWakePrimitivesWithBodyMoverPropertyChanges(false), FFlag::PGSUsesConstraintBasedBodyMovers(false); constant PGSSolverSpringConstantScale = 1/19.

### BodyMover (base)
- askSetParent: only PartInstance parents. onAncestorChanged re-binds `part`, inserts/removes itself as a Joint into World with primitive(0)=part primitive, primitive(1)=groundPrimitive; skips insert when duplicateBodyMoverExists (same-typed joint already between the pair).
- computeForce(throttling) → accumulateForceAtBranchCofm/accumulateTorque on root Body; stepWorld wakes the primitive only when force/torque changed >5% (different5percent/fuzzyEq 0.05).

### Rocket — RocketPropulsion
- Props "Goals": Target (Ref→PartInstance; setter resets firedEvent), TargetOffset (Vector3), TargetRadius(float, default 4), CartoonFactor(0.7). "Thrust": MaxSpeed(30), MaxThrust(4e3), ThrustP(5), ThrustD(0.001). "Turn": TurnP(3000), TurnD(500), MaxTorque(4e5,4e5,0). "Internal": Active (REPLICATE_ONLY BoundProp).
- Funcs Security::None: Fire()/Abort() (set Active true/false), deprecated lowercase `fire`. Event ReachedTarget (SCRIPTING|BROADCAST) fired once from onStepped when within TargetRadius.
- computeForceImpl: PGS path anti-forces then saturates remaining thrust toward target with quadratic drag to cap speed at clampedMaxSpeed∈[1,10000]; legacy path P-accel×branchMass, speed-cap braking along travel direction, D term, minus branch forces. Torque turns rocket to cartoonFactor-blend of target dir vs thrust dir; computeTorque is X/Y-axis PD with maxTorque saturation vs existing branch torque; PGS scales kP/kD by 1/19.

### BodyGyro
- Props "Goals": P(3000)/D(500) BoundProps (onPDChanged), MaxTorque Vector3 (default (4e5,0,4e5)) + deprecated `maxTorque`, CFrame CoordinateFrame + deprecated `cframe`.
- computeBalanceTorque (X/Z alignment of cframe up-vector; skipped if maxTorque.x,z ≈0) + computeOrientationTorque (Y alignment to lookVector; skipped if maxTorque.y≈0). PGS+constraint path uses correctPDValuesForTimeStep stability clamp (30°/step underdamped, threshold 0.8 overdamped — full derivation in comments) plus instabilityDetector X/Y/Z fitness dampers (exp(-2·t)); else torque-difference saturation logic identical to Rocket::computeTorque. Constraint variant drives ConstraintBodyAngularVelocity with per-axis actualMaxTorque=branchIBody∘maxTorque.

### BodyPosition
- Props "Goals": P(1e4)/D(1250), MaxForce Vector3 (4000³)+deprecated `maxForce`, Position Vector3 (default (0,50,0))+deprecated `position`. Funcs GetLastForce()->Vector3 + deprecated `lastForce` (Security::None, debug). Event ReachedTarget (BROADCAST) once within fixed radius 0.1 (BODY_POSITION_TARGET_RADIUS); Position setter resets firedEvent.
- Legacy force: branchMass×(kP·Δpos − kD·vel) clamped ±MaxForce. Constraint variant configures ConstraintLinearSpring pivots from root sim-body position each step.

### BodyVelocity
- Props "Goals": P(1250) BoundProp (onPChanged), MaxForce(4000³)+deprecated, Velocity(default (0,2,0))+deprecated `velocity`. GetLastForce + deprecated `lastForce` (Security::None).
- Legacy force: branchMass×kP×(velocity − branchVelocity.linear) clamped ±MaxForce (accumulated at branch CoFM to avoid torque). Constraint: ConstraintLinearVelocity setDesiredVelocity/setMaxForce.

### BodyAngularVelocity
- Props "Goals": P(1250), MaxTorque Vector3 (4000³)+deprecated `maxTorque`, AngularVelocity(default (0,2,0)) + deprecated all-lowercase `angularvelocity`. Note NO D property.
- Legacy torque: branchMass×kP×(angularvelocity − rotational velocity) clamped. Constraint: ConstraintLegacyAngularVelocity with setUseIntegratedVelocities(true).

### BodyForce / BodyThrust
- BodyForce: prop Force Vector3 (default unitY) + deprecated `force`; force = value verbatim (world space).
- BodyThrust: Force+`force`, Location+`location` (default zero); force rotated into body space (vectorToWorldSpace), torque = SimBody::computeTorqueFromOffsetForce at world application point vs branch CoFM.

## Usage / reflection touchpoints

Attached as children of [PartInstance](PartInstance.md)s ([Workspace](Workspace.md) world insertion via KernelJoint pipeline); constants from V8Kernel/Constants.h; solver constraints live in pgsSolver; reachedTargetSignal consumed by scripts; [JointsService](JointsService.md)-era architecture sibling.

## Gotchas

- Deprecated lowercase props (`maxTorque`,`cframe`,`maxForce`,`position`,`velocity`,`angularvelocity`) are full aliases — scripts may write either; only canonical names raise visible descriptors.
- BodyGyro default MaxTorque zeroes Y — a fresh BodyGyro does NOT orient yaw, only levels roll/pitch.
- BodyPosition ReachedTarget fires ONCE until Position changes (firedEvent latch); BodyVelocity/BodyAngularVelocity have no such event.
- kP/kD are BoundProp with change callbacks but ONLY tickle the primitive when PGSWakePrimitivesWithBodyMover flag is on AND PGS active — otherwise legacy loop picks changes up via the 5% stepWorld heuristic; Force/Location setters never tickle at all.
- duplicateBodyMoverExists compares typeid(*joint)==typeid(*this): two DIFFERENT mover types can both bind one part; two same-type cannot (second silently never enters kernel).
- Rocket PGS drag model caps effective speed at min(maxSpeed,10000) regardless of thrust; legacy model brakes instead.
- UNKNOWN: ConstraintLinearSpring pivot math correctness for moving roots (formula inlined at :867–868, no comment).
