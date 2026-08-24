# App/humanoid/Ragdoll.cpp

## Purpose

Implements `HUMAN::Ragdoll`, the limp physics-only state. No control forces are computed; the body tumbles under gravity and joints. The state's only live behavior is an exit timer: after one second of ragdolling, the moment the torso comes nearly to rest the state's timer is zeroed, which fires TIMER_UP and returns the humanoid to GettingUp.

## API

Real definitions:

- `const char* const sRagdoll = "Ragdoll"`.
- `Ragdoll::Ragdoll(Humanoid* humanoid, StateType priorState)` — delegates to Named base; body: `setTimer(8.0f)`.
- `Ragdoll::~Ragdoll()` — `getHumanoid()->setTouchedHard(false)` with comment "Resume monitoring the touchedHard signal".
- `void Ragdoll::onStepImpl()` — "Compute Ragdoll exit condition": fetches slow torso; when `getTimer() <= 7.0` (i.e., at least 1 s into the 8 s window) and torso linear velocity < 1.0 AND rotational velocity < 1.0, calls `setTimer(0.0f)`.
- `onComputeForceImpl` remains the header-inline empty override — no balancing or movement forces.

## Usage

Implements Ragdoll.h in the HumanoidState machine. Transition triggers:

- **→ RAGDOLL**: TOUCHED_HARD from RUNNING / RUNNING_SLAVE (master table) and from SWIMMING; the slave-side table also forces RUNNING→RAGDOLL early on TOUCHED_HARD ("Get into ragdoll fast even before the owner says so"); PHYSICS-state entry shares the ragdollSignal but is a distinct state.
- **RAGDOLL exits**: TIMER_UP → GETTING_UP (via the rest-detection above), JUMP_CMD → GETTING_UP, NO_HEALTH/NO_NECK → DEAD.

## Gotchas

- The 8-second constructor timer is a hard backstop: even a continuously jostled corpse recovers (to GETTING_UP) at 8 s via TIMER_UP.
- Exit detection runs in `onStepImpl`, which executes for BOTH simulating and non-simulating humanoids (`simulate` and `noSimulate` both call it) — slave-side humanoids also time out of ragdoll locally.
- The destructor clearing `touchedHard` matters: Running's force path short-circuits ALL balancing/movement forces while touchedHard is true, so leaving it set would brick the next running state.
- Entry criteria are elsewhere: `computeHitByHighImpactObject` (HumanoidState.cpp) plus `ragdollCriteria` (default 34) decide TOUCHED_HARD; this file only handles leaving.
