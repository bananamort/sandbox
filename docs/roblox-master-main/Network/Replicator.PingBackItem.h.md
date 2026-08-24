# Network/Replicator.PingBackItem.h

**Module**: Network (root) · **Type**: header (.h, 22 lines)

## Purpose

Declares the ping reply item: echoes the original ping timestamp so the pinger can compute RTT (`replicatorStats.dataPing`). Shares the wire format with PingItem but with `pingBack=true`.

## API

```cpp
class Replicator::PingBackItem : public PooledItem {
    PingBackItem(Replicator*, RakNet::Time time, unsigned int extraStats);
    bool write(RakNet::BitStream&);   // ItemTypePingBack, no read()/Deserialized form needed
};
```

## Usage

Queued by `Replicator::processDataPing` whenever a non-pingback ping arrives.

## Gotchas

- There is deliberately no deserializer — both read paths (`readDataPing`/`readDataPingItem`) treat ItemTypePing and PingBack identically via the `pingBack` bool.
