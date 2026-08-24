# App/include/v8world/IMoving.h

## Purpose

Datamodel-facing motion/sleep interface pair: `IMoving` is implemented by the instance layer (PartInstance) behind each Primitive to report movement and receive sleep/clump/buoyancy callbacks; `IMovingManager` tracks the moving set and puts stale movers to sleep on a heartbeat. In-header note: `notifyMoved` "done in PartInstance::setCoordinateFrame, InterpolatedCFrame, and by the World after every step".

## Declared API

- `class RBXBaseClass IMoving`
  - Members (private, manager-owned linkage): `IMovingManager* iMovingManager; int stepsToSleep; scoped_ptr<CoordinateFrame> lastCFrame; Time lastUpdateTime; scoped_ptr<MovementHistory> movementHistory;`
  - `void notifyMoved();` — the primary entry point called by the instance layer and the World after steps.
  - Pure virtuals (callbacks into the instance): `bool reportTouches() const = 0;` `void onClumpChanged() = 0;` `void onNetworkIsSleepingChanged(Time now) = 0;` `void onBuoyancyChanged(bool value) = 0;` `bool isInContinousMotion() = 0;` *(sic: "Continous")*
  - Virtual: `const Primitive* getConstPartPrimitiveVirtual() const {return NULL;}`
  - Sleep: `bool getSleeping() const {return stepsToSleep == 0;}` `void forceSleep();` protected `bool checkSleep();` pure `onSleepingChanged(bool sleeping)`; `setMovingManager(...)`.
  - Movement memory: `const MovementHistory& getMovementHistory() const`, `clearMovementHistory()`, `addMovementNode(const CoordinateFrame&, const Velocity&, const Time&)`, `setLastCFrame`, `getLastCFrame(defaultCFrame)`, `hasLastCFrame()`, `setLastUpdateTime/getLastUpdateTime`.
- `class RBXBaseClass IMovingManager`
  - Members: `std::set<IMoving*> moving; MovingSet::iterator current;` — iterator held across callback re-entrancy.
  - `void onMovingHeartbeat();` — "put parts to sleep here if not moving for a long time, notify".
  - `int getNumberMoving() const;` `void updateHistory();`
  - Protected: `remove(IMoving*)`, `moved(IMoving*)`; virtual dtor.

## Gotchas

- `getSleeping()` semantics are inverted-looking: `stepsToSleep == 0` means **sleeping**.
- The manager holds `current` while notifying — callbacks that add/remove IMovings during `onMovingHeartbeat` must be iterator-safe (this is why `current` is a member).
- `isInContinousMotion` typo is part of the API surface.

## UNKNOWN

- Heartbeat sleep threshold (steps/time constants live in the .cpp).

## Cross-links

- Physics-side sleep: [SleepStage.md](SleepStage.md), [AssemblyHistory.md](AssemblyHistory.md), [Enum.md](Enum.md) (`AssemblyState`).
- Time type: Base [rbxTime.h](../../../Base/include/rbx/rbxTime.h.md); scoped_ptr: Base [Boost.hpp](../../../Base/include/rbx/Boost.hpp.md).
