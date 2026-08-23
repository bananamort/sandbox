# Network/Marker.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 31 lines)

## Purpose

Implements `RBX::Network::Marker` (see Marker.h): assigns a process-wide monotonic `id`, prevents parenting, and fires the `Received` reflection event when the marker completes its client→server→client round trip.

## API

```cpp
const char* const RBX::Network::sMarker = "NetworkMarker";
Reflection::EventDesc<Marker, void()> event_Returned(&Marker::receivedSignal, "Received");
static rbx::atomic<int> ctr;              // id source
Marker::Marker();                          // returned=false, id=++ctr, lockParent()
void Marker::fireReturned();               // receivedSignal()
```

## Usage

- `fireReturned()` is invoked by the replication layer when the marker instance arrives back from the remote side.
- The `Received` event is visible through the reflection system as `Marker.Received`.

## Gotchas

- `fireReturned()` has a `TODO: Memoize the result and handle new connections using a Future system` — the signal is one-shot per marker object; late subscribers miss it.
- `id` is process-global via a function-static atomic, so ids are not unique across processes (do not use as a network identity).
- `lockParent()` in the constructor means any Lua/C++ attempt to reparent will fail.
