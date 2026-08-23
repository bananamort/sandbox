# Network/Replicator.ChangePropertyItem.h

**Module**: Network (root) · **Type**: header (.h, 48 lines)

## Purpose

Declares the property-change item (`Replicator::ChangePropertyItem`) and its deserialized form `DeserializedChangePropertyItem` (guid + descriptor + Variant value, plus the client-only `versionReset` flag consumed by PropSync).

## API

```cpp
class DeserializedChangePropertyItem : public DeserializedItem {
    Guid::Data id;
    shared_ptr<Instance> instance;          // NULL if unknown/unaccepted
    const Reflection::PropertyDescriptor* propertyDescriptor;
    Reflection::Variant value;
    bool versionReset;                      // client only (PropSync::Slave)
    void process(Replicator&);              // → replicator.readChangedPropertyItem(this)
};

class Replicator::ChangePropertyItem : public PooledItem {
    ChangePropertyItem(Replicator*, const shared_ptr<const Instance>&, const PropertyDescriptor&);
    bool write(RakNet::BitStream&);
    static shared_ptr<DeserializedItem> read(Replicator&, RakNet::BitStream&);
};
```

## Usage

Queued from `Replicator::onPropertyChanged` (front-of-queue for the target player's own character parts); `pendingChangedPropertyItems` dedupe is keyed on (descriptor, instance) and erased at write time.

## Gotchas

- The dedupe means only the latest change per property is queued — but once written the entry is removed even if a newer local change arrived during serialization.
