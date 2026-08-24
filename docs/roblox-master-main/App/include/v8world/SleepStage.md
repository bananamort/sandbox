# App/include/v8world/SleepStage.h

## Purpose

The sleep/wake state machine of the world (`IStage::SLEEP_STAGE`): maintains per-state assembly sets matching [Enum.md](Enum.md)'s `AssemblyState`, classifies contacts/joints into stepping/touching/contacting edge states, performs recursive wake propagation across joints, and answers the metrics queries. Runs once per step via `stepSleepStage`.

## Declared API

- `class SleepStage : public IWorldStage`
  - Typedefs: `AssemblySet = std::set<Assembly*>`, `JointSet = std::set<Joint*>`, `ContactList = IndexArray<Contact, &Contact::steppingIndexFunc>`, `ContactLists = ContactList[Sim::NUM_THROTTLE_TYPE]`.
  - State sets: `recursiveWakePending` ("only on impact..."), `wakePending`, `awake`, `sleepingChecking` ("Edges that are awake"), `sleepingDeeply` ("no Edges that are awake"), `removing`; plus `steppingContacts`, `touchingContacts`, `steppingJoints`.
  - Scratch vectors (resize amortization): `toDeep/toWake/toSleepingChecking/toSleeping/toStepping/toContacting/toContactingSleeping/toSleepingJoint`; counters `numContactsInStage/numContactsInKernel`, flags `throttling/debugReentrant`, `longStepId`, `recursivePassId`, `externalRecursiveWake`.
  - Main step: `void stepSleepStage(int worldStepId, int uiStepId, bool _throttling);` internals: `stepAssemblies{RecursiveWakePending,WakePending,Awake,SleepingChecking}`, `doContacts(ContactLists&)`, `stepContacts(ContactList&)`, `stepJoints()`.
  - Wake machinery: `wakeAssemblies(AssemblySet&, int maxDepth, Sim::AssemblyState checkState)`, `traverse(assembly, std::deque<Assembly*>&, int maxDepth)`, `wakeEdge(Edge*)`, `wakeEvent(...)` ×2, `recursiveWakeEvent(...)` ×2, `highVelocityNewTouch(Contact*)`, static `highVelocityContact()`, `computeContactState(assembliesMoving, inContact, canCollide, wasTouching) → Sim::EdgeState`.
  - Batch transitions: `changeContactState/changeJointState/changeAssemblyState` (vector + single overloads), `stateToSet(Sim::AssemblyState)`.
  - Sleep decisions: `shouldSleep`, `preventNeighborSleep`, `computeStateFromNeighbors`, `forceNeighborAwake`, `movingTooMuchToSleep`, `edgeIsAwake/isAffecting`, `atLeastOneAssemblyMoving`, validation pair.
  - Public API: ctor `(IStage*, World*)`/dtor; `getStageType() → SLEEP_STAGE`; **`int getMetric(MetricType)` override** — this is a stage that actually implements counters; `onEdgeAdded/onEdgeRemoving`; `onAssemblyAdded/Removing(Assembly*)`; `onExternalTickleAssembly(Assembly* a, bool recursive)`; `int numTouchingContacts();` `const AssemblySet& getAwakeAssemblies() const;`
  - Profilers: scoped_ptrs `profilingCollision/profilingJointSleep/profilingWake/profilingSleep`.

## Gotchas

- Edge states live *here*: contact classification (STEPPING/SLEEPING/CONTACTING/CONTACTING_SLEEPING from [Enum.md](Enum.md)) is computed and batch-applied each step.
- `IndexArray` keyed on `steppingIndexFunc()` gives O(1) removal from contact lists — see [Contact.md](Contact.md).
- `debugReentrant` flag suggests reentrancy is a known hazard around wake events.

## UNKNOWN

- Numeric thresholds: `highVelocityContact()`, sleep velocities, maxDepth defaults (all .cpp).

## Cross-links

- States: [Enum.md](Enum.md); assemblies' sleep helpers: [Assembly.md](Assembly.md)/[AssemblyHistory.md](AssemblyHistory.md); instance-side mirror: [IMoving.md](IMoving.md); kernel it gates: [v8kernel/Kernel.md](../v8kernel/Kernel.md).
