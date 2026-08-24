# App/humanoid/HumanoidState.cpp

## Purpose

Implements the humanoid finite-state-machine core: the 17×26 `STATE_TABLE` transition matrix, event computation (`computeEvent`), floor raycasting, ladder detection, auto-jump, the simulator/slave state-table drivers, the per-state factory (`create`/`createNew`), reflected-signal firing, movement-signal deadbanding, and the anti-exploit machinery (VMProtect regions, nonvolatile-register tamper checks, `checkComputeEvent` self-test).

## API

Real definitions:

- DFFlags defined here: `HumanoidFloorPVUpdateSignal(false)`, `NoWalkAnimWeld(false)`, `ClampRunSignalMinSpeed(false)`, `EnableClimbingDirection(false)`, `FixJumpGracePeriod(true)`, `EnableHipHeight(false)`; FFlag `DebugHumanoidRendering`; LOGGROUPs UserInputProfile / HumanoidFloorProcess.
- `const int STATE_TABLE[NUM_STATE_TYPES+1][NUM_EVENT_TYPES+1]` — padded matrix; row 0/col 0 are sentinels used by asserts. `getStateFast(oldState, eventType)` (unchecked, "exists as part of a security check") vs `getState` (asserts padding then delegates).
- Lifecycle: `HumanoidState::HumanoidState(Humanoid*, StateType priorState)` (resets jump/strafe, `setCanThrottleState(false)`, connects torso/leftLeg/rightLeg `buoyancyChangedSignal`s); dtor disconnects them; `static HumanoidState* defaultState(Humanoid*)` → `new Running(humanoid, RUNNING_NO_PHYS)`.
- Solver constants: `runningKMoveP()` = 1250.0f, `runningKMovePForPGS()` = 150.0f; `steepSlopeAngle()` = cos(maxSlopeAngle°) (0.5 fallback without humanoid).
- Drivers: `static void simulate(shared_ptr<HumanoidState>&, float dt)` — syncs state to assembly, `wakeUp()`, `preStepSimulatorSide(dt)`, `doSimulatorStateTable(state, dt)`, `onSimulatorStepImpl(dt)`, `onStepImpl()`, clears activatePhysics, optional `updateHumanoidFloorStatus`; `static void noSimulate(...)` — reads type from assembly, `preStepSlaveSide()`, `doSlaveStateTable(state, newType)`, `onStepImpl()` only.
- Tables: `changeState(state, newType)` (records previousStateType; reset+create); `doSimulatorStateTable` (luaState override first; iterates all events, gated by `humanoid->getStateTransitionEnabled(newType)` and lazy `computeEvent(e)`; VMProtect mutation region with volatile backups detecting wrong-object returns [hackFlag5] and nv-reg/table-jump tampering [hackFlag7, HATE_HSCE_EBX stats token]); `doSlaveStateTable` (NO_HEALTH/NO_NECK→DEAD override everything, SIT_CMD→SEATED, PLATFORM_STAND_CMD→PLATFORM_STANDING, RUNNING_NO_PHYS own-simulation touch→RUNNING_SLAVE, RUNNING TOUCHED_HARD→RAGDOLL early; RUNNING_SLAVE→RUNNING_NO_PHYS suppressed via `keepRunningSlave`).
- Events: `bool computeEvent(EventType)` — switch over all 26 types with RBX_JUNK obfuscation; notable: ON_FLOOR additionally requires relative Y velocity ≤ 0 under FixJumpGracePeriod; OFF_FLOOR_GRACE compares `noFloorTimer > fallDelay()`; NO_TOUCH_ONE_SECOND requires >1 s no touch AND no gyro; TIMER_UP is `timer <= 0`.
- Factory: `create`/`createNew(newType, oldType, humanoid)` mapping every StateType to its concrete class (default case asserts and returns Running).
- Signals: `fireEvents()` (exit/enter pair + stateChangedSignal when type changed), `fireEvent(StateType, bool entering)` — RUNNING/RUNNING_NO_PHYS→runningSignal(xz length, min-speed clamp under ClampRunSignalMinSpeed), CLIMBING/SWIMMING→their signals with 0.0f, STRAFING_NO_PHYS/FALLING_DWN/RAGDOLL(+PHYSICS)/GETTING_UP/JUMPING/FREE_FALL(+FLYING/LANDED)→active booleans, SEATED→seatedSignal(entering, seatPart), DEAD→diedSignal(); `fireMovementSignal(signal<void(float)>&, float)` — ±5% deadband around lastMovementVelocity plus minMoveVelocity clamp; EnableClimbingDirection variant handles signed values and direction flips.
- Floor: `findFloor(oldFloor)` — multi-ray from torso underside at 40% size scale (z offsets 0,±1,±2 × halfSize.z, center-first), shoulder-corner fallback rays; hysteresis multiplier 1.5 with previous floor else 1.1, +verticalVelocity/100 beyond 100 studs/s; maxDistance 1.0 + hysteresis × leg height (+ hipHeight under EnableHipHeight); results averaged into floorTouchInWorld; resets noFloorTimer. `tryFloor`, `AverageFloorRayCast`, `filterResult` (ignore non-collidable + own assembly).
- Velocity helpers: `getFloorPointVelocity()` (asserts against the uninitialized sentinel; zeroed when shouldNotApplyFloorVelocity applies; throttled by world environment speed), `getRelativeMovementVelocity()` (torso linear − floor point velocity; zero for anchored assembly under NoWalkAnimWeld), `getDesiredAltitude()` = floor hit Y + `getCharacterHipHeight()` (torso half-height + leg height [+hipHeight]).
- Ladder/auto-jump: file-local tuning — `sampleSpacing()`=1/7 stud, `lowLadderSearch` (−0.3+hipHeight or legacy 2.7), `searchDepth` (R15 1.2 else 0.7), `ladderSearchDistance`=1.5×; `findPrimitiveInLadderZone` (extents test ahead of torso), `doLadderRaycast` (merged filters excluding own character/humanoid parts), `findLadder` (rung/space pattern sweep; TRUSS_PART always climbable; success needs space & step within `maxClimbDistance()·heightScale` plus second step or high first step; gated on `getStateTransitionEnabled(CLIMBING)`); `doAutoJump` (feet-level ray blocked + head-height ray (+7) clear + canCollide + autoJumpEnabled → setJump(true)).
- Collision setters: setLegs/Arms/Head/TorsoCanCollide via `setPreventCollide(!canCollide)`; R15 splits UpperTorso/LowerTorso under UseR15Character.
- Impact detection: `computeHitByHighImpactObject()` ("Ragdoll Entrance Criteria - make it conservative") — any contact connector whose relative velocity exceeds `ragdollCriteria` where the human's normal speed is *slower* than the object's → true ("Slow human hit by fast object").
- Anti-exploit: `#pragma optimize("s", on)` around `unsigned int checkComputeEvent()` — sets buoyancy/facingLadder/sit/platformStanding true then false, verifying computeEvent returns the expected positives and negatives; returns `positiveTests + negativeTests` (2 == kCorrectCheckValue when untampered); VMProtect-mutated.

