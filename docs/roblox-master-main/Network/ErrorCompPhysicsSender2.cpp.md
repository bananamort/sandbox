# Network/ErrorCompPhysicsSender2.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 592 lines)

## Purpose

Implements the bucketed sender: `step()` lazily recomputes `computeDeltaError` (≤1 old visit per pass) and splices nuggets between group buckets; `sendPacket` runs a weighted round-robin (`calculateSendCount` gives each non-empty bucket `ceil(size·2/nextSize·nextTarget)` sends per visit of the next bucket; last non-empty bucket always sends 1), writing `[ID_TIMESTAMP][now-or-ownerTime][ID_PHYSICS]` packets — parts owned by someone else reuse their original `raknetTime` so the receiver's interpolation buffer keys on the owner's timeline. Assembly writes go through the physics packet cache.

## API

```cpp
#define NUM_GROUPS 4
void step(); void calculateSendCount(); int sendPacket(...);
bool writeNugget(BitStream&, Nugget&);  bool sendPhysicsData(...); void writeAssembly(...) override;
Bucket::push_back/erase/splice;   // splice fixes bucket cursors when moving nodes across buckets
Nugget constants: minDistance 3, maxDistance 800, minSize 2, maxSize 25, midArea 312.5
```

## Usage

See header. Character parts: groupId 0 + detailed.

## Gotchas

- Removal is again passive (scans drop unlinked parts); `onRemovedAssembly` connection commented out.
- `writeAssembly` cache-miss path has vestigial local `stream` written into bitStream after cache update (harmless duplicate-write of zero-length stream).
