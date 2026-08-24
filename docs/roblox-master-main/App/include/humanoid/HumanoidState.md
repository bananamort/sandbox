# App/include/humanoid/HumanoidState.h

## Purpose

Declares the humanoid finite-state-machine core: the `HUMAN::StateType` enum (17 states incl. sentinel), the `HUMAN::EventType` enum (28 simulation events: commands, tilt, ladder, floor, touch, buoyancy, timers), and `HumanoidState` — the abstract base class for every state. It owns per-state bookkeeping (timers, floor raycast results, ladder detection, collision policy), computes events from simulation data, drives the state table transitions (`simulate`/`noSimulate`/`changeState`/factory `create`), and carries anti-exploit machinery (`kCorrectCheckValue`, `getComputeEventBaseAddress`, `checkComputeEvent`).

## Declared API

- Macros: `#define CHARACTER_FORCE_DEBUG 0` — gates `DebugRay` class + `debugRayList` member.
- `typedef enum { FALLING_DWN=0, RAGDOLL, GETTING_UP, JUMPING, SWIMMING, FREE_FALL, FLYING, LANDED, RUNNING, RUNNING_SLAVE, RUNNING_NO_PHYS, STRAFING_NO_PHYS, CLIMBING, SEATED, PLATFORM_STANDING, DEAD, PHYSICS, NUM_STATE_TYPES, xx } StateType;` — trailing `xx` = "NO change" sentinel.
- `typedef enum { NO_HEALTH=0, NO_NECK, JUMP_CMD, STRAFE_CMD, NO_STRAFE_CMD, SIT_CMD, NO_SIT_CMD, PLATFORM_STAND_CMD, NO_PLATFORM_STAND_CMD, TIPPED, UPRIGHT, FACE_LDR, AWAY_LDR, OFF_FLOOR, OFF_FLOOR_GRACE, ON_FLOOR, TOUCHED, NEARLY_TOUCHED, TOUCHED_HARD, ACTIVATE_PHYSICS, FINISHED, TIMER_UP, NO_TOUCH_ONE_SECOND, HAS_GYRO, HAS_BUOYANCY, NO_BUOYANCY, NUM_EVENT_TYPES } EventType;`
- `class RBX::HUMAN::HumanoidState : public INamed, public HitTestFilter`
  - Public static: `static const unsigned int kCorrectCheckValue = 2;`
  - Private state: `Humanoid* humanoid; float timer, noTouchTimer; bool nearlyTouched, shouldRender, finished, outOfWater, headClear; StateType priorState, luaState; G3D::Array<PartInstance*> foundParts;` ("temp buffer") `bool facingLadder; shared_ptr<PartInstance> floorPart; PartMaterial floorMaterial; Vector3 floorTouchInWorld/floorTouchNormal/floorHumanoidLocationInWorld; float noFloorTimer; float lastMovementVelocity;` ("Cut down firing of the running event to when there are major difference in velocity")
  - Event computation privates: `usesEvent(EventType)` (+ inline `usesLadder()`/`usesFloor()`), computeTilt/Tipped/Upright/HasGyro/Jumped/FloorTilt; collision setters setLegs/Arms/Head/TorsoCanCollide; ladder block (`ladderCheck`, virtual `int ladderCheckRate() { return 2; }`, findPrimitiveInLadderZone, findLadder, doLadderRaycast, doAutoJump); floor block (`findFloor`, `tryFloor(ray, hitLocation, hitNormal, maxDistance, assembly, material)`, `AverageFloorRayCast(...)` multi-ray averaging, preStepFloor/preStepCollide/preStepSimulatorSide(dt)/inline preStepSlaveSide); statics `doSimulatorStateTable(shared_ptr<HumanoidState>&, dt)`, `doSlaveStateTable(..., newType)`, factories `create/createNew(newType, oldType, humanoid)`, `changeState(state, newType)`; `fireEvent(StateType, bool entering);` HitTestFilter override `filterResult(const Primitive*)`.
  - Protected tuning constants (inline statics): `minMoveVelocity()=0.5f`, `maxClimbDistance()=2.45f` ("studs"), `maxMoveForce()=(1000,10000,1000)`, `minMoveForce()=(-1000,0,-1000)`, `maxSwimmingMoveForce()=(10000,1000,10000)`, `minSwimmingMoveForce()` all −10000, `fallDelay()=0.125f`, `maxLinearMoveForce()=143.0`; debug vectors `maxTorque/maxForce/maxContactVel/lastTorque/lastForce/lastContactVel`.
  - Public solver constants: `float steepSlopeAngle() const;` `static float runningKMoveP(); static float runningKMovePForPGS(); static float maxLinearGroundMoveForce() { return 500.0; }`
  - Protected event computes: `computeEvent(EventType)`, computeTouched/NearlyTouched/TouchedByMySimulation/TouchedHard/ActivatePhysics; water/timer/finished/facingLadder/headClear/floor accessors; `const Velocity getFloorPointVelocity(); Vector3 getRelativeMovementVelocity(); float getDesiredAltitude() const;` inline `fireMovementSignal(signal<void(float)>&, float movementVelocity);`
  - Pure virtuals / overridables: `virtual void onComputeForceImpl() = 0;` `virtual void onStepImpl() {}` `virtual void onSimulatorStepImpl(float stepDt) {}` `virtual StateType getStateType() const = 0;` public virtuals: armsShouldCollide/legsShouldCollide/headShouldCollide/torsoShouldCollide → true, `enableAutoJump() → true`, `onCFrameChangedFromReflection() { preStepFloor(); }` ("recalculate floor part"), `fireEvents()`, `getYAxisRotationalVelocity() → 0`.
  - Throttle/assembly plumbing: `void setCanThrottleState(bool)` ("only the Seated state can throttle - its joined to parts so it must"), getAssembly/getAssemblyConst, `stateToAssembly()/stateFromAssembly();` ("Attributes moved in assemblies")
  - Public lifecycle/statics: ctor `(Humanoid*, StateType priorState)`, virtual dtor, `getHumanoidConst()/getHumanoid()`, `static HumanoidState* defaultState(Humanoid*)` ("new Running(this)"), `static void simulate(shared_ptr<HumanoidState>&, float dt);` `static void updateHumanoidFloorStatus(...); static bool hasFloorChanged(..., Primitive* lastFloorPrim); static void noSimulate(...)` ("for non-simulating humanoids, match states"), `getCharacterHipHeight(), onComputeForce();`
  - Buoyancy: PUBLIC members `bool torsoHasBuoyancy, leftLegHasBuoyancy, rightLegHasBuoyancy; std::vector<rbx::signals::connection> buoyancyConnections;` inline setters, `bool computeHasBuoyancy();`
  - Misc: `setLuaState(StateType)/getLuaState()`, `static const char* getStateNameByType(StateType);` `bool computeHitByHighImpactObject();` debug-only `render3dAdorn(Adorn*)`, `setNearlyTouched();`
  - Anti-exploit: `static inline const void* getComputeEventBaseAddress()` — _WIN32 only; takes the address of member-function pointer `&computeEvent` via "(const void*&)(hsce); // odd, but required syntax for this horrible conversion." Comment: "for security purposes, get the address of this code. A member function pointer is a compiler defined data structure."; returns NULL off-Win32 or unexpected sizeof. `unsigned int checkComputeEvent();` — "this was added due to exploits."

## Usage notes

- Concrete states live in sibling headers (Running, Jumping, Freefall, ...). See [Humanoid.md](Humanoid.md) for the owner.
- The simulator/slave split (`doSimulatorStateTable` vs `doSlaveStateTable`) is the network-authority vs replication-side divergence point.

## Gotchas

- Floor-touch getters assert against a sentinel `(1e15,1e15,1e15)` vector — reading floor contact before any raycast hits trips RBXASSERT in checked builds.
- `getComputeEventBaseAddress` relies on non-portable member-pointer-to-void reinterpretation — x86/x64 MSVC layout assumptions only.
- `xx` sentinel means "keep current state" in transitions; numeric enum order is load-bearing for state tables.
- Buoyancy flags are public mutable fields with external signal connections stored on the state.
