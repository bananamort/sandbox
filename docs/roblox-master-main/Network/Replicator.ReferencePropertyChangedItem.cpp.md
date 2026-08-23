# Network/Replicator.ReferencePropertyChangedItem.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 33 lines)

## Purpose

Implements the ref-property item: constructor snapshots `desc.getRefValue(instance)`'s guid (or a null scope), write forwards to `Replicator::writeChangedRefProperty` which emits `[ItemTypeChangeProperty][guid][propId][refGuid-or-empty-scope]`.

## API

```cpp
ReferencePropertyChangedItem(Replicator*, instance, RefPropertyDescriptor&);
bool write(RakNet::BitStream&);
```

## Usage

See header; consumed by the generic ChangeProperty read path on the wire (same item type), where ref values deserialize into pending-reference resolution (`addPendingRef`).

## Gotchas

- Because the guid is captured eagerly, a reference that changes twice before flush sends two consistent snapshots — no coalescing with `pendingChangedPropertyItems` dedupe for ref props (they're inserted there too in `onPropertyChanged` but ref items bypass `ChangePropertyItem::write`'s erase).
