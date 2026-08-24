# App/include/humanoid/MovingNoPhysicsBase.h

## Purpose

Declares `HUMAN::MovingNoPhysicsBase`, the base for kinematic humanoid movement states (Running/StrafingNoPhysics): moves the character without physics forces, disables all body-part collision, tracks the torso part and its ancestry so the state can detach cleanly, and applies reaction impulses to whatever floor is beneath.

## Declared API

- `extern const char* const sMovingNoPhysicsBase;`
- `class RBX::HUMAN::MovingNoPhysicsBase : public Named<HumanoidState, sMovingNoPhysicsBase>`
  - Private inline: `StateType getStateType() const {return RUNNING_NO_PHYS;}` — NOTE base reports RUNNING_NO_PHYS as its default type.
  - Override: `void fireEvents();`
  - State/helpers: `shared_ptr<PartInstance> torsoPart; weak_ptr<PhysicsService> physicsService;` scoped connection `torsoAncestryChanged;` handlers `onEvent_TorsoAncestryChanged(); disconnectTorso(); const Assembly* getAssemblyConst() const; void applyImpulseToFloor(float dt);`
  - Protected overrides: `void onSimulatorStepImpl(float stepDt); void onComputeForceImpl();` collision overrides arms/legs/`headTorsoShouldCollide` all → false.
  - `MovingNoPhysicsBase(Humanoid*, StateType priorState); ~MovingNoPhysicsBase();`

## Usage notes

- Concrete states: [RunningNoPhysics.md](RunningNoPhysics.md), [StrafingNoPhysics.md](StrafingNoPhysics.md).
- See [HumanoidState.md](HumanoidState.md) for base contract.

## Gotchas

- Base class's own getStateType returns RUNNING_NO_PHYS — subclasses must override or they misreport.
- Collision fully off (including head/torso) — kinematic characters ghost through the world except for floor impulses.
- Torso ancestry tracking exists because the torso can be re-parented mid-state; failing to disconnect leaves dangling connections.
