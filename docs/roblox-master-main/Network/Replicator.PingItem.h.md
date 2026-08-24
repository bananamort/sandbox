# Network/Replicator.PingItem.h

**Module**: Network (root) · **Type**: header (.h, 38 lines)

## Purpose

Declares the data-channel ping item — the keepalive that also smuggles the client's anti-cheat bitfields (`sendStats`, protocol ≥34 `extraStats`) to the server. `PingItem` writes; a peer answers via `PingBackItem` with the same timestamp.

## API

```cpp
class DeserializedPingItem : public DeserializedItem {
    bool pingBack;
    RakNet::Time time;
    unsigned int sendStats;
    unsigned int extraStats;   // proto ≥34
    void process(Replicator&); // → replicator.readDataPingItem(this)
};

class Replicator::PingItem : public PooledItem {
    PingItem(Replicator*, RakNet::Time time, unsigned int extraStats);
    bool write(RakNet::BitStream&);
    static shared_ptr<DeserializedItem> read(Replicator&, RakNet::BitStream&);
};
```

## Usage

Queued by `Replicator::sendDataPing` (PingJob cadence) and by the Windows FilterSinglePass call-check path (scorn flags in extraStats). Server side: `processDataPing` samples RTT or queues PingBackItem and updates `lastReceivedPingTime`.

## Gotchas

- The 13 hackFlag reads (`hackFlag0`..`hackFlag12`) are deliberately unrolled ("values need to be spread out in memory") under VMProtect virtualization; a mismatch between the two computations flags `kPingItem` on the apiToken.
- extraStats is conditionally bitwise-inverted based on `time & 0x20` (client non-RCC encodes, RCC server decodes) — a tiny moving-target obfuscation.