## Usage

Implements HumanoidState.h; this is the engine room every sibling .cpp plugs into. Concrete states never call each other — all transitions flow through `simulate`/`noSimulate` → state tables → `create`. The full transition matrix (row=current, col=event):

| From \ Event | Exits |
|---|---|
| FALLING_DWN | TIMER_UP→GETTING_UP; SIT_CMD→SEATED; PLATFORM_STAND_CMD→PLATFORM_STANDING; HAS_BUOYANCY→SWIMMING |
| RAGDOLL | JUMP_CMD/TIMER_UP→GETTING_UP |
| GETTING_UP | UPRIGHT→RUNNING |
| JUMPING | OFF_FLOOR/OFF_FLOOR_GRACE/FINISHED/TIMER_UP→FREE_FALL |
| SWIMMING | JUMP_CMD→JUMPING; TOUCHED_HARD→RAGDOLL; NO_BUOYANCY→GETTING_UP |
| FREE_FALL | FACE_LDR→CLIMBING; ON_FLOOR→LANDED; HAS_BUOYANCY→SWIMMING |
| FLYING | TIPPED→FALLING_DWN; FACE_LDR→CLIMBING; ON_FLOOR→RUNNING; HAS_BUOYANCY→SWIMMING |
| LANDED | TIPPED→FALLING_DWN; OFF_FLOOR_GRACE→FREE_FALL; TIMER_UP→RUNNING; HAS_BUOYANCY→SWIMMING |
| RUNNING | JUMP_CMD→JUMPING; TIPPED→FALLING_DWN; FACE_LDR→CLIMBING; OFF_FLOOR_GRACE→FREE_FALL; TOUCHED_HARD→RAGDOLL; NO_TOUCH_ONE_SECOND→RUNNING_NO_PHYS; HAS_BUOYANCY→SWIMMING |
| RUNNING_SLAVE | identical to RUNNING |
| RUNNING_NO_PHYS | JUMP_CMD→JUMPING; STRAFE_CMD→STRAFING_NO_PHYS; FACE_LDR→CLIMBING; OFF_FLOOR_GRACE→FREE_FALL; TOUCHED/NEARLY_TOUCHED/ACTIVATE_PHYSICS/HAS_GYRO→RUNNING; HAS_BUOYANCY→SWIMMING |
| STRAFING_NO_PHYS | as RUNNING_NO_PHYS plus NO_STRAFE_CMD→RUNNING_NO_PHYS |
| CLIMBING | JUMP_CMD→JUMPING; TIPPED→FALLING_DWN; AWAY_LDR→RUNNING; OFF_FLOOR/OFF_FLOOR_GRACE/ON_FLOOR stay CLIMBING; HAS_BUOYANCY→SWIMMING |
| SEATED | JUMP_CMD→JUMPING; NO_SIT_CMD→RUNNING; PLATFORM_STAND_CMD→PLATFORM_STANDING |
| PLATFORM_STANDING | JUMP_CMD→JUMPING; SIT_CMD→SEATED; NO_PLATFORM_STAND_CMD→RUNNING |
| DEAD | absorbing — all xx |
| PHYSICS | only NO_HEALTH/NO_NECK→DEAD |

