# Network/Replicator.EventInvocationItem.h

**Module**: Network (root) · **Type**: header (.h, 41 lines)

## Purpose

Declares the remote-event invocation item: `Replicator::EventInvocationItem` (instance + descriptor + captured args) and `DeserializedEventInvocationItem` (resolved instance/descriptor + heap-allocated `EventInvocation`, ref args kept as guids).

## API

```cpp
class DeserializedEventInvocationItem : public DeserializedItem {
    shared_ptr<Instance> instance;
    const Reflection::EventDescriptor* eventDescriptor;
    shared_ptr<Reflection::EventInvocation> eventInvocation;
    void process(Replicator&);   // → replicator.readEventInvocationItem(this)
};

class Replicator::EventInvocationItem : public PooledItem {
    EventInvocationItem(Replicator*, const shared_ptr<Instance>&,
                        const Reflection::EventDescriptor&, const Reflection::EventArguments&);
    bool write(RakNet::BitStream&);
    static shared_ptr<DeserializedItem> read(Replicator&, RakNet::BitStream&);
};
```

## Usage

Queued from `Replicator::onEventInvocation` (via combined signal EVENT_INVOCATION); read path resolves ref-typed args later (`resolveRefTypes=false` at deserialize).

## Gotchas

- Write silently no-ops when the instance left replication, the event id is dictionary-outdated, or `isEventRemoved` (legacy schema).
