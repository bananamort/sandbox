# Network/Item.h

**Module**: Network (root) · **Type**: header (.h, 128 lines)

## Purpose

Core replication item abstractions: `Item` (serializable outbound replication unit with a compact type tag), `PooledItem` (mempool-enabled variant), `ItemQueue` (intrusive FIFO of Items with re-entrancy asserts), and `DeserializedItem` (inbound counterpart processed later on the DataModel thread). Every `Replicator.*Item.*` file in this directory implements one ItemType from here.

## API

```cpp
class Item : boost::noncopyable, public ItemHook /*intrusive list hook*/ {
    enum ItemType {
        ItemTypeEnd=0, Delete, New, ChangeProperty, Marker, Ping, PingBack,
        EventInvocation, RequestCharacter, Rocky /*cheat reporting*/,
        PropAcknowledgement, JoinData, UpdateClientQuota, StreamData,
        RegionRemoval, InstanceRemoval, Tag, Stats, Hash, ItemTypeMaxValue=18 };
    Replicator& replicator;
    RBX::Time timestamp;
    virtual bool write(RakNet::BitStream& bitStream) = 0;
    static void writeItemType(RakNet::BitStream&, ItemType);
    static void readItemType(RakNet::BitStream&, ItemType&);
};

class PooledItem : public Item, public AutoMemPool::Object;

class ItemQueue {  // intrusive list; NOT thread safe; re-entrancy watched via inCode
    bool empty() const; size_t size() const;
    RBX::Time::Interval head_wait() const; RBX::Time head_time() const;
    void deleteAll(); void clear();
    bool pop_if_present(Item*&); void push_back(Item*); void push_front(Item*);
    void push_front_preserve_timestamp(Item*);
    ItemList::iterator begin()/end();
};

class DeserializedItem {  // inbound
    Item::ItemType type; Item::ItemType getType();
    virtual void process(Replicator&) = 0;
};
```

## Usage

The Item pipeline is the backbone of `ID_DATA` packets: sender-side `write()` implementations append to the replicator's ItemQueues (see `Replicator.SendDataJob`, `Replicator.*Item.cpp`); receiver-side deserialization produces `DeserializedItem`s queued for processing (`Replicator.ProcessPacketsJob.h`).

## Gotchas

- Item ids are a variable 2-bit/2+5-bit encoding (see Item.cpp) — ItemTypeMaxValue must stay < 19.
- `ItemQueue` is explicitly not thread-safe ("Right now NOT thread safe. Just here for safety watch").
- `clear()` does NOT delete items — use `deleteAll()` to avoid leaks.
