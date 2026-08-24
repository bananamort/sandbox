# App/humanoid/Swimming.cpp

## Purpose

Implements `HUMAN::Swimming`, the in-water locomotion state. A direct HumanoidState subclass (NOT Balancing) with its own hand-rolled pitch-balance PD controller, thrust toward the desired velocity when moving fast enough, velocity-decay drag on entry momentum, and a swimming speed signal. Swimming direction is deliberately decoupled from torso facing — the yaw/pitch turn logic is compiled out.

## API

Real definitions:

- `float Swimming::velocityDecay()` → 0.05f ("part of initial velocity lost every 1/30 sec").
- `const char* const sSwimming = "Swimming"`.
- `Swimming::Swimming(Humanoid*, StateType)` — delegates to Named base; body fires `humanoid->swimmingSignal(0.0f)`.
- `void Swimming::onComputeForceImpl()` — local tuning: `pPitch=7500`, `pRoll=1000`, `kD=50`. Guards on torso/root bodies. Flattens the desired velocity toward horizontal when vertical is within ±26.5° (`|desiredY·2| < horizontalMagnitude` → direction × full magnitude). Thrust block: only when desired magnitude > 10 — `desiredAccel = 35 × branchMass × velocityError`, clamped to `min/maxSwimmingMoveForce()`, accumulated at branch COFM. Facing-torque block: pitch axis from torso up-vector; when desired speed² < 5 balance toward world Y with pPitch=500, else pPitch=2000 and tilt = cross(desiredVelocity.unit(), torsoUp); control torque = −pPitch·(branchIBody·tiltRoot) − kD·(branchIBodyV3·angVel) + external torque; accumulates difference vs external.
- `void Swimming::onSimulatorStepImpl(float stepDt)` — desiredVelocity = calcDesiredWalkVelocity + initialLinearVelocity; zeroed below 0.1 magnitude; the entire else-branch (yaw/pitch turn speeds using kTurnSpeed) is wrapped in `#if 0` with comment "Swimming direction is now decoupled from torso facing direction"; finally decays initialLinearVelocity by `velocityDecay·stepDt/(1/30)`.
- `void Swimming::fireEvents()` — Super plus `fireMovementSignal(swimmingSignal, getRelativeMovementVelocity().length())` (full 3D length, not XZ).

## Usage

Implements Swimming.h in the HumanoidState machine; created by the HumanoidState factory for SWIMMING. Transition triggers:

- **→ SWIMMING**: HAS_BUOYANCY from every ordinary state except RAGDOLL/DEAD/PHYSICS/SEATED/PLATFORM_STANDING rows (torso buoyancy flag flips true when torso enters water).
- **SWIMMING exits**: JUMP_CMD → JUMPING (with setOutOfWater carried into Jumping), TOUCHED_HARD → RAGDOLL, NO_BUOYANCY → GETTING_UP, SIT_CMD → SEATED, PLATFORM_STAND_CMD → PLATFORM_STANDING, NO_HEALTH/NO_NECK → DEAD.

Humanoid-side coupling: `allow3dWalkDirection()` and camera-relative `move()` both special-case SWIMMING for full-3D input, and first-person direct torso rotation skips SWIMMING.

## Gotchas

- **Derivation check (task-flagged): CONFIRMED** — `Named<HumanoidState, sSwimming>` derives straight from HumanoidState, not Balancing. The header doc is accurate. Consequence: none of Balancing's tick-throttled torque or maxTorqueComponent clamps apply; Swimming rolls its own per-call PD with different gain structure (pPitch varies 500–7500 by context).
- kTurnSpeed()=6.0 (vs Humanoid autoTurnSpeed 8.0) is real in the header but currently dead code: the only consumer is inside the `#if 0` block. Turning while swimming happens through other paths (e.g., first-person rotation excluded, autorotate via calcDesiredWalkVelocity's rotational component still flows through desiredVelocity).
- pRoll=1000 is declared but every roll-axis line is commented out — roll control is unimplemented; only pitch is balanced.
- Thrust has a dead zone: below desired-magnitude 10 no linear force is applied at all (only balance torque), so slow drift relies on momentum decay rather than active damping.
- The swimmingSignal fires with the FULL 3D relative-velocity length here versus Running's XZ-only length — vertical bobbing shows up as swim speed but not run speed.
