# App/include/humanoid/Ragdoll.h

## Purpose

Declares the `HUMAN::Ragdoll` humanoid state — fully limp physics-driven body. Direct `HumanoidState` subclass (NOT Balancing): no computed forces, no auto-jump; stepping handled by `onStepImpl`.

## Declared API

- `extern const char* const sRagdoll;`
- `class RBX::HUMAN::Ragdoll : public Named<HumanoidState, sRagdoll>`
  - Private inline overrides: `StateType getStateType() const {return RAGDOLL;}`, `void onComputeForceImpl() {}` (no-op), `bool enableAutoJump() const { return false; }`
  - Protected override declared: `void onStepImpl();`
  - `Ragdoll(Humanoid* humanoid, StateType priorState); ~Ragdoll();`

## Usage notes

- The header retains a stale copy-paste comment ("Flying occurs when there's no ground below you...") above the class — it describes Flying, not Ragdoll.
- See [HumanoidState.md](HumanoidState.md) for base contract.

## Gotchas

- Empty `onComputeForceImpl` means zero active balancing force — gravity/joints alone drive the body.
- Non-trivial destructor: state teardown does real work (joint/impulse cleanup in .cpp).
