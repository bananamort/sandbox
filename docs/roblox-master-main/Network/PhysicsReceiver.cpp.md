# Network/PhysicsReceiver.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 875 lines)

## Purpose

Implements the shared physics-decode machinery of `PhysicsReceiver` (see PhysicsReceiver.h): mechanism/assembly/PV/motor/touch wire decoding, `setPhysics` application with filtering and interpolation-sample insertion, movement-history (path-based movement) reconstruction, and the debug adorn renderer.

## API (key functions)

```cpp
void DeserializedTouchItem::process(Replicator&);          // defers touch pairs to physicsReceiver
void PhysicsReceiver::receiveMechanismCFrames(...);         // streaming cframe-only path
void PhysicsReceiver::receiveMechanism(...);                // full mechanism decode
void PhysicsReceiver::setPhysics(const MechanismItem&, const RemoteTime&, RakNet::TimeMS lagInMs, int numNodesInHistory);
bool PhysicsReceiver::receivePart(shared_ptr<PartInstance>&, RakNet::BitStream&);   // false == packet end tag
bool PhysicsReceiver::receiveRootPart(...);                 // + grounded/distributed filters
void PhysicsReceiver::processTouchPair(const TouchPair&);   // reportTouch/Untouch + PhysicsService::onTouchStep
void PhysicsReceiver::renderPartMovementPath(Adorn*);       // debug stars/lines/labels
```

Notable behavior:
- Movement history: nodes are deltas decompressed via `MovementHistory::decompress(x, precisionLevel)` and 2ms-quantized intervals; accumulated into a `nodeStack` of `TimedCF` and replayed newest-first into `part->addInterpolationSample`, skipping nodes older than `getLastUpdateTime()`.
- Cross-packet compression: first history node is the baseline CFrame (rotation-only PV read), node[1] derives linear velocity from the first delta.
- `setPhysics` filters: `replicator->filterPhysics(part)`, `Assembly::isAssemblyRootPrimitive`, `computeIsGrounded()`; then `a->setPhysics(motorAngles, pv)`, `setNetworkHumanoidState` on assembly 0 only.
- Client path honors `DFFlag::HumanoidFloorPVUpdateSignal` to fire `onPositionUpdatedByNetworkSignal`; dead `isLagCompenstated=false` branch contains velocity extrapolation code.
- Touch logging uses `MESSAGE_SENSITIVE` with `RakNetAddressToString(replicator->remotePlayerId)`.

## Usage

Base for Direct/Interpolating receivers; `ID_PHYSICS_TOUCHES` handling; `DeserializedTouchItem::process` is invoked from the deferred-deserialized-item queue (see Replicator item pipeline).

## Gotchas

- Magic numbers: `getTotalNumMovementWayPoint() == 123456` clears waypoints each packet; `%7 == 0` toggles velocity debug adorn.
- `receivePart` returning `false` is the packet-end sentinel — a NULL instance reference mid-packet also resets the part but returns true.
- Motor count > 50 logs a warning when `printPhysicsErrors` is on.
- `readVelocity` zeroes velocity entirely unless `settings().distributedPhysicsEnabled`.
