# App/include/humanoid/GettingUp.h

## Purpose

Declares the `HUMAN::GettingUp` humanoid state — recovering from a fallen/prone position. Extends `Balancing` but disables arm/leg collision and auto-jump while getting up.

## Declared API

- `extern const char* const sGettingUp;`
- `class RBX::HUMAN::GettingUp : public Named<Balancing, sGettingUp>`
  - Protected inline overrides: `StateType getStateType() const {return GETTING_UP;}`, `bool armsShouldCollide() const {return false;}`, `bool legsShouldCollide() const {return false;}`, `bool enableAutoJump() const { return false; }`
  - `GettingUp(Humanoid* humanoid, StateType priorState);`

## Usage notes

- See [HumanoidState.md](HumanoidState.md) for base contract, [Balancing.md](Balancing.md) for the upright-balance family.

## Gotchas

- Disabling limb collision during the state prevents self-collision jitter during recovery animations.
