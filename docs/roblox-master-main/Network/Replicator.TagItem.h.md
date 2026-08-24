# Network/Replicator.TagItem.h

**Module**: Network (root) · **Type**: header (.h, 31 lines)

## Purpose

Declares the replication "tag" item — an int marker in the item stream used as a completion barrier (e.g. `REPLICATED_FIRST_FINISHED_TAG`=12, `TOP_REPLICATION_CONTAINER_FINISHED_TAG`=13). The sender can gate transmission on a `readyCallback`.

## API

```cpp
class DeserializedTagItem : public DeserializedItem {
    int id;
    void process(Replicator&);   // rbx_static_cast to ClientReplicator → readTagItem
};

class Replicator::TagItem : public Item {
    TagItem(Replicator*, int id, boost::function<bool()> readyCallback);
    bool write(RakNet::BitStream&);
    static shared_ptr<DeserializedItem> read(Replicator&, RakNet::BitStream&);
};
```

## Usage

Server pushes TagItems after ReplicatedFirst descendants and after all top containers (see ServerReplicator::sendTop / addTopReplicationContainers); client reacts in `ClientReplicator::processTag`.

## Gotchas

- `DeserializedTagItem::process` hard-casts the replicator to `ClientReplicator` — tags are meaningless server→server.
- `write` returning false (callback not ready) leaves the tag queued for a later step.
