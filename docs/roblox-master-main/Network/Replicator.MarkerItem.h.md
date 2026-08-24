# Network/Replicator.MarkerItem.h

**Module**: Network (root) · **Type**: header (.h, 32 lines)

## Purpose

Declares the marker round-trip item. A `Marker` instance (created by `Replicator::sendMarker`) is echoed back through the replication stream so callers can await full queue drain (`Marker::fireReturned` in `Replicator::processMarker`).

## API

```cpp
class DeserializedMarkerItem : public DeserializedItem {
    int id;
    void process(Replicator&);   // → replicator.readMarkerItem(this)
};

class Replicator::MarkerItem : public Item {
    MarkerItem(Replicator*, int id);
    bool write(RakNet::BitStream&);
    static shared_ptr<DeserializedItem> read(Replicator&, RakNet::BitStream&);
};
```

## Usage

Two entry points create MarkerItems: reply side queues one on `ID_REQUEST_MARKER` packets (Replicator::OnReceive), and `ServerReplicator` uses markers via waitingForMarker/onSentMarker bookkeeping.

## Gotchas

- Write refuses (returns false, stays queued) until `replicator.isInitialDataSent()` — markers are ordering barriers.
