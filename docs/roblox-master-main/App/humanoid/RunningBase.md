# App/humanoid/RunningBase.cpp

## Purpose

Implements `HUMAN::RunningBase`, the shared base for grounded walking states (Running, Landed, Climbing). On top of Balancing's upright torque it adds: ground-coupled yaw rotation with solver-specific gains, altitude hover (PD on height above the floor hit), floor-relative horizontal movement toward the desired walk velocity with friction scaling and force caps, ladder climb velocity overrides, steep-slope downhill slide, reaction forces back onto the floor, and residual activate-physics impulse consumption at state entry.

## API

Real definitions:

- File-local constants: `kAltitudeP = 30000.0f` (1/sec², "force = kAltitudeP * mass * position"), `kAltitudeD = 1100.0f` (1/sec).
- DFFlags declared here: `CheckForHeadHit(false)`, `PGSFixGroundSinking(false)`, `HumanoidFeetIsPlastic(false)`, `FixSlowLadderClimb(false)`; referenced: HumanoidFloorPVUpdateSignal, UseTerrainCustomPhysicalProperties. LOGVARIABLE HumanoidFloorProcess 0.
- `RunningBase::RunningBase(Humanoid*, StateType)` — desiredAltitude member-inits 0 then body sets it to **+infinity**; fires an immediate `runningSignal(xz relative speed)` via fireMovementSignal; consumes any pending `getActivatePhysicsImpulse()` by accumulating it on the torso body then clearing activatePhysics; asserts torso engine type is DYNAMICS_ENGINE.
- `RunningBase::RunningBase(Humanoid*, StateType, const float kP, const float kD)` — gain-passing variant (used by Landed); same infinity init + initial running signal, but NO impulse consumption.
- `void onComputeForceImpl()` — Super (Balancing); rotate-with-ground Y torque (`kTurnP()`=7500 legacy / `kTurnPForRotatePGS()`=450 PGS × branchIBodyY × (floorRotVel + desiredRotVel − actual), clamped ±1e5); mass selection = branch mass except legacy unanchored floors use min(character, floor-root) with solidFloor=false; hover block when floor exists and desiredAltitude finite: `yAccelDesired = kAltitudeP·(desiredAltitude − torsoY) − kAltitudeD·(rootVy − floorVy)`, applied only when positive AND headClear AND exceeding current accel; legacy deltaForce clamped ±1e7 solid / ±1e5 non-solid, reaction −deltaForce×0.5 on floor; PGS applies scaleFactor 0.1 (or 1.0 under PGSFixGroundSinking with a 0.2-fraction accel delta) and reaction −deltaForce×0.1; movement block: world-desired velocity = floorVelocity.linear + desiredVelocity.linear, accel via runningKMoveP(1250)/runningKMovePForPGS(150) vs current branch velocity (current accel recomputed minus gravity for CLIMBING under FixSlowLadderClimb); vertical delta skipped/clamped unless facingLadder; horizontal magnitude capped at maxLinearGroundMoveForce (500, with floor) else maxLinearMoveForce (143); friction factor from material properties (HumanoidFeetIsPlastic pairs floor material with PLASTIC, else custom property or raw friction) multiplies XZ delta — legacy path squares kFric first when < 0.3 ("omg hax"); CLIMBING+PGS additionally subtracts the world gravity force from deltaForce; accumulates force at branch COFM; positive-Y only reaction on the floor (full −deltaForce legacy / ×0.1 PGS); reportTouch + updateIfDirty on contact.
- `void onSimulatorStepImpl(float stepDt)` — refreshes desiredAltitude (infinity without floor) and floorVelocity each step; re-reads calcDesiredWalkVelocity when floor present or current/previous state is CLIMBING; ladder override when facingLadder (and, under FixSlowLadderClimb, only when moving): moveDir = −1 when forward·input < −0.2 else +1; if moving toward or airborne, desiredVelocity becomes pure vertical `0.01·moveDir` (idle) or `0.7·speed·moveDir`, x/z/rotational zeroed; steep-slope downhill redirect identical to MovingNoPhysicsBase's (project input onto surface plus downhill × walkSpeed).
- `void onCFrameChangedFromReflection()` — Super; re-syncs desiredAltitude/floorVelocity/desiredVelocity; when input nonzero and facingLadder forces vertical climb velocity `0.7·speed`.

## Usage

Implements RunningBase.h in the HumanoidState machine beneath Running/Landed/Climbing (see [Running.md](Running.md)). Transition triggers are those of its concrete subclasses; this class contributes no state-table row of its own.

## Gotchas

- **desiredAltitude sentinel is +infinity, not 0** — the certified header doc says "ignored if 0.0", but the ctor immediately overwrites 0 with `numeric_limits<float>::infinity()` and every guard tests `< infinity`. A literal 0 would be a valid (underground) hover target.
- Hover requires `getHeadClear()`: something above the head suppresses upward hover force entirely (prevents catapulting under low ceilings).
- Turn gain differs ~17× between solvers (7500 vs 450); mixing constants across paths breaks rotation control (header doc's ~20× figure counts both PGS variants).
- The legacy friction branch deliberately distorts low-friction floors (<0.3 squared → e.g. ice 0.05 becomes 0.0025 effective) — flagged in-source as a hack; new-property and PGS paths apply friction linearly.
- Reaction forces differ by solver AND sign convention: legacy pushes −0.5×hover-delta always and −1×movement-delta when positive-Y; PGS scales both to 0.1 (hover 1.0 under PGSFixGroundSinking).
- Ladder exit velocity is hard-set to 70% of walk speed vertically regardless of slope logic — descending ladders (dot < −0.2) flip moveDir only when there is no floor beneath.
