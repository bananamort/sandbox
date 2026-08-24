# Network/Replicator.RockyItem.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 103 lines)

## Purpose

Implements the four Rocky wire shapes: `[ItemTypeRocky][subtype]…` — MccReport (5 uint32s), NetPmcResponse (`idx, response, correct`), CallInfo (`count + handler/ret pairs`, truncated to uint8), NetPmcChallenge (`idx + key.base/size/seed/result` from `RBX::Security::netPmcKeys`). Challenge processing is deferred to a DataModel write task via `ClientReplicator::doNetPmcCheck`.

## API

```cpp
bool RockyItem::write(BitStream&);                       // subtype RockeyMccReportClient
static shared_ptr<DeserializedItem> RockyItem::read(Replicator&, BitStream&);  // → readRockyItem (challenge intake)
bool NetPmcResponseItem/RockyDbgItem/NetPmcChallengeItem::write(BitStream&);
void DeserializedRockyItem::process(Replicator&);        // _WIN32 non-studio only
```

## Usage

See header. All writes are plain; only the challenge payload carries key material.

## Gotchas

- `RockyDbgItem` truncates the call-chain count to `uint8_t` and loops with `static_cast<uint8_t>(info.size())` — chains >255 silently drop entries beyond 255 but still write count-truncated.
- On platforms outside `_WIN32 && !RBX_STUDIO_BUILD`, `DeserializedRockyItem::process` is a no-op while `read` still consumed the bytes.
