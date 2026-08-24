# Network/TopNErrorsPhysicsSender.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 705 lines)

## Purpose

Implements the top-N sender: `step()` recomputes every nugget's error (`biggestSize²·(taxiCab pos + 0.2·radius·rotΔ)/squared distance`; character=FLT_MAX), skips parts not owned by this connection's target (error=0, timestamp refreshed), prunes unlinked parts (or marks them `notInService` under `PhysicsSenderSleepingUpdate`), then `nth_element`-partitions so the top items-per-packet count lead the list. `sendPacket` gates on buffer health (<40% ⇒ skip when buffers full), writes `[ID_TIMESTAMP][timestamp][ID_PHYSICS][interpTimestamp?]`, and per part delegates to `writeMovementHistory`: has-movement bit, cross-packet-compression eligibility (>2 nodes, tolerable accumulated error ≤ `MH_TOLERABLE_COMPRESSION_ERROR`, small object ≤6 studs, far from player head or slow, velocity accurate within client sim region), then VarInt node list of `{precisionLevel, dX, dY, dZ, delta2Ms}` bytes.

## API

```cpp
void step(); int sendPacket(...);
bool writeMovementHistory(...) override;   // returns true; sets lastSendCFrame/accumulatedError
void writePV/writeAssembly(...) override;  // cache index bits: 1=detailed, 2=crossPacketCompression
bool isSleepingRootPrimitive(part);
```

## Usage

See header. On cross-packet send: `accumulatedError += 0.1f`; full CFrame resets it to 0.

## Gotchas

- Cross-packet compression disabled near the player head (≤2500 sq-dist) unless velocity ≤15 — baseline loss would be visible.
- Ownership handoff: parts inside the client simulation range require estimated velocity error ≤10% or full state is sent.
- Cache-miss assert is skipped under SleepingUpdate; optional one-shot GA "PhysicsSenderCacheMiss".