Every non-DEAD state also exits to DEAD on NO_HEALTH/NO_NECK. The blanket SIT_CMD→SEATED and PLATFORM_STAND_CMD→PLATFORM_STANDING exits apply to the ordinary states **except RAGDOLL**, whose columns for both commands are xx (a ragdolled body cannot be seated or un-platformed by command).

## Gotchas

- Numeric enum order is load-bearing: rows/columns are positional, the padding sentinels are assert-only, and `getStateFast` skips even those checks (deliberately, for security-path performance).
- `RUNNING_SLAVE` can never be a table *destination* on the simulator side (RBXASSERT) — it exists only via `doSlaveStateTable` and replication; the slave driver also force-suppresses the RUNNING_SLAVE→RUNNING_NO_PHYS exit so replicated touch events resolve before leaving running.
- The exploit checks in `doSimulatorStateTable` fire hackFlag5 (wrong object returned from create) and hackFlag7 (register/table tampering) — legitimate instrumentation that swaps states or hooks these functions can trip them; both add HATE_HSCE_EBX to stats tokens.
- `ON_FLOOR` semantics changed under FixJumpGracePeriod (default true): touching a floor is not enough — relative vertical velocity must be ≤ 0, which is what makes post-jump grace periods work.
- `computeTouched` uses the *visible* torso and counts only contacts outside the character model; `computeNearlyTouched` counts near-but-not-touching contacts and requires an increase in count versus last check.
- Floor-touch getters assert if read before any raycast populated them (sentinel vector (1e15,1e15,1e15)); `getFloorPointVelocity` documents this with RBXASSERT.
- `findLadder` returns true for ANY truss part contact regardless of rung geometry — trusses are special-cased climbable.
