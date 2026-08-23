# Network/Replicator.JoinDataItem.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 242 lines)

## Purpose

Implements join-data serialization: batches pending instances into a preallocated bitstream (optionally served from `instancePacketCache`), byte-aligns, gzip-compresses at `DFInt::JoinDataCompressionLevel`, and prefixes a count. Deserialization mirrors it into `DeserializedNewInstanceItem`s for the deferred DataModel-thread apply.

## API

```cpp
SYNCHRONIZED_FASTFLAGVARIABLE(NetworkAlignJoinData, true)  // declared, unused here
bool JoinDataItem::canUseCache(const Instance*);   // client-owned or sleeping parts yes; scripts no
bool JoinDataItem::writeInstance(const Instance*, BitStream&); // [guid w/o dict][class id][deleteOnDisconnect][props All,no-dict][parent][align]
size_t JoinDataItem::writeInstances(BitStream&);   // cache-or-write loop, byte/step budget = sendBytesPerStep * ESTIMATED_COMPRESSION_RATIO
void JoinDataItem::addInstance(shared_ptr<const Instance>);
bool JoinDataItem::write(BitStream&);              // ItemTypeJoinData + count + gzip (+ optional JoinDataBonus padding)
static shared_ptr<DeserializedItem> JoinDataItem::read(Replicator&, BitStream&);
void DeserializedJoinDataItem::process(Replicator&);
```

## Usage

- `Replicator::addTopReplicationContainers` creates one JoinDataItem with `setBytesPerStep(DFLog::MaxJoinDataSizeKB*1000)`; every replicated instance's `replicationMethodFunc` lands here.
- Instances whose guid is no longer in `pendingNewInstances` are silently dropped (already serialized via another path).

## Gotchas

- `sendBytesPerStep` budget is compared against **uncompressed** bytes ×5 estimate; actual on-wire size differs.
- Removed-class instances return false from `writeInstance` and don't count toward `numWritten`, but still pop from the queue.
- `writeBonus` writes zeroed 64-byte blocks only while `bytes >= 64` — remainders below 64 bytes are dropped (intentional coarse padding).
