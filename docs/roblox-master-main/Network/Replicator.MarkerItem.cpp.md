# Network/Replicator.MarkerItem.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 57 lines)

## Purpose

Implements `[ItemTypeMarker][int id]`. Write is gated on `isInitialDataSent()` and fires `replicator.onSentMarker(id)` (clears `ServerReplicator::waitingForMarker`). Read just captures the id; `processMarker` pops the matching `incomingMarkers` front and fires `Marker::fireReturned`.

## API

```cpp
bool MarkerItem::write(BitStream&);   // initial-data gate + onSentMarker
static shared_ptr<DeserializedItem> MarkerItem::read(Replicator&, BitStream&);
```

## Usage

See header; used by Studio/tests (`Replicator::sendMarker` reflection `SendMarker`) to detect replication completion points.

## Gotchas

- `processMarker` asserts the returned id matches the queue front — interleaved markers from multiple senders would violate FIFO assumptions.
