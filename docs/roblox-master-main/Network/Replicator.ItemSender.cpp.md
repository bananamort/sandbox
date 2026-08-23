# Network/Replicator.ItemSender.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 80 lines)

## Purpose

Implements `Replicator::ItemSender`: lazily opens an `ID_DATA` packet (`openPacket`), appends items via `Item::write`, terminates with `Item::ItemTypeEnd` and sends on DATA_CHANNEL/DATAMODEL_RELIABILITY at the settings' data priority when flushed (destructor or bitstream-full rollover).

## API

```cpp
void ItemSender::openPacket();   // allocates BitStream, writes ID_DATA byte
void ItemSender::closePacket();  // writes ItemTypeEnd, rakPeer->Send, samples dataPacketsSent(Size)
ItemSender::SendStatus ItemSender::send(Item& item);  // SEND_BITSTREAM_FULL if >= maxStreamSize or item refuses
int ItemSender::getNumberOfBytesUsed() const;
```

## Usage

Called from `Replicator::sendItems` loop; stats sampled per packet (`dataPacketsSent`, `dataPacketsSentSize`).

## Gotchas

- A zero-item stream never sends (closePacket checks bytes>0), so no idle keepalive packets come from here — pings are separate items.
