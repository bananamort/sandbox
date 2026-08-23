# Network/Replicator.ChangePropertyItem.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 88 lines)

## Purpose

Implements property-change wire items: write delegates to `Replicator::writeChangedProperty` (`[type][guid][propId][value]`, server adds PropSync `versionReset` bit); read resolves the instance ref + descriptor (with legacy-client `ProcessOutdatedChangedProperty` skip), reads `versionReset` on clients only, then deserializes the value into a Variant without touching the DataModel.

## API

```cpp
bool ChangePropertyItem::write(BitStream&);   // erases pending dedupe entry; skips if instance no longer replicated
static shared_ptr<DeserializedItem> ChangePropertyItem::read(Replicator&, BitStream&);
void DeserializedChangePropertyItem::process(Replicator&);
```

## Usage

Applied later by `Replicator::readChangedPropertyItem` under the receive job's lock; NULL instance values are tolerated (unknown guid) and dropped there.

## Gotchas

- Class mismatch between sender and receiver throws "Bad re-binding prop" — a hard protocol violation.
- Value deserialization passes `preventBounceBack=false` because bounce-back is enforced at process time instead.
