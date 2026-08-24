# PhysicsService.cpp

## Purpose

Implements `PhysicsService`, a per-DataModel service tracking which assemblies currently have simulated physics ("E-physics" ownership), and buffering touch pairs between physics steps and network sends. It listens to SendPhysics on/off signals, Workspace's stepTouch, player-count changes, and heartbeats; exposes `assemblyAddingSignal`/`assemblyRemovedSignal` and `getTouches` to the replication layer.

## Key types and API

No reflection descriptors in this TU — no script surface at all.

- Ctor/dtor: dtor asserts `parts.empty()` and both signal connections disconnected.
- `onServiceProvider(old, new)`: rewires four connections — `Workspace::stepTouch` → `onTouchStep`, `Network::Players::combinedSignal` → `onPlayersChanged`, `World::getSendPhysics()` `assemblyPhysicsOnSignal`/`OffSignal` → handlers (only if SendPhysics exists), plus heartbeat hookup via `onServiceProviderHeartbeatInstance`.
- `onAssemblyPhysicsOn(Primitive*)`: under WriteValidator — resolves PartInstance (asserts assembly root), forces `assembly->computeMaxRadius()`, fires `assemblyAddingSignal(shared PartInstance)`, intrusive-inserts into `parts` list, and when server-present adds an initial movement node (CF + velocity + now) so late joiners get state.
- `onAssemblyPhysicsOff(Primitive*)`: removes from `parts` (asserts linked), fires `assemblyRemovedSignal`.
- Touch pipeline: `onTouchStep(TouchPair)` inserts into `touchesReceiveList`; `onHeartbeat` swaps receive→send when send is empty but receive isn't, or after `touchSentCounter >= touchResetCount`; increments `touchSendListId`. `getTouches(out)` drains copies of the send list; `onTouchesSent()` counts.
- `onPlayersChanged`: on server, CHILD_ADDED/REMOVED of Players → `touchResetCount = getPlayerCount` (each connected client gets one full touch resend per reset window).

## Usage / reflection touchpoints

Pure engine plumbing consumed by Network replication ([Network physics senders](../../Network/) — SendPhysics signals) and Workspace stepping. Pairs with `PartInstance.md`, `Workspace.md` in this folder.

## Gotchas

- `touchResetCount` only updates on the SERVER (`backendProcessing`) — clients keep whatever default they initialized with header-side.
- Heartbeat swap logic requires touchesReceiveList non-empty to trigger; a fully empty cycle leaves the stale send list in place (intended dedup behavior).
- `iAmServer` is lazily latched inside onAssemblyPhysicsOn and never re-evaluated false afterwards.
- The dtor RBXASSERTs imply destruction order requirements (service must die before Workspace/SendPhysics).
- UNKNOWN: initial values of `touchResetCount`/`touchSentCounter` and member declarations live in PhysicsService.h outside this file.
