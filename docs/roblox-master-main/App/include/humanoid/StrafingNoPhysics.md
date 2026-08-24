# App/include/humanoid/StrafingNoPhysics.h

## Purpose

Declares the `HUMAN::StrafingNoPhysics` humanoid state — sideways (strafing) movement in kinematic no-physics mode; named subclass of `MovingNoPhysicsBase` reporting `STRAFING_NO_PHYS`.

## Declared API

- `extern const char* const sStrafingNoPhysics;`
- `class RBX::HUMAN::StrafingNoPhysics : public Named<MovingNoPhysicsBase, sStrafingNoPhysics>`
  - Private inline override: `StateType getStateType() const {return STRAFING_NO_PHYS;}`
  - `StrafingNoPhysics(Humanoid* humanoid, StateType priorState);`

## Usage notes

- See [HumanoidState.md](HumanoidState.md) and [MovingNoPhysicsBase.md](MovingNoPhysicsBase.md).

## Gotchas

- Tag-only class; all movement logic inherited.
