# App/humanoid/FallingDown.cpp

## Purpose

Implements three pure-simulation humanoid states declared together in FallingDown.h: `HUMAN::Dead` (death handling that keeps stepping), `HUMAN::FallingDown` (toppled-over transitional state with a 3-second timer), and `HUMAN::Physics` (fully physics-driven, zero humanoid control).

## API

Real definitions:

- Name externs: `sPhysics = "Physics"`, `sFallingDown = "FallingDown"`, `sDead = "Dead"`.
- `Dead::Dead(Humanoid* humanoid, StateType priorState)` — if humanoid and its slow torso exist: `pRoot->setCanCollide(true)` and `pRoot->getPartPrimitive()->setMassInertia(10.0f)`.
- `void Dead::onStepImpl()` — when `Network::Players::backendProcessing(getHumanoid(), false)`, calls `getHumanoid()->setHealth(0.0f)`; source comment: health goes to zero here rather than in the constructor so only the simulating side does it.
- `void Dead::onSimulatorStepImpl(float stepDt)` — if `getHumanoid()->breakJointsOnDeath()` and a character model exists (`Humanoid::getCharacterFromHumanoid`), calls `character->breakJoints()`.
- `FallingDown::FallingDown(Humanoid*, StateType)` — body is a single `setTimer(3.0f)`.
- `Physics::Physics(Humanoid*, StateType)` — empty.

## Usage

All three plug into the HumanoidState table as terminal/passive states. Transition triggers from STATE_TABLE (HumanoidState.cpp):

- **→ DEAD**: NO_HEALTH or NO_NECK from every state except DEAD itself; DEAD is absorbing (its table row is all `xx`).
- **FallingDown**: entered via TIPPED from FLYING/LANDED/RUNNING/RUNNING_SLAVE/CLIMBING; exits TIMER_UP → GETTING_UP (the 3 s timer), SIT_CMD → SEATED, PLATFORM_STAND_CMD → PLATFORM_STANDING, NO_HEALTH/NO_NECK → DEAD, HAS_BUOYANCY → SWIMMING.
- **Physics**: reachable only through `ChangeState`/luaState override (no state-table event row targets it besides its own DEAD exits); once in PHYSICS only NO_HEALTH/NO_NECK → DEAD apply.
- Dead's per-step work runs on both sides: `onStepImpl` also executes for non-simulating humanoids via `noSimulate`, while `onSimulatorStepImpl` (joint breaking) is simulator-side only.

## Gotchas

- Dead is not inert and not merely visual: it forces the torso collidable and sets mass inertia to 10.0 (heavier corpse physics), zeroes health on the backend/simulating side each step, and breaks all character joints every simulator step while `breakJointsOnDeath()` holds (hadNeck && hadHealth).
- The 3-second FallingDown timer is the entire implementation — recovery to GETTING_UP is purely time-based; there is no upright check in this state.
- Health zeroing is deliberately NOT in the constructor (comment records the move) — client-side non-simulating humanoids never drive their own health to zero here.
