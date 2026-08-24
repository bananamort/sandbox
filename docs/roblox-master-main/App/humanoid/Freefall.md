# App/humanoid/Freefall.cpp

## Purpose

Implements `HUMAN::Freefall`, the airborne-descent state with air control. Extends Balancing: keeps the PD upright controller (via `Super::onComputeForceImpl()`), adds yaw turn control toward the walk direction, horizontal air steering toward the desired walk velocity, zeroed head/torso friction for the duration of the fall, and exponential decay of entry momentum.

## API

Real definitions:

- Private statics: `characterVelocityInfluence()` → 0.0f, `floorVelocityInfluence()` → 0.95f, `velocityDecay()` → 0.05f ("part of initial velocity lost every 1/30 sec").
- `Freefall::Freefall(Humanoid*, StateType)` — member-inits `headFriction(0)`, `torsoFriction(0)`, `initialized(false)`; saves and zeroes primitive friction on slow-fetched head and torso; `setBalanceP(5000.0f)`.
- `Freefall::~Freefall()` — restores saved friction on head/torso, but only when the saved value was > 0.
- `float Freefall::kTurnSpeed()` → 6.0f (comment: "note Humanoid autoTurnSpeed is 8.0f"); `float Freefall::kTurnSpeedForPGS()` → 8.0f.
- `void Freefall::onSimulatorStepImpl(const float stepDt)` — recomputes `desiredVelocity` from `calcDesiredWalkVelocity()` plus `initialLinearVelocity`; zeroes it below 0.1 magnitude; else computes yaw angle error to torso heading and sets `desiredVelocity.rotational.y` to full turn speed beyond 0.2 rad or a proportional `0.25 × speed × |error|` inside it (gated on `getAutoRotate()` and NOT `mouseLockedInMouseLockMode()`); finally decays `initialLinearVelocity *= 1 - velocityDecay()·stepDt/(1/30)`.
- `void Freefall::onComputeForceImpl()` — calls `Super::onComputeForceImpl()` (Balancing torque), then applies Y-axis turn torque (`RunningBase::kTurnP()` legacy / `RunningBase::kTurnPForFreeFallPGS()` PGS times branch inertia-Y times rotational error, minus existing branch torque, clamped to ±branchIBodyY·kTurnAccelMax), then linear air-control force via `runningKMoveP()`/`runningKMovePForPGS()` with Y accel clamped to `min/maxMoveForce().y`, horizontal magnitude capped at `maxLinearMoveForce()`, and **`deltaForce.y = 0.0f` before accumulation**.

## Usage

Implements Freefall.h in the HumanoidState machine. State-table transitions:

- **→ FREE_FALL**: OFF_FLOOR and OFF_FLOOR_GRACE from JUMPING; OFF_FLOOR_GRACE from LANDED/RUNNING/RUNNING_SLAVE/RUNNING_NO_PHYS/STRAFING_NO_PHYS.
- **FREE_FALL exits**: ON_FLOOR → LANDED, FACE_LDR → CLIMBING, SIT_CMD → SEATED, PLATFORM_STAND_CMD → PLATFORM_STANDING, NO_HEALTH/NO_NECK → DEAD, HAS_BUOYANCY → SWIMMING.

## Gotchas

- **Gain check (task-flagged)**: CONFIRMED — kP=5000 is set in the constructor. kD is untouched, so Freefall runs the Balancing default kD=50. The certified header doc's "Freefall (kP=5000)" is correct but incomplete on kD.
- The `initialized` deferred-init block is **commented out** (lines 71–77): the header doc's "first simulator step performs deferred init" no longer happens. `initialLinearVelocity` stays default-zero for the state's lifetime, which also means `characterVelocityInfluence`/`floorVelocityInfluence` are currently dead tuning — only the decay line still touches the (zero) vector.
- Friction fields are NOT vestigial despite the header comment "I set both of these to zero!": the constructor actually saves primitive friction values and zeroes them, and the destructor restores them (restore skipped when saved value ≤ 0).
- PGS turns *faster* than legacy here (8 vs 6 rad/s); `kTurnAccelMax` = 20000 × legacy 6 regardless of solver.
- Vertical air control is computed then discarded (`deltaForce.y = 0`) — freefall can steer horizontally but never thrust up/down.
