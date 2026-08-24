# App/include/humanoid/Swimming.h

## Purpose

Declares the `HUMAN::Swimming` humanoid state — in-water locomotion. Direct `HumanoidState` subclass with velocity-decay-based water drag, custom turn speed, and its own force/step hooks; fires state events and disables auto-jump.

## Declared API

- `extern const char* const sSwimming;`
- `class RBX::HUMAN::Swimming : public Named<HumanoidState, sSwimming>`
  - Private: `Vector3 initialLinearVelocity; static float velocityDecay();` member `Velocity desiredVelocity;`
  - Private inline overrides: `StateType getStateType() const {return SWIMMING;}`, `void fireEvents();`, `bool enableAutoJump() const { return false; }`
  - Protected overrides: `void onComputeForceImpl(); void onSimulatorStepImpl(float stepDt);`
  - Public statics (inline): `static const float kTurnSpeed() {return 6.0f;}` — "note Humanoid autoTurnSpeed is 8.0f;" and `static const float kTurnAccelMax() {return 20000.0f * kTurnSpeed();}`
  - Ctor: `Swimming(Humanoid*, StateType priorState);`

## Usage notes

- See [HumanoidState.md](HumanoidState.md) for base contract.

## Gotchas

- Swimming deliberately uses a SLOWER turn speed (6.0) than the humanoid default auto-turn (8.0) — comment calls this out explicitly.
- `initialLinearVelocity` captured at entry suggests momentum carry-over from the previous state on first step.
