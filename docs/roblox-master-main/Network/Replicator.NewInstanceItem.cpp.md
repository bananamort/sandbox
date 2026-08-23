# Network/Replicator.NewInstanceItem.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 231 lines)

## Purpose

Implements live instance-create serialization: `[ItemTypeNew][guid][classId][deleteOnDisconnect][non-cacheable props (dict)][cacheable props (cache-or-write)][parent guid]`. Deserialization constructs or rebinds the instance, reads properties either directly into out-of-DataModel instances or defers via `PropValuePairList`, and resolves the parent.

## API

```cpp
bool NewInstanceItem::write(BitStream&);   // removed-class instances write nothing; pendingNewInstances guard
static bool NewInstanceItem::read(Replicator&, BitStream&, bool isJoinData, DeserializedNewInstanceItem&); // false if ProcessOutdatedInstance absorbed it
static shared_ptr<DeserializedItem> NewInstanceItem::read(...);  // wrapper
void DeserializedNewInstanceItem::process(Replicator&);
```

## Usage

- Cache interplay: cacheable property block is fetched from `instancePacketCache` when clean; on miss it's rewritten and the cache updated (`update(instance, bitStream, bits, false)`).
- Rebinding a known GUID to a different class throws "Bad re-binding in deserialize new instance".
- Unknown classes are handled by `ProcessOutdatedInstance` (legacy-client schema skip), returning false and producing no item.

## Gotchas

- `deleteOnDisconnect` comes from `Replicator::remoteDeleteOnDisconnect` at **write time**, so ownership semantics are fixed when queued, not when sent.
- Property values for existing instances are stored as variants and only applied in `readInstanceNewItem` under the DataModel lock.
