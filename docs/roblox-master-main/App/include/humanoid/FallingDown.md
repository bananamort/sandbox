# App/include/humanoid/FallingDown.h

## Purpose

Declares three "pure simulation" humanoid states in one header (per source comment): `HUMAN::Dead` (death pose, still steps/simulates), `HUMAN::FallingDown` (toppled-over transitional state), and `HUMAN::Physics` (fully physics-driven, no humanoid control). None compute forces or allow auto-jump.

## Declared API

- `extern const char* const sDead;`
- `class RBX::HUMAN::Dead : public Named<HumanoidState, sDead>`
  - Inline overrides: `getStateType() → DEAD`, `onComputeForceImpl(){}`, auto-jump off. Declared: `void onStepImpl(); void onSimulatorStepImpl(float stepDt);`
  - `Dead(Humanoid*, StateType priorState);`
- `extern const char* const sFallingDown;`
- `class RBX::HUMAN::FallingDown : public Named<HumanoidState, sFallingDown>`
  - Inline overrides: `getStateType() → FALLING_DWN`, `onComputeForceImpl(){}`, auto-jump off.
  - `FallingDown(Humanoid*, StateType priorState);`
- `extern const char* const sPhysics;`
- `class RBX::HUMAN::Physics : public Named<HumanoidState, sPhysics>`
  - Inline overrides: `getStateType() → PHYSICS`, `onComputeForceImpl(){}`, auto-jump off.
  - `Physics(Humanoid*, StateType priorState);`

## Usage notes

- See [HumanoidState.md](HumanoidState.md) for base contract.

## Gotchas

- Enum spelling `FALLING_DWN` (abbreviated) is the canonical StateType value.
- Dead is NOT inert: it keeps stepping (`onStepImpl`/`onSimulatorStepImpl`) — used for death effects/timing, not a frozen state.
- Physics state means the Humanoid applies zero control — body tumbles freely until another state claims it.
