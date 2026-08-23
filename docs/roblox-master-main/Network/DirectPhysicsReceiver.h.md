# Network/DirectPhysicsReceiver.h

**Module**: Network (root) · **Type**: header (.h, 20 lines)

## Purpose

Declares `DirectPhysicsReceiver`, the simplest concrete `PhysicsReceiver`: applies incoming physics packets immediately (no interpolation buffering), reusing a single `MechanismItem tempItem` scratch buffer per packet.

## API

```cpp
class DirectPhysicsReceiver : public PhysicsReceiver {
    MechanismItem tempItem;
public:
    DirectPhysicsReceiver(Replicator* replicator, bool isServer);
    virtual void receivePacket(RakNet::BitStream& bitstream, RakNet::Time timeStamp,
                               ReplicatorStats::PhysicsReceiverStats* stats);
};
```

## Usage

Instantiated by Replicator when physics interpolation is disabled; the `ID_PHYSICS` dispatch path calls `receivePacket`.

## Gotchas

- `tempItem` is shared across mechanisms within one packet — data is consumed by `setPhysics` before the next mechanism overwrites it.
