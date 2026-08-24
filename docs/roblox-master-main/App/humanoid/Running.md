# App/humanoid/Running.cpp

## Purpose

Implements four grounded-movement states declared in Running.h: `HUMAN::Running` (normal walking — fires the running signal and gates all forces behind ragdoll-impact criteria), `HUMAN::RunningSlave` (replication-side variant, no overrides), `HUMAN::Landed` (brief post-jump-landing state with tuned gains and a 0.05 s timer), and `HUMAN::Climbing` (ladder climbing; fires signed or absolute climbing speed).

## API

Real definitions:

- `DYNAMIC_FASTFLAG(EnableClimbingDirection)` (referenced, defined in HumanoidState.cpp).
- Name externs: sRunning/sRunningSlave/sLanded/sClimbing.
- `Running::Running(Humanoid*, StateType)` — empty body.
- `void Running::fireEvents()` — Super plus `fireMovementSignal(getHumanoid()->runningSignal, getRelativeMovementVelocity().xz().length())`.
- `void Running::onComputeForceImpl()` — "Compute Ragdoll entrance criteria": if `humanoid->getTouchedHard()` return immediately ("Disable balancing torques and moving forces"); else `forceCriteria = getRagdollCriteria() * 6000.0f`; if (`lastForce` OR `lastTorque` squared length exceeds forceCriteria²) AND `computeHitByHighImpactObject()` → `setTouchedHard(true)` and return; otherwise `Super::onComputeForceImpl()` (RunningBase movement + Balancing torque).
- `RunningSlave::RunningSlave(Humanoid*, StateType)` — empty; no overrides.
- `Landed::Landed(Humanoid*, StateType)` — gain-passing ctor `Named<RunningBase, sLanded>(humanoid, priorState, 7500.0f, 50.0f)` plus `setTimer(0.05f)` ("time until finished landing after last jump").
- `void Climbing::fireEvents()` — Super plus climbingSignal: signed `getRelativeMovementVelocity().y` under EnableClimbingDirection, else `std::abs(...y)`.

## Usage

Implements Running.h in the HumanoidState machine; shared movement/hover logic lives in [RunningBase.cpp](RunningBase.md). Transition triggers:

- **→ RUNNING**: UPRIGHT out of GETTING_UP; TOUCHED / NEARLY_TOUCHED / ACTIVATE_PHYSICS / HAS_GYRO out of RUNNING_NO_PHYS & STRAFING_NO_PHYS; NO_SIT_CMD from SEATED; NO_PLATFORM_STAND_CMD from PLATFORM_STANDING; AWAY_LDR from CLIMBING; TIMER_UP from LANDED; ON_FLOOR from FLYING.
- **→ Landed**: ON_FLOOR out of FREE_FALL.
- **→ Climbing**: FACE_LDR from FREE_FALL/FLYING/RUNNING/RUNNING_SLAVE/RUNNING_NO_PHYS/STRAFING_NO_PHYS (ladder detection in HumanoidState).
- **→ RunningSlave**: only via `doSlaveStateTable` on the replication side (never a simulator-side table destination).
- **Running exits**: JUMP_CMD/TIPPED/FACE_LDR/OFF_FLOOR_GRACE/TOUCHED_HARD/NO_TOUCH_ONE_SECOND/HAS_BUOYANCY per the master table.

## Gotchas

- The ragdoll gate means a Running humanoid that has EVER been touchedHard applies zero control forces until Ragdoll's destructor clears the flag — impact detection here is conservative by design (see `computeHitByHighImpactObject`: slow human hit by fast object beyond ragdollCriteria×6000 force-equivalent).
- Landed uses kP=7500/kD=50 — same kP as RunningBase's legacy turn constant but as balance gains; its 0.05 s timer makes it a near-instant pass-through to RUNNING unless TIPPED or a new jump grace period intervenes.
- RunningSlave is byte-for-byte Running behaviorally — its identity exists purely so `doSlaveStateTable` can pin it (suppressing the RUNNING_SLAVE→RUNNING_NO_PHYS exit) while touch events settle.
- Climbing reports negative climb speeds (descending) only under EnableClimbingDirection; legacy behavior is absolute value, which is why the flag also changes fireMovementSignal deadband handling (signed comparisons) in HumanoidState.cpp.
