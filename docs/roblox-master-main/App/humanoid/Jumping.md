# App/humanoid/Jumping.cpp

## Purpose

Implements `HUMAN::Jumping`, the active jump-impulse state. On top of the inherited Flying/Balancing air behavior it drives the character toward `jumpPower` along a jump direction, applies the equal-and-opposite force to the floor being pushed off, detects ceilings to abort the jump, filters raycast hits so the jumper's own assembly (and worn Accoutrements) can't block detection, and handles two special entry cases: jumping out of water and jumping off a ladder.

## API

Real definitions:

- `DYNAMIC_FASTINTVARIABLE(PGSJumpForceAdjustment, 520)` — PGS force scale factor = 520/1000 = 0.52.
- `const char* const sJumping = "Jumping"`.
- `Jumping::Jumping(Humanoid* humanoid, StateType priorState)` — member-inits `jumpDir(0,1,0)`, then:
  - priorState == SWIMMING → `setOutOfWater()`;
  - priorState == CLIMBING → tilts `jumpDir` away from the horizontal torso look vector (`jumpDir = unit(jumpDir − lookDir)`);
  - always `setTimer(0.5)`.
- `void Jumping::onComputeForceImpl()` — calls `Super::onComputeForceImpl()`; when not finished: measures current velocity along jumpDir, target = `humanoid->getJumpPower()`; desired accel `kJumpP() × (target − current)` (kJumpP=500 header-inline); sets finished when accel ≤ 0 or ceiling found; else with a floor primitive underfoot uses mass = branch mass (PGS) or min(character, floor-root branch mass) legacy; applies only the *difference* above current branch force Y as `jumpDir × newForceY` on the root plus downward `-diff` at the floor touch point (scaled by 0.52 per-force under PGS); without a floor, always applies (branch mass only, ×0.1 under PGS).
- `bool Jumping::findCeiling()` — rays upward from torso bottom center plus four bottom corners (offsets ±halfSize.x/z at 40% size), max distance head height + 1.5×torso height (or 1.5×torso without head).
- `shared_ptr<PartInstance> Jumping::tryCeiling(const RbxRay&, float maxDistance, Assembly*)` — `getHitLegacy` with `filteringAssembly` set; returns hit part only if outside the humanoid's assembly.
- `HitTestFilter::Result Jumping::filterResult(const Primitive*) const` — ignores non-collidable primitives, own assembly, and anything whose PartInstance dynamic-casts to Accoutrement.

## Usage

Implements Jumping.h in the HumanoidState machine. State-table transitions:

- **→ JUMPING**: JUMP_CMD from SWIMMING/RUNNING/RUNNING_SLAVE/RUNNING_NO_PHYS/STRAFING_NO_PHYS/CLIMBING/SEATED/PLATFORM_STANDING (computeJumped requires humanoid jump flag + positive jumpPower, and floor tilt within slope limit for running-family states).
- **JUMPING exits**: OFF_FLOOR / OFF_FLOOR_GRACE / FINISHED / TIMER_UP all → FREE_FALL (0.5 s timer backstop); SIT_CMD → SEATED; PLATFORM_STAND_CMD → PLATFORM_STANDING; NO_HEALTH/NO_NECK → DEAD.

## Gotchas

- All limb/torso collision is disabled during the state via header overrides — the impulse window ghosts through other parts.
- The reaction force on the floor is applied at `getFloorTouchInWorld()` only while a floor primitive exists; once airborne the no-floor branch keeps pushing but nothing pushes back on the world.
- Legacy solver caps effective jump drive by the *smaller* of character/floor branch mass (standing on a light plank weakens your jump); PGS always uses full branch mass but scales forces by DFInt-tuned 0.52.
- `findCeiling` ray origin is the torso's underside moving up — the head itself is inside the filtered-out own assembly, so only external geometry aborts the jump.
- Jumping out of CLIMBING converts vertical intent into a diagonal jumpDir away from the wall face; out of SWIMMING marks outOfWater so buoyancy-based events don't immediately re-trigger.
