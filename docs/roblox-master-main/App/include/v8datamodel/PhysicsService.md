# App/include/v8datamodel/PhysicsService.h

## Purpose

`PhysicsService` — non-creatable service that owns the engine-side registry of simulated parts (`Intrusive::Set<PartInstance, PhysicsService>` — the hook every PartInstance embeds), aggregates touch pairs from the physics world into swap-lists consumed by network physics senders, tracks assembly add/remove, and runs a Heartbeat tick.

## Declared API

`class PhysicsService : public DescribedNonCreatable<PhysicsService, Instance, sPhysicsService>, public Service, public HeartbeatInstance`

- Typedefs: `typedef RBX::Intrusive::Set<PartInstance, PhysicsService> Parts; typedef Parts::Iterator PartsIt;`
- Inline ctor sets `touchSendListId(0)`, `touchResetCount(1)`, `iAmServer=false`, `setName("PhysicsService")`; dtor out-of-line.
- Signals: `rbx::signal<void(shared_ptr<Instance>)> assemblyAddingSignal`, `assemblyRemovedSignal`.
- Part-set iteration: `int numSenders() {return parts.size();}`, `PartsIt begin()/end()`.
- Touch pipeline: `void onTouchStep(const TouchPair&)`, `size_t pendingTouchCount()`, `int getTouchesId()`, `void getTouches(std::list<TouchPair>& out)`, `void onTouchesSent()`.
- Heartbeat: `/*override*/ void onHeartbeat(const Heartbeat& event)`.
- Players tracking: `void onPlayersChanged(Instance::CombinedSignalType type, const ICombinedSignalData* data)` ("used to determine number of physics senders").
- Private state: `bool iAmServer`; `Parts parts`; `boost::unordered_set<TouchPair> touchesSendList/touchesReceiveList` (comment: send list "used by physics senders, swaps with receive list"); scoped_connection `touchesConnection`; `rbx::atomic<int> touchSentCounter`; ints `touchResetCount`, `touchSendListId`; connection `playersChangedConnection`; `ConcurrencyValidator concurrencyValidator`; assembly on/off connections + handlers `onAssemblyPhysicsOn(Primitive*)/onAssemblyPhysicsOff(Primitive*)`; `onServiceProvider` override.

## Gotchas

- PartInstance inherits this service's intrusive-set hook — service lifetime and part registration are entangled at the instance level.
- Send/receive touch lists are swapped, not copied — consumers must pair getTouches with onTouchesSent or starve/duplicate touch delivery.
- ConcurrencyValidator present: physics-touch paths are concurrency-checked in dev builds; don't casually move calls across threads.
- iAmServer is a plain non-atomic bool, assigned only in the inline ctor body (`iAmServer = false`) — any later server/client transition happens out-of-line.

## UNKNOWN

- Which component fires `onTouchStep` per step (V8World contact manager, out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/PhysicsService.md](../../v8datamodel/PhysicsService.md).
- Registered parts: [PartInstance.md](PartInstance.md); world side: V8World SendPhysics; sibling services: [Workspace.md](Workspace.md), [Stats.md](Stats.md).
