# App/humanoid/RunningNoPhysics.cpp

## Purpose

Implements `HUMAN::RunningNoPhysics`, the kinematic running state — a thin named subclass of MovingNoPhysicsBase whose only own logic is firing an immediate running signal at construction, with a fast-flag-gated choice between the deadbanded signal helper and a raw signal write.

## API

Real definitions:

- `DYNAMIC_FASTFLAG(ClampRunSignalMinSpeed)` (declared here; also referenced in HumanoidState.cpp).
- `const char* const sRunningNoPhysics = "RunningNoPhysics"`.
- `RunningNoPhysics::RunningNoPhysics(Humanoid* humanoid, StateType priorState)` — delegates to Named base; body:
  - under ClampRunSignalMinSpeed: `fireMovementSignal(humanoid->runningSignal, getRelativeMovementVelocity().xz().length())` (applies minMoveVelocity clamp and ±5% deadband);
  - else: raw `humanoid->runningSignal(getRelativeMovementVelocity().xz().length())`.

All movement behavior (engine-type swap, kinematic CFrame integration, floor impulses, friction) is inherited from [MovingNoPhysicsBase.cpp](MovingNoPhysicsBase.md).

## Usage

Implements RunningNoPhysics.h in the HumanoidState machine; created by the HumanoidState factory for RUNNING_NO_PHYS.

- **→ RUNNING_NO_PHYS**: NO_TOUCH_ONE_SECOND from RUNNING/RUNNING_SLAVE (>1 s without touch, no BodyGyro) — this is the network-ownership-lost drift state.
- **Exits**: JUMP_CMD→JUMPING, STRAFE_CMD→STRAFING_NO_PHYS, FACE_LDR→CLIMBING, OFF_FLOOR_GRACE→FREE_FALL, TOUCHED / NEARLY_TOUCHED / ACTIVATE_PHYSICS / HAS_GYRO → RUNNING (regaining simulation returns physics), SIT/PLATFORM_STAND commands, HAS_BUOYANCY→SWIMMING, NO_HEALTH/NO_NECK→DEAD.

## Gotchas

- The ctor fires the running event exactly once per state entry; steady-state updates while in this state come from MovingNoPhysicsBase::fireEvents each step, not from here.
- With ClampRunSignalMinSpeed disabled (its declared default is false), the raw ctor signal can emit sub-minimum speeds that the deadbanded path would clamp to 0 — script-visible speed values differ between flag states on entry.
