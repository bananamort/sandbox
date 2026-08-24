# Network/Replicator.StreamJob.h

**Module**: Network (root) · **Type**: header (.h, 216 lines)

## Purpose

Declares `Replicator::StreamJob`, the server-side part-streaming job: a spiral `StreamRegionIterator` around the player's torso collects regions within min(client quota radius, server radius), packs instances+terrain into `StreamDataItem`s (JoinDataItem + region id + successor bitmask delta encoding), honors client instance quotas (`ItemTypeUpdateClientQuota` feedback), processes region/instance removal notices from clients, and tracks collected regions for replication filtering. Also declares `DeserializedStreamDataItem` for the client read path.

## API

```cpp
static const int kStreamCenterResetThreshold = 32*32;
enum RegionIteratorSuccessor { ITER_NONE=0, ITER_INCY=1, ITER_INCZ=2, ITER_INCX=3 }; // 2-bit delta codes

class Replicator::StreamJob : public ReplicatorJob, public ContactManagerSpatialHash::CoarseMovementCallback {
    StreamJob(Replicator&);
    void updateClientQuota(int diff, short maxRegionRadius);   // from ClientCapacityUpdateItem
    int getClientInstanceQuota();
    bool isRegionCollected(id);  bool isRegionInPendingStreamItemQueue(id);
    bool isInStreamedRegions(Extents);  bool isAreaInStreamedRadius(center, r);
    void setupListeners(Player*);            // spawning/characterAdded/torso-changed → recenter
    void adjustSimulationOwnershipRange(Region2::WeightedPoint*);
    void setReady(bool)/getReady();          // flipped after top containers sent
    void readRegionRemoval(BitStream&); void readInstanceRemoval(BitStream&);
    void addInstanceToRegularQueue(instance); addInstanceAndDescendantsToRegularQueue(instance);
    void sendPackets(int maxPackets);
    void coarsePrimitiveMovement(Primitive*, const UpdateInfo&);   // parts leaving streamed set re-queue
    StreamRegion::Id lastSentRegionId;                              // shared with items for delta coding
};

class Replicator::StreamJob::StreamDataItem : public JoinDataItem {
    write(BitStream&) override;              // ItemTypeStreamData: successorBits|regionId, terrain, join data
    static shared_ptr<DeserializedStreamDataItem> read(Replicator&, BitStream&);
};
class DeserializedStreamDataItem : public DeserializedItem { id; deserializedJoinDataItem; successorBitMask; process(...); };
```

## Usage

Created per ServerReplicator when `Workspace::getNetworkStreamingEnabled()`; started (`setReady(true)` + initial `sendPackets(-1)`) once top containers are sent.

## Gotchas

- The successor bitmask lets consecutive region ids be sent as 2 bits instead of 12 bytes.
- Quota interplay: server clamps to the smaller of client-requested and server-max radius; quota diff ≤0 clears pending queues on the client side.
