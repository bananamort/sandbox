# App/humanoid/Flying.cpp

## Purpose

Implements `HUMAN::Flying`, the airborne no-ground humanoid state. In this snapshot the implementation is minimal: the constructor raises the balance P gain, and both per-step hooks are empty stubs — Flying effectively contributes **no** control forces of its own.

## API

Real definitions:

- `const char* const sFlying = "Flying"`.
- `Flying::Flying(Humanoid* humanoid, StateType priorState)` — delegates to `Named<Balancing, sFlying>(humanoid, priorState)` (so kP=2250/kD=50 defaults apply first) then calls `setBalanceP(5000.0f)`.
- `void Flying::onSimulatorStepImpl(float stepDt)` — empty; body is the comment `// to implement`.
- `void Flying::onComputeForceImpl()` — empty; body is the comment `// to implement`.

## Usage

Implements Flying.h within the HumanoidState machine. State-table transitions involving FLYING:

- **→ FLYING**: only reachable via `createNew`/lua paths in this table — RUNNING_NO_PHYS and STRAFING_NO_PHYS rows do not target it, and no event column maps another airborne state to FLYING. UNKNOWN: any runtime path that produces FLYING besides direct ChangeState.
- **FLYING exits**: TIPPED → FALLING_DWN, FACE_LDR → CLIMBING, ON_FLOOR → RUNNING, SIT_CMD → SEATED, PLATFORM_STAND_CMD → PLATFORM_STANDING, NO_HEALTH/NO_NECK → DEAD, HAS_BUOYANCY → SWIMMING.
- Because `onComputeForceImpl` is an empty override that does NOT call `Super::onComputeForceImpl()`, the inherited Balancing PD controller never runs while FLYING — the body is ballistic (gravity/joints only) until an exit event fires.

## Gotchas

- Header-side expectation "air control logic lives in the .cpp" is **wrong for this source**: both overrides are explicit no-op stubs. The `setBalanceP(5000)` call is therefore dead tuning in this snapshot — nothing consumes kP because the balance controller body is bypassed by the empty virtual override.
- Auto-jump off (`enableAutoJump() → false` in the header) matches the stub implementation: there is no ladder/auto-jump support mid-flight here.
- Jumping inherits from Flying and re-overrides `onComputeForceImpl` with a real body — but that override's `Super::onComputeForceImpl()` resolves to **Flying's empty stub** (`Super` = `Named<Flying, sJumping>`, which does NOT chain to Balancing), so Balancing's PD never runs during JUMPING either. The kP=5000 dead-tuning caveat therefore covers both Flying and Jumping.
