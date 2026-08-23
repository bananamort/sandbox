# Network/Marker.h

**Module**: Network (root) · **Type**: header (.h, 24 lines)

## Purpose

Declares `RBX::Network::Marker`, a non-creatable `Instance` subclass used as a replication round-trip token: the client requests a marker (`ID_REQUEST_MARKER` in PacketIds.h), it is replicated to the server and back, and when the copy returns `fireReturned()` fires `receivedSignal` so awaiting code knows a connection's data path is live.

## API

```cpp
class Marker : public RBX::DescribedNonCreatable<Marker, Instance, sMarker> {
public:
    Marker();
    const long id;                       // process-wide monotonic counter (atomic)
    rbx::signal<void()> receivedSignal;
    void fireReturned();
private:
    bool returned;  // == the marker has made the round-trip
};
extern const char* const sMarker;
```

## Usage

- Created by client-side replication code (see Replicator.cpp marker handling / `Replicator.MarkerItem.*` for wire transport).
- `receivedSignal` is exposed to Lua/reflection as event `"Received"` via `event_Returned` in Marker.cpp.

## Gotchas

- Constructor calls `this->lockParent()` — markers can never be parented under another object.
- The comment in Marker.cpp notes result memoization/Future handling was never implemented: only one outstanding round-trip pattern works reliably.
