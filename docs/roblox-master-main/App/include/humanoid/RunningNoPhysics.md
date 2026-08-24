# App/include/humanoid/RunningNoPhysics.h

## Purpose

Declares the `HUMAN::RunningNoPhysics` humanoid state — running movement without physics simulation (kinematic mode), a named subclass of `MovingNoPhysicsBase` reporting state type `RUNNING_NO_PHYS`.

## Declared API

- `extern const char* const sRunningNoPhysics;`
- `class RBX::HUMAN::RunningNoPhysics : public Named<MovingNoPhysicsBase, sRunningNoPhysics>`
  - Private inline override: `StateType getStateType() const {return RUNNING_NO_PHYS;}`
  - `RunningNoPhysics(Humanoid* humanoid, StateType priorState);`

## Usage notes

- Part of the humanoid finite-state family; see [HumanoidState.md](HumanoidState.md) for the base contract and [MovingNoPhysicsBase.md](MovingNoPhysicsBase.md) for shared kinematic behavior.

## Gotchas

- No additional behavior beyond type tagging — all logic inherited.
