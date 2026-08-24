# App/include/v8world/World.h

## Purpose

The world simulation facade: owns the primitive registry, the stage pipeline (Clean → Joint → Ground → Edge → Contact → Tree → Moving → SpatialFilter → MechToAssembly → Assembly → MovingAssembly → StepJoints → Humanoid → Sleep → Simulate → Kernel), the [ContactManager.md](ContactManager.md), and [SendPhysics.md](SendPhysics.md); runs the step loop with adaptive throttling, auto-joining, breakable-joint processing, touch reporting, and engine analytics.

## Declared API

- Free function: `void notifyAssemblyPrimitiveMoved(Primitive* p, bool resetContacts);` ("In Assembly.cpp").
- `struct RootPrimitiveOwnershipData { SystemAddress ownerAddress; bool ownershipManual; Primitive* prim; };` — network-ownership gather payload.
- `class EThrottle` — adaptive frame throttle:
  - `enum EThrottleType { ThrottleDefaultAuto, ThrottleDisabled, ThrottleAlways, Skip2, Skip4, Skip8, Skip16 };` static `EThrottleType globalDebugEThrottle;`
  - `EThrottle(); bool computeThrottle(int step); bool increaseLoad(bool increase); float getEnvironmentSpeed() const; get/setThrottleIndex(int)`; private `requestedSkip/usedSkip/throttleSetting[]/throttleIndex`.
- `class World` (friend: ContactManager)
  - Signals (public): `postInsertJointSignal(Joint*, Primitive*, vector<Primitive*>&)`, `postRemoveJointSignal(Joint*, vector<Primitive*>&, vector<Primitive*>&)`, `autoJoinSignal(Joint*)`, `autoDestroySignal(Joint*)`, `primitiveCollideSignal(pair<Primitive*, Primitive*>)`.
  - `struct TouchInfo { Primitive* p1/p2; shared_ptr<PartInstance> pi1/pi2; enum {Touch, Untouch} Type; }` — reported via `getTouchInfoFromLastStep()/clearTouchInfoFromLastStep()/reportTouchInfo(...)`; visitor helper `OnPrimitiveMovingVisitor` (notify moved + extents changed).
  - Step control: `float step(bool longStep, double distributedGameTime, float desiredInterval, int numThreads);` ("10–100 frames per second"), private `uiStep(longStep, distributedGameTime)` / `doWorldStep(throttling, uiStepId, numThreads, debugTime)` / `doBreakJoints()` / `notifyMovingAssemblies()`; `int updateStepsRequiredForCyclicExecutive(float desiredInterval);` `assemble(); bool isAssembled(); reset(); getWorldStepId(); float getWorldStepsAccumulated(); getUiStepId(); getLongUiStepId();` counters `int worldSteps; int worldStepId;` ("two years at 1/30 second dt") and `float worldStepAccumulated;`
  - Stage accessors: `getCleanStage` implied by member, plus `getGroundStage/getSleepStage/getTreeStage/getSpatialFilter/getAssemblyStage/getMovingAssemblyStage/getStepJointsStage/getSimulateStage/getHumanoidStage/getKernel()`, public `getSendPhysics()`, `getSimSendFilter()`, `getContactManager()`.
  - Primitives: `insertPrimitive/removePrimitive(p, isStreamingRemove)/ticklePrimitive(p, recursive)` ("simulates a touch, wakes up"); `IndexArray<Primitive, &Primitive::worldIndexFunc> primitives;` iteration via `getPrimitives()`; `getPrimitiveFromBodyUID(uint64_t uid)` against `primitiveIndexation` map fed by `boost::uint64_t UIDGenerator;` special `groundPrimitive` "for now, only used by kernel joints".
  - Auto-joint API: `joinAll(); createAutoJoints(Primitive*)`; `createAutoJointsToWorld(array)` ("ignores joints between them"); `createAutoJointsToPrimitives(array)` ("only join each other in this group"); matching `destroyAutoJoints(...)` trio (`includeExplicit/includeAuto` knobs); terrain weld cleanup: `destroyTerrainWeldJointsWithEmptyCells(megaClusterPrim, region, touchingPrim)`, `destroyTerrainWeldJointsNoTouch(megaClusterPrim, touchingPrim)`.
  - Joints/contacts: `insertJoint/removeJoint/jointCoordsChanged/notifyMoved(Primitive*)`; contacts insert/destroy are ContactManager-only ("Can only be called by the contact manager").
  - Ownership gathering: `gatherMechDataPreJoin(j, Primitive*& unGroundedPrim, vector<Primitive*>& combiningRoots)`, `gatherMechDataPreSplit(j, prim0ChildRoots, prim1Roots)`.
  - Edit notifications: `onPrimitiveEngineChanging/Changed`, `onPrimitiveFixedChanging/Changed`, `onPrimitive{PreventCollide,Extents,ContactParameters,Geometry}Changed`, `onPrimitiveCollided(p0,p1)`, `onAssemblyPhysicsChanged(a, physics)`, `onAssemblyInSimluationStage(a)` *(sic)*, joint-side `onJointPrimitiveNulling/Set`, animated-joint add/remove to MovingAssemblyStage.
  - Metrics/inquiry: `getMetric(MetricType)`, `getNumBodies/Points/Constraints/HashNodes/MaxBucketSize/LinkCalls/Contacts/Joints/Primitives`, `getEnvironmentSpeed[Percent]`.
  - Config: `get/setFRMThrottle(int)`, `EThrottle& getEThrottle()`, `setFallenPartDestroyHeight/getFallenPartDestroyHeight` (HeapValue), `get/setUsingPGSSolver(bool)`, `setUserId(int)`, `setPhysicsAnalyzerEnabled(bool)`, `getUsingNewPhysicalProperties()`, `PhysicalPropertiesMode get/setPhysicalPropertiesMode`, Bullet accessors (`getBulletCollisionDispatcher`, private dispatcher + collision configuration).
  - Analytics: motion-analytic doubles (`errorCount/passCount/frameinfos*/targetDelayTenths/maxDelta...`) with `plusErrorCount/plusPassCount/sendAnalytics/addFrameinfosStat(...)`.
  - Profilers: scoped_ptrs for Break/Assembly/Filter/WorldStep/UiStep + `loadProfilers(vector<CodeProfiler*>&)`.
  - Debug guards: `assertNotInStep()/assertInStep()` on `inStepCode`.

## Gotchas

- `worldStepId` is a plain int incremented every step — comment admits it wraps after "two years at 1/30 second dt"; don't persist it.
- `ticklePrimitive` wakes assemblies (sleep system) without simulating a real touch event stream.
- The moving-primitives/breakable-joints arrays are labeled "redundant data" — maintained as performance mirrors of pipeline state.
- `step()` returns a float (actual delta used) and accepts thread count — the world drives multi-threaded stepping internally.

## UNKNOWN

- Exact throttle cadence table (`throttleSetting[]`) and FRM semantics live in the .cpp.

## Cross-links

- Pipeline stages: see [IWorldStage.md](IWorldStage.md) roster; broadphase: [ContactManager.md](ContactManager.md); replication: [SendPhysics.md](SendPhysics.md)/[SimJob.md](SimJob.md); kernel terminal: [v8kernel/Kernel.md](../v8kernel/Kernel.md), solver toggle: [../solver/Solver.md](../solver/Solver.md).
- Sleep/wake entry points consumed by [SleepStage.md](SleepStage.md); time type: Base [rbxTime.h.md](../../../Base/include/rbx/rbxTime.h.md); signals: Base [signal.h.md](../../../Base/include/rbx/signal.h.md).
