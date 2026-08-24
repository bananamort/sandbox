# Network/Replicator.StatsItem.h

**Module**: Network (root) · **Type**: header (.h, 330 lines)

## Purpose

Declares the server→client performance stats item (`STATS_ITEM_VERSION 2`), its deserialized form (a `Reflection::ValueTable` surfaced via `ClientReplicator::statsReceivedSignal`), plus the two big StatsService subtrees: `RakStatsItem` (raw RakNetStatistics binding: per-priority send buffers, byte counters, packetloss, bandwidth/congestion limits) and `Replicator::Stats` (per-connection view over `ReplicatorStats`: ping, queues, data/cluster/physics/touch packet rates+sizes+throttles, per-category data-type breakdown, physics receiver lag/buffer depth).

## API

```cpp
#define STATS_ITEM_VERSION 2

class DeserializedStatsItem : public DeserializedItem {
    shared_ptr<Reflection::ValueTable> stats;
    void process(Replicator&);   // rbx_static_cast<ClientReplicator> → statsReceivedSignal(stats)
};

class Replicator::StatsItem : public Item {
    StatsItem(Replicator*, int version);
    bool write(RakNet::BitStream&);   // v2 adds task-scheduler job stats + script stats before v1 block
    static shared_ptr<DeserializedItem> read(Replicator&, BitStream&);
};

class RakStatsItem : public Stats::Item { RakStatsItem(const RakNet::RakNetStatistics*); };
class Replicator::Stats : public RBX::Stats::Item {
    size_t instanceCount, instanceBits;   // fed by readInstanceNew for avg instance size
    Stats(const shared_ptr<const Replicator>&);
    virtual void update();
};
```

## Usage

- Server: `ID_REQUEST_STATS` toggles a `Replicator::SendStatsJob` that periodically queues StatsItems.
- Client: `ClientReplicator::readStats` parses jobs/scripts/summary tables; the Dev-console "Server Stats" UI consumes them.

## Gotchas

- The v1 aggregate math is sloppy by design: `dataPacketsTotal * dataSizeTotal / 1000` multiplies a rate by an average size rather than summing true KB/s; division by `numChildren` includes non-replicator children.
- `writeScriptStats` flips `setCollectScriptStats(true)` permanently on first request.
