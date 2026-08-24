# Network/Replicator.GCJob.h

**Module**: Network (root) · **Type**: header (.h, 105 lines)

## Purpose

Declares `ClientReplicator::GCJob`, the client-side streaming garbage collector: tracks received stream regions (`RegionsMap`+MRU `RegionList`), re-sorts by distance from the player's head when they move a region or memory turns critical, and evicts far regions — queuing `RegionRemovalItem`s (guid lists, optionally gzip-compressed) and `InstanceRemovalItem`s to tell the server what was dropped. Also registers as a `ContactManagerSpatialHash::CoarseMovementCallback` so parts that physically wander out of all streamed regions get their region marked for GC.

## API

```cpp
static const float kMaxRegionExpansionTimerLimit = 10.f;   // gc radius grows 1 region / 10 s
static const float kRenderingDistanceUpdateInterval = 1.f;
struct RegionInfo { float distance; int streamDistance; StreamRegion::Id id; computeRegionDistance(focus); };

class ClientReplicator::GCJob : public ReplicatorJob, public ContactManagerSpatialHash::CoarseMovementCallback {
    GCJob(Replicator&);                        // "Replicator GC Job", Write task, cyclic; hooks spatial hash + workspace renderingDistance
    void insertRegion(const StreamRegion::Id&);
    void coarsePrimitiveMovement(Primitive*, const UpdateInfo&);
    void render3dAdorn(Adorn*);                // red boxes for streamed regions
    bool pendingGC();                          // numRegionToGC > 0
    void evaluateNumRegionToGC();
    short getMaxRegionDistance();  bool updateMaxRegionDistance();
    void updateGcRegionDistance();
    void notifyServerGcingInstanceAndDescendants(shared_ptr<Instance>);
    void unregisterCoarseMovementCallback();
    int getNumRegionsToGC(); short getGCDistance(); int getNumRegions();
private:
    TaskScheduler::StepResult stepDataModelJob(const Stats&);  // at settings().getDataGCRate()
    void gcRegion(StreamRegion::Id, RegionRemovalItem*);
    void gcPartInstance(PartInstance*, RegionRemovalItem*);
    void setMaxSimulationRadius(float);
};
```

## Usage

Created in ClientReplicator when the server announces streaming (ID_SET_GLOBALS); feeds `updateClientCapacity` via `pendingGC`/`getMaxRegionDistance`.

## Gotchas

- GC target = half the streamed list but never below `kMinNumPlayableRegion`; forced (critical-memory) GC ignores the min-distance stop and loops until memory ≥ LIMITED.
- `notifyServerGcingInstanceAndDescendants` recurses one level per call (`visitChildren`, deliberately not descendants).
