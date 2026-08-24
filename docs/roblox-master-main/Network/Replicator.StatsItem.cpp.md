# Network/Replicator.StatsItem.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 154 lines)

## Purpose

Implements StatsItem serialization: aggregates stats across **all sibling Replicators** under the same parent (Server), writes versioned payload — v2: aggregated TaskScheduler job rows (`name, dutyCycle, stepsPerSec, stepTime`, end-flagged) then ScriptContext script stats (`name, activity, invocationCount`); v1: average ping, physics FPS, data/physics KB/s (approximations), data throughput ratio. Read delegates to `ClientReplicator::readStats`.

## API

```cpp
static void writeTaskSchedulerStats(DataModel*, BitStream&);
static void writeScriptStats(DataModel*, BitStream&);
bool StatsItem::write(BitStream&);            // switch(version) with fall-through 2→1
static shared_ptr<DeserializedItem> StatsItem::read(Replicator&, BitStream&);
void DeserializedStatsItem::process(Replicator&);   // fires ClientReplicator::statsReceivedSignal
```

## Usage

See header. Jobs are filtered to those arbitrated by this DataModel and averaged when several share a name.

## Gotchas

- `totalSentDataItems / totalNewDataItems` divides by zero if no new items were ever counted (floats → inf, serialized as inf).
- The `default:` case is empty — unknown versions write nothing after the type byte.
