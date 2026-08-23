# Network/Replicator.DeleteInstanceItem.h

**Module**: Network (root) · **Type**: header (.h, 43 lines)

## Purpose

Declares the instance-deletion item: `Replicator::DeleteInstanceItem` (carries the guid id extracted at construction, plus debug-only class/guid strings) and `DeserializedDeleteInstanceItem` (just the guid).

## API

```cpp
class DeserializedDeleteInstanceItem : public DeserializedItem {
    Guid::Data id;
    void process(Replicator&);   // → replicator.readInstanceDeleteItem(this)
};

class Replicator::DeleteInstanceItem : public PooledItem {
    DeleteInstanceItem(Replicator*, const shared_ptr<const Instance>&); // extracts IdSerializer::Id
    bool write(RakNet::BitStream&);
    static shared_ptr<DeserializedItem> read(Replicator&, RakNet::BitStream&);
};
```

## Usage

Queued from `Replicator::onParentChanged` when an instance leaves replication to a non-container parent; constructor also removes the instance from the packet cache.

## Gotchas

- If the id is invalid (never serialized), write only logs "~NULL" — the delete is silently dropped.
