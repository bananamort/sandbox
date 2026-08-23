# Network/DirectPhysicsReceiver.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 153 lines)

## Purpose

Implements `DirectPhysicsReceiver::receivePacket` (see DirectPhysicsReceiver.h): loops over mechanisms in one `ID_PHYSICS` packet, discards stale packets per-part, updates `part->raknetTime`, applies physics via `setPhysics`, and maintains `interpolationDelay`/`lastUpdateTime` on clients.

## API / behavior

```cpp
void DirectPhysicsReceiver::receivePacket(RakNet::BitStream& inBitstream,
    RakNet::Time timeStamp, ReplicatorStats::PhysicsReceiverStats* stats);
```

Flow:
1. If `SFFlag::getPhysicsPacketSendWorldStepTimestamp()`, read an explicit `interpolationTimestamp`; else use RakNet delivery `timeStamp`. Future timestamps are clamped to now when `DFFlag::PhysicsSenderUseOwnerTimestamp`.
2. Loop: streaming mode reads a `done` flag then either a cframe-only mechanism (`receiveMechanismCFrames`) or a root part; non-streaming reads root parts until the stream ends.
3. Client-side staleness: drop part if `localTime < part->getLastUpdateTime()` ("Discard old packet") or stored `raknetTime` is newer than this packet's timestamp ("Physics-in old packet"); gated on `settings().printPhysicsErrors` for logging.
4. On "Torso" root parts, samples `stats->details.characterAnim(Size)` — character animation bandwidth telemetry.
5. Applies state via `setPhysics(tempItem, remoteSendTime, deltaTime, numNodesInHistory)`; clients set `part->setInterpolationDelay(...)` (NetworkPing-derived under `DFFlag::CleanUpInterpolationTimestamps`) and `setLastUpdateTime(localTime)`.

## Usage

Registered as the replicator's physics receiver for direct (non-interpolated) mode; see `Replicator.cpp` construction sites and `ID_PHYSICS` handling.

## Gotchas

- Two independent staleness checks (RBX time vs raknet time) can both discard parts; only one prints when enabled.
- `BOOST_STATIC_ASSERT(sizeof(RakNet::Time) == sizeof(part->raknetTime))` pins the timestamp type to PartInstance's field.
- In streaming+cframeOnly mode there is no part staleness check — frames go straight through `receiveMechanismCFrames`.
