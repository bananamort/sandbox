# App/humanoid/StrafingNoPhysics.cpp

## Purpose

Implements `HUMAN::StrafingNoPhysics`, the kinematic strafing state — a tag-only subclass of MovingNoPhysicsBase. The constructor is empty; the state exists so the state machine can distinguish sideways no-physics movement from forward RUNNING_NO_PHYS while sharing every bit of kinematic behavior.

## API

Real definitions:

- `const char* const sStrafingNoPhysics = "StrafingNoPhysics"`.
- `StrafingNoPhysics::StrafingNoPhysics(Humanoid* humanoid, StateType priorState)` — delegates to `Named<MovingNoPhysicsBase, sStrafingNoPhysics>`; empty body.

All behavior (engine-type swap, kinematic integration, floor impulses, running-signal firing) is inherited from [MovingNoPhysicsBase.md](MovingNoPhysicsBase.md).

## Usage

Implements StrafingNoPhysics.h in the HumanoidState machine.

- **→ STRAFING_NO_PHYS**: STRAFE_CMD from RUNNING_NO_PHYS (the only table entry that produces it).
- **Exits**: NO_STRAFE_CMD → RUNNING_NO_PHYS, JUMP_CMD → JUMPING, FACE_LDR → CLIMBING, OFF_FLOOR_GRACE → FREE_FALL, TOUCHED / NEARLY_TOUCHED / ACTIVATE_PHYSICS / HAS_GYRO → RUNNING, SIT/PLATFORM_STAND commands, HAS_BUOYANCY → SWIMMING, DEAD.

Note the base's `fireEvents` fires the *running* signal (not strafing) while in this state; the reflected Strafing active event fires only on entry/exit via HumanoidState::fireEvent.

## Gotchas

- Despite being a movement state, its per-step signal is `runningSignal` — animation code keying off Strafing gets only the boolean active event from fireEvent, never speed updates.
- Entering requires already being in RUNNING_NO_PHYS: normal physics Running never transitions directly to strafing.
