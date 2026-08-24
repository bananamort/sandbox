# Network/Replicator.TagItem.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 69 lines)

## Purpose

Implements the tag item: `[ItemTypeTag][int id]`. On write, `readyCallback()` must pass (e.g. `Replicator::isInitialDataSent` for the top-containers tag) and `replicator.onSentTag(id)` fires server-side bookkeeping (physics sender start, player install scheduling). On read, dispatches to `ClientReplicator::readTagItem` → `processTag` (game-load signaling).

## API

```cpp
TagItem(Replicator*, int id, boost::function<bool()> readyCallback);
bool write(BitStream&);   // callback gate + onSentTag hook
static shared_ptr<DeserializedItem> read(Replicator&, BitStream&);
void DeserializedTagItem::process(Replicator&);
```

## Usage

See header; this is how the client learns "initial data done" and flips `canTimeout=true`.

## Gotchas

- `onSentTag` is called at **write** time, not send time — a queued-then-dropped tag would still trigger the hook.
