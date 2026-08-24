# App/include/v8world/SpatialFilter.h

## Purpose

Pipeline stage (`IStage::SPATIAL_FILTER`) deciding *where* each assembly simulates and who receives its physics: assigns every assembly root a `FilterPhase` (from [Assembly.md](Assembly.md)) based on region/address rules, batching phase transitions. The in-header matrix summarizes the policy:

| | Simulate | Physics Service (Send) |
|---|---|---|
| Client | NO — doesn't step | NO — doesn't step |
| Server | ALL | If Sim |
| Edit/Visit Solo | ALL | N0 *(sic — NO)* |
| Dphysics Client | Region or Address | If Sim |
| Dphysics Server | Address Match (null = region empty) | If Awake or Sim |

## Declared API

- `typedef std::set<Assembly*> AssemblySet;`
- Phase classifiers (static): `sendingPhase` (NoSim_Send, NoSim_Send_Anim), `simulatingPhase` (Sim_SendIfSim, Sim_BufferZone), `noSimPhase` (the four NoSim_* phases), `animationPhase` (*_Anim pair).
- Queries: `bool inClientSimRegion(Assembly*)`, `bool addressMatch(Assembly*)`, private `isNotClientAddress(Assembly*)`.
- Registry: `AssemblySet assemblies[Assembly::NUM_PHASES];` accessor `const AssemblySet& getAssemblies(FilterPhase)` (asserts < NUM_PHASES); `SimSendFilter& getSimSendFilter();` member `SimSendFilter filter;`
- Step: `void filterStep();` — applies pending moves; internals: `MoveInstructions {Assembly* a; FilterPhase from, to}` staged in `G3D::Array<MoveInstructions> toMove`, `filterAssembly(a, simulating, Time wakeupNow)` ("when simulating, this can affect the datamodel"), `changePhase/moveInto/removeFromPhase/moveAll(destination)`.
- Notifications: `onMovingAssemblyRootAdded(Assembly*, Time now)` (note the **Time** parameter), `onFixedAssemblyRootAdded(Assembly*)`, `onAssemblyRootRemoving(Assembly*)`.
- Private: joint bookkeeping across phase changes (`insertPrimitiveJoints/removePrimitiveJoints`), `getMechToAssemblyStage()`.

## Gotchas

- Phase transitions are deferred to `filterStep` via `toMove` — reading `getFilterPhase()` mid-frame can see pre-step values.
- `filterAssembly` may touch the datamodel while simulating — re-entrancy hazard documented in-header.
- The policy table's "N0" is a typo for "NO" in the original comment; also contains a mojibake byte in "doesn't step" (encoding artifact).

## Cross-links

- Phases: [Assembly.md](Assembly.md) (`FilterPhase` enum); consumers: [SendPhysics.md](SendPhysics.md), [SimulateStage.md](SimulateStage.md); stage neighbors: [MechToAssemblyStage.md](MechToAssemblyStage.md), [MovingStage.md](MovingStage.md).
