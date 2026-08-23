# Network/Replicator.DeleteInstanceItem.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 103 lines)

## Purpose

Implements delete serialization: `[ItemTypeDelete][guid]`. Read just extracts the guid; actual unparenting happens in `Replicator::readInstanceDeleteItem` → `deleteInstanceById` (legality-checked, pending-reference resolution, `removingInstance` suppression).

## API

```cpp
DeleteInstanceItem(Replicator*, instance);   // id = replicator->extractId(instance); cache->remove(instance)
bool write(BitStream&);                      // invalid id ⇒ log only; runtime_error inside sendId caught+logged
static shared_ptr<DeserializedItem> read(Replicator&, BitStream&);
void DeserializedDeleteInstanceItem::process(Replicator&);
```

## Usage

Stats: `PACKET_TYPE_InstanceDelete` sampled on both sides when `settings().trackDataTypes`.

## Gotchas

- `write` swallows `std::runtime_error` from `sendId` (unknown-instance case) and still returns true — the item is consumed either way.
