# Network/Replicator.EventInvocationItem.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 127 lines)

## Purpose

Implements event-invocation wire items: `[ItemTypeEventInvocation][guid][eventId][argCount][args…]` with string args going through the per-event shared string dictionary. Read resolves instance+descriptor (with `ProcessOutdatedEventInvocation` legacy skip), throws on class/descriptor owner mismatch ("Bad re-binding event"), then deserializes args without resolving ref types (stored as `Guid::Data` variants).

## API

```cpp
bool EventInvocationItem::write(BitStream&);   // stats PACKET_TYPE_Event
static shared_ptr<DeserializedItem> EventInvocationItem::read(Replicator&, BitStream&);
void DeserializedEventInvocationItem::process(Replicator&);
```

## Usage

Processing happens in `Replicator::readEventInvocationItem`: legality check (`isLegalReceiveEvent`), guid→instance resolution of ref args, `instance->processRemoteEvent(descriptor, args, sourceAddress)`, and rebroadcast for broadcast events via `rebroadcastEvent`.

## Gotchas

- Unknown instance guids produce a NULL-instance invocation that is still deserialized (byte-count correctness) but dropped at process time.
