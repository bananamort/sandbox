# Network/Replicator.PingBackItem.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 60 lines)

## Purpose

Implements the ping-back write: `[ItemTypePingBack][true][time][sendStats = DataModel::sendStats | allHackFlagsOredTogether()][extraStats?]` under VMProtect mutation region "32". The server receiving this samples elapsed time in `processDataPing`.

## API

```cpp
bool PingBackItem::write(BitStream&);
```

## Usage

See header; protocol-34 extra word uses the same `time & 0x20` conditional inversion on non-RCC/non-studio builds.

## Gotchas

- Server→client pingbacks carry hack flags too, so a tampered server binary is also detectable client-side.
