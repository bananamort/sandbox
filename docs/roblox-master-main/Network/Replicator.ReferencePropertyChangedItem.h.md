# Network/Replicator.ReferencePropertyChangedItem.h

**Module**: Network (root) · **Type**: header (.h, 31 lines)

## Purpose

Declares `Replicator::ReferencePropertyChangedItem`, the pooled item for ref-type property changes (e.g. joints' Part0/Part1, Parent moves between replication containers). The new value's GUID is captured at construction time so later mutations of the reference don't corrupt the queued item.

## API

```cpp
class Replicator::ReferencePropertyChangedItem : public PooledItem {
    ReferencePropertyChangedItem(Replicator*, const shared_ptr<const Instance>&,
                                 const Reflection::RefPropertyDescriptor&);
    bool write(RakNet::BitStream&);   // → replicator.writeChangedRefProperty(...)
private:
    bool newValueIsNull;              // (unused field; nullness encoded via null scope)
    Guid::Data newValueGuid;
};
```

## Usage

Queued from `Replicator::onParentChanged` (reparent within containers) and `onPropertyChanged` for ref descriptors.

## Gotchas

- `newValueIsNull` is set nowhere — dead member; null refs are represented by a null guid scope in `newValueGuid`.
