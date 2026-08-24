# App/include/humanoid/Flying.h

## Purpose

Declares the `HUMAN::Flying` humanoid state — airborne with no ground contact. Header comment: "Flying occurs when there's no ground below you. You have the ability to turn around the y-axis, but not much else." Extends `Balancing` (air control still applies balancing-family forces).

## Declared API

- `extern const char* const sFlying;`
- `class RBX::HUMAN::Flying : public Named<Balancing, sFlying>`
  - Private inline: `StateType getStateType() const {return FLYING;}`
  - Protected overrides: `void onSimulatorStepImpl(float stepDt);` `void onComputeForceImpl();` inline `bool enableAutoJump() const { return false; }`
  - `Flying(Humanoid* humanoid, StateType priorState);`

## Usage notes

- See [HumanoidState.md](HumanoidState.md) and [Balancing.md](Balancing.md).

## Gotchas

- Auto-jump disabled mid-air despite inheriting from Balancing.
- Both simulator-step and force hooks are overridden — air control logic lives in the .cpp.
