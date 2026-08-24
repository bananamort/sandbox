# App/humanoid/MovingNoPhysicsBase.cpp

## Purpose

Implements `HUMAN::MovingNoPhysicsBase`, the kinematic (no-physics-force) movement base for RunningNoPhysics and StrafingNoPhysics. The state swaps the torso primitive between the dynamics and humanoid engines on entry/exit, integrates the torso CFrame directly from desired walk velocity each simulator step, redirects movement downhill on steep floors, and pushes half-weight gravity impulses into whatever floor is beneath so platforms still react to a kinematic character.

## API

Real definitions:

- DFFlags referenced: HumanoidFloorPVUpdateSignal, HumanoidFeetIsPlastic, UseTerrainCustomPhysicalProperties; LOGGROUP HumanoidFloorProcess.
- `const char* const sMovingNoPhysicsBase = "MovingNoPhysicsBase"`; file comment: "this state object only exists if the humanoid is in the Workspace chain".
- `MovingNoPhysicsBase::MovingNoPhysicsBase(Humanoid*, StateType)` — captures `torsoPart` (slow torso), asserts it is DYNAMICS_ENGINE, flips engine type to `Primitive::HUMANOID_ENGINE`, connects `ancestryChangedSignal` → `onEvent_TorsoAncestryChanged`.
- `~MovingNoPhysicsBase()` — `disconnectTorso()` then asserts torsoPart released; `onEvent_TorsoAncestryChanged()` — disconnectTorso; `disconnectTorso()` — disconnect signal, flip engine back to DYNAMICS_ENGINE, reset shared_ptr.
- `void MovingNoPhysicsBase::onComputeForceImpl()` — debug-only asserts ("should never be called!" — humanoid is always in kernel).
- `const Assembly* getAssemblyConst() const` — via slow torso primitive.
- `void applyImpulseToFloor(float dt)` — mass = min(character branch, floor branch); force = mass × kms gravity × dt × 0.5f ("for now, reduce this"); accumulates upward linear impulse at floor touch point; also `reportTouch(torso)` on the floor part.
- `void MovingNoPhysicsBase::onSimulatorStepImpl(float stepDt)` — only when torso is its assembly's assembly primitive: asserts NOT in kernel; builds desiredVelocity = calcDesiredWalkVelocity + floor point velocity; steep-slope redirect (floor normal dot unitY below steepSlopeAngle → project input onto surface plus downhill × walkSpeed); altitude-error correction adds `(desiredAltitude − currentY − sink)/stepDt` to vertical velocity when error exceeds sink/4 (sink = 0); XZ velocity delta scaled by runningKMoveP / runningKMovePForPGS; under PGS with a floor, desired XZ velocity is friction-scaled (material-pair or raw friction per property flags); horizontal magnitude capped at maxLinearGroundMoveForce (with floor) else maxLinearMoveForce, then applied as an incremental velocity clamp that never overshoots; integrates `translation += linear·stepDt` plus rotateAboutY for rotational.y; writes both CFrame (`setCoordinateFrame`) and full Velocity including rotational ("big change!"); tickles the floor primitive when moving faster than 2 studs/s (PGS flag true, legacy false); finally `applyImpulseToFloor(stepDt)`.
- `void MovingNoPhysicsBase::fireEvents()` — Super plus `fireMovementSignal(runningSignal, relativeMovementVelocity.xz().length())`.

## Usage

Implements MovingNoPhysicsBase.h. Base reports RUNNING_NO_PHYS as its own state type; concrete subclasses (RunningNoPhysics, StrafingNoPhysics) override only getStateType. State-table transitions:

- **→ RUNNING_NO_PHYS**: NO_TOUCH_ONE_SECOND out of RUNNING/RUNNING_SLAVE (one second without touch and no gyro — the "network ownership lost" drift state), or STRAFE_CMD from RUNNING_NO_PHYS (→ STRAFING_NO_PHYS shares this base).
- **Exits** (both variants): JUMP_CMD→JUMPING, SIT/PLATFORM_STAND commands, FACE_LDR→CLIMBING, OFF_FLOOR_GRACE→FREE_FALL, TOUCHED/NEARLY_TOUCHED/ACTIVATE_PHYSICS/HAS_GYRO→RUNNING (regaining contact returns physics), HAS_BUOYANCY→SWIMMING, DEAD on health/neck loss.

## Gotchas

- The engine-type swap is the load-bearing trick: while in HUMANOID_ENGINE the torso is excluded from normal dynamics simulation; forgetting the reverse swap in `disconnectTorso` would leave characters permanently kinematic — hence the post-disconnect RBXASSERTs.
- Kinematic characters still interact with the world through exactly two channels: the half-gravity floor impulse and `reportTouch` (which drives Touched events and floor wake-up tickles).
- The altitude correction uses `getDesiredAltitude()` (floor hit + hip height) but with sink=0.0 the deadband reduces to `|altitudeError| > 0` — any mismatch corrects immediately; the scaffolding for a bounce-prevention sink exists but is zeroed.
- Friction-scaled desired-velocity adjustment runs only under PGS; legacy solver applies raw kMoveP deltas capped by maxLinearMoveForce (143) instead of the ground cap (500) used when a floor exists.
- `setVelocity` includes rotational velocity (comment flags "big change!") — kinematic turning is a real angular velocity write, not just CFrame orientation.
