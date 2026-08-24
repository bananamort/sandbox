# Network/Replicator.GCJob.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 502 lines)

## Purpose

Implements the streaming GC step: samples player head CFrame (dead players freeze the GC center), smooths `workspace.renderingDistance` into `renderingRegionDistance`, re-sorts regions far→near on region-sized movement, then evicts: for each region, primitives from the spatial hash that no longer intersect any streamed region (excluding character parts) go through `streamOutInstance(part,false)` + joint cleanup, terrain cells stream out via `streamOutTerrain`, and a `RegionRemovalItem` (`[ItemTypeRegionRemoval][region][count][guids | gzip(guids) when > FInt::StreamOutCompressionIdListLengthThreshold=250]`) informs the server. Also defines `DFInt::JoinDataCompressionLevel(1)` and `DFInt::JoinDataBonus(0)` here.

## API

```cpp
FASTINT StreamOutCompressionIdListLengthThreshold = 250;  DFInt PartStreamingGCMinRegionLength=2;
class GCJob::RegionRemovalItem : Item { addInstance(instance); write → optional gzip at JoinDataCompressionLevel };
class GCJob::InstanceRemovalItem : Item { [ItemTypeInstanceRemoval][guid] };
void gcRegion(...); void gcPartInstance(...);
TaskScheduler::StepResult stepDataModelJob(const Stats&);   // budget 0.2/dataGCRate sec per pass
```

## Usage

See header; after each step it clamps the local Player's `MaxSimulationRadius` to `(gcRegionDistance-2.5)*cellSize`.

## Gotchas

- RegionRemovalItems are per-region ("TODO: batch regions into 1 item").
- Auto-joint nulling runs over JointsService descendants after collection (`streamOutAutoJointHelper`) with `removingInstance` suppression before final unparenting.
- The compression threshold compares against an int that can be negative to disable (`>= 0 &&`).
