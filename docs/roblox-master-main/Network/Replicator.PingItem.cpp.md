# Network/Replicator.PingItem.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 125 lines)

## Purpose

Implements `[ItemTypePing][pingBack=false][time][moreStats][extraStats?]`. The client ORs `Tokens::simpleToken`, perf/send stats and all 13 `hackFlag0..12` LINE_RAND4-scattered flags into `moreStats`; the server decodes via `processSendStats`/`processHashStats` kick/report masks. Read handles the optional protocol-34 extra word with the `time & 0x20` inversion.

## API

```cpp
bool PingItem::write(BitStream&);   // VMProtect-virtualized stats gather
static shared_ptr<DeserializedItem> PingItem::read(Replicator&, BitStream&);
void DeserializedPingItem::process(Replicator&);
```

## Usage

See header. Stats: `PACKET_TYPE_Ping` sampled both directions.

## Gotchas

- `*moreStatsCopy != moreStats` double-compute check only runs on non-studio builds; studio/Durango/LOVE builds send zeros.
- CloudEdit servers skip the extraStats inversion decode (`!replicator.isCloudEdit()`).
