# Network/ErrorCompPhysicsSender.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 390 lines)

## Purpose

Implements error-compensated physics prioritization: `computeError` = `biggestSize² × (taxiCab positional error + 0.2·radius·rotation-axis delta) / clamped distance-to-character`; character parts pinned at max error/detailed. `step()` refreshes up to 100 stale nuggets per pass; `sendPacket` drains the error-sorted multiset into `[ID_TIMESTAMP][now][ID_PHYSICS]` UNRELIABLE packets on PHYSICS_CHANNEL, flushing when over MTU. Assembly serialization goes through the `PhysicsPacketCache` keyed on `(assembly, sendDetailed)`.

## API

```cpp
void step();  int sendPacket(...);
bool sendPhysicsData(BitStream&, const Nugget&);
void writeAssembly(...) override;   // cache fetch/update wrapper
void addNugget/addNugget2/removeNugget/onAddingAssembly/onRemovedAssembly;
Nugget constants: minDistance 3, maxDistance 1000, minSize 2, maxSize 50 (studs)
```

## Usage

See header. Radius recomputed every 20 steps per nugget.

## Gotchas

- Detailed mode when within 20 studs of the target player's head.
- Cache update failure logs "cache update failed" + assert but continues.
