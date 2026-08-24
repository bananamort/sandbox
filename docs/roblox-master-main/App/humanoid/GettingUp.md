# App/humanoid/GettingUp.cpp

## Purpose

Implements `HUMAN::GettingUp`, the recovery-from-prone state. The entire implementation is constructor gain tuning: legacy-solver gains are supplied through the Balancing gain-passing ctor, and PGS-solver gains overwrite them when the world is using the PGS solver.

## API

Real definitions:

- `const char* const sGettingUp = "GettingUp"`.
- `GettingUp::GettingUp(Humanoid* humanoid, StateType priorState)` — delegates to `Named<Balancing, sGettingUp>(humanoid, priorState, 5000.0f, 300.0f)`, then:
  ```cpp
  if (humanoid && humanoid->getWorld()->getUsingPGSSolver())
  {
      setBalanceP(2250.0f);
      setBalanceD(50.0f);
  }
  ```

## Usage

Implements GettingUp.h in the HumanoidState machine; the balance controller itself runs in [Balancing.cpp](Balancing.md). State-table transitions:

- **→ GETTING_UP**: TIMER_UP from FALLING_DWN (the 3-second topple timer) and from RAGDOLL (its 8-second timer); also JUMP_CMD out of RAGDOLL.
- **GETTING_UP exits**: UPRIGHT → RUNNING (torso up-axis tilt > 0.90 per `computeUpright`), SIT_CMD → SEATED, PLATFORM_STAND_CMD → PLATFORM_STANDING, NO_HEALTH/NO_NECK → DEAD, HAS_BUOYANCY → SWIMMING.

Limb collision and auto-jump remain disabled for the state's duration via header-inline overrides (`armsShouldCollide`/`legsShouldCollide`/`enableAutoJump` → false).

## Gotchas

- **Gain check (task-flagged) — CORRECTION**: the certified header doc records "GettingUp (kP=2250, kD=50)" unconditionally. The source shows those values apply **only under the PGS solver**; on the legacy solver GettingUp runs kP=5000, kD=300. Any instrumentation assuming 2250/50 will misread legacy-solver sessions.
- Gains are fixed at construction: a state instance created before a solver switch keeps its initial gains (states are recreated per transition, so in practice this only matters within one state's lifetime).
- No other logic exists in the file — recovery completion is entirely the UPRIGHT event computed in HumanoidState.cpp, not here.
