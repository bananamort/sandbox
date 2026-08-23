# Network/Replicator.NewInstanceItem.h

**Module**: Network (root) · **Type**: header (.h, 63 lines)

## Purpose

Declares the live (non-join) instance-creation item `Replicator::NewInstanceItem`, its deserialized form `DeserializedNewInstanceItem` (which carries either a freshly constructed Instance or a deferred `PropValuePairList` for instances that already exist), and the shared `PropValuePair` struct.

## API

```cpp
struct PropValuePair { const Reflection::PropertyDescriptor* descriptor; Reflection::Variant value; };

class DeserializedNewInstanceItem : public DeserializedItem {
    PropValuePairList propValueList;   // values applied later when instance is in DataModel
    Guid::Data id, parentId;
    const Reflection::ClassDescriptor* classDescriptor;
    shared_ptr<Instance> instance, parent;
    bool deleteOnDisconnect;
    void reset();
    void process(Replicator&);         // → replicator.readInstanceNewItem(this, false)
};

class Replicator::NewInstanceItem : public PooledItem {
    NewInstanceItem(Replicator*, shared_ptr<const Instance>);
    bool write(RakNet::BitStream&);
    static bool read(Replicator&, BitStream&, bool isJoinData, DeserializedNewInstanceItem&);
    static shared_ptr<DeserializedItem> read(Replicator&, BitStream&, bool isJoinData);
private:
    bool useStoredParentGuid;          // false only for Player-under-Players hack
    Guid::Data parentIdAtItemCreation; // parent guid captured at queue time
};
```

## Usage

- Created by `Replicator::addToPendingItemsList` on CHILD_ADDED; registers into `pendingNewInstances` and the instance packet cache.
- Read path shared with join data (`isJoinData=true`) by JoinDataItem.

## Gotchas

- Parent-guid capture exists to fix a parent-desync race; explicitly bypassed for local Player under Players during initial sync ("HACK" comment).
