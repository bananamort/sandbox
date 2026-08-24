# Network/Replicator.StreamJob.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 950 lines)

## Purpose

Implements the streaming job step loop: recenter on the player's torso CFrame (`resetCenter` with `kStreamCenterResetThreshold=32²` hysteresis), collect instances from the next uncollected spiral region within a per-step budget derived from the client quota, adapt `numPacketsPerStep` (halve/double) to RakNet buffer health sampled every second, then flush high-priority and regular `StreamDataItem`s via an `ItemSender`. Handles client GC notices (`readRegionRemoval`/`readInstanceRemoval`) — dropping replication data or re-sending instances whose region is still collected ("ships-in-the-night" resolution).

## API

```cpp
DFInt::MaxStreamPacketsPerStep(16), MaxServerStreamRegionRadius(16),
StreamJobPriorityAmplifierRadius(0), MaxConsecutiveStreamJobWorkLoad(1)

bool StreamDataItem::write(BitStream&);   // 2-bit successor code (ITER_INCY/Z/X) else full 12-byte id
static shared_ptr<DeserializedStreamDataItem> StreamDataItem::read(...);
TaskScheduler::StepResult stepDataModelJob(const Stats&);
void updateClientQuota(int diff, short maxRegionRadius);
void readRegionRemoval(BitStream&); void readInstanceRemoval(BitStream&);
bool collectPartsFromNextRegion(bool highPriority);   // spatial-hash query + character-part skip
void sendPackets(int maxPackets);                     // syncTime = pendingItems head time ordering guard
void coarsePrimitiveMovement(Primitive*, const UpdateInfo&);
```

## Usage

See header. Terrain streams through `Replicator::sendClusterChunk(regionId)` once per item before its parts.

## Gotchas

- Collection pauses entirely if the client hasn't acknowledged data for >1 s; pre-ready items use `MaxJoinDataSizeKB*1000` budgets instead of MTU.
- `receiveInstanceGcMessage` re-sends when the instance's root part still lies inside collected regions — trusting client GC only for genuinely streamed-out parts.
- Priority amplifier (√ of radius deficit) boosts scheduler error when the client is starved but has quota.
