# App/include/humanoid/Jumping.h

## Purpose

Declares the `HUMAN::Jumping` humanoid state — active jump impulse. Extends `Flying` (airborne balancing) with jump-specific force computation, ceiling detection, limb-collision suppression, and a hit-test filter so the jumper's own assembly doesn't block the jump.

## Declared API

- `extern const char* const sJumping;`
- `class RBX::HUMAN::Jumping : public Named<Flying, sJumping>`
  - Private inline: `StateType getStateType() const {return JUMPING;}`
  - Protected overrides: `void onComputeForceImpl();` inline collision overrides `armsShouldCollide/legsShouldCollide/torsoShouldCollide → false`; override `Result filterResult(const Primitive* testMe) const;` ("Override hitTestFiler" [sic])
  - Private helpers: `bool findCeiling(); shared_ptr<PartInstance> tryCeiling(const RbxRay& ray, float maxDistance, Assembly* humanoidAssembly);` member `Vector3 jumpDir;`
  - Public statics (inline): `static float kJumpP() {return 500.0f;}` `static float kJumpVelocityGrid() {return 50.0f;}`
  - Ctor: `Jumping(Humanoid*, StateType priorState);`

## Usage notes

- Inherits Flying→Balancing→HumanoidState chain.
- See [HumanoidState.md](HumanoidState.md), [Balancing.md](Balancing.md).

## Gotchas

- ALL limb/torso collision off while jumping — the body passes through others during the impulse window.
- `kJumpVelocityGrid` is the legacy grid-physics velocity; PGS solver path differs (see .cpp).
- Ceiling check (`findCeiling`/`tryCeiling`) prevents jumping into overhangs by ray-testing above the head.
