# Network/Replicator.ItemSender.h

**Module**: Network (root) · **Type**: header (.h, 38 lines)

## Purpose

Declares `Replicator::ItemSender`, the per-send-step packet builder that packs replication `Item`s into `ID_DATA` bitstreams up to the adjusted MTU and flushes them over the `ConcurrentRakPeer`.

## API

```cpp
class Replicator::ItemSender : boost::noncopyable {
    typedef enum { SEND_BITSTREAM_FULL = 0, SEND_OK } SendStatus;
    ItemSender(Replicator& replicator, ConcurrentRakPeer* rakPeer);
    ~ItemSender();                       // closes (flushes) any open packet
    SendStatus send(Item& item);
    int getNumberOfBytesUsed() const;
    bool sentItems;                      // true once any item was written
};
```

## Usage

Constructed fresh inside each `Replicator::sendItemsPacket` iteration; `sendItems(sender, queue)` pops items until `SEND_BITSTREAM_FULL` (item pushed back with preserved timestamp).

## Gotchas

- `maxStreamSize` is a "guesstimate" (`getAdjustedMtuSize()`); an item larger than one MTU is still written whole — RakNet split packets handle oversize (and trip the split-count GA alarm).
