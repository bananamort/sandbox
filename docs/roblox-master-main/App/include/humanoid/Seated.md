# App/include/humanoid/Seated.h

## Purpose

Declares two passive humanoid states in one header: `HUMAN::Seated` (sitting on a Seat) and `HUMAN::PlatformStanding` (riding a moving platform without sitting). Both are direct HumanoidState subclasses that apply no balancing forces and disable limb collision and auto-jump.

## Declared API

- `extern const char* const sSeated;`
- `class RBX::HUMAN::Seated : public Named<HumanoidState, sSeated>`
  - Inline overrides: `getStateType() → SEATED`, `armsShouldCollide()→false`, `legsShouldCollide()→false`, `onComputeForceImpl(){}` (no-op), `enableAutoJump()→false`
  - `Seated(Humanoid*, StateType priorState); ~Seated();`
- `extern const char* const sPlatformStanding;`
- `class RBX::HUMAN::PlatformStanding : public Named<HumanoidState, sPlatformStanding>`
  - Identical override set with `getStateType() → PLATFORM_STANDING`
  - `PlatformStanding(Humanoid*, StateType priorState); ~PlatformStanding();`

## Usage notes

- See [HumanoidState.md](HumanoidState.md) for base contract.

## Gotchas

- Zero computed force: the seat weld/joint carries the character; any movement comes from the seat/platform.
- Both states have non-trivial destructors (weld teardown lives in the .cpp).
