# Network/NetworkPacketCache.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 345 lines)

## Purpose

Implements the two server-side serialization caches (services `PhysicsPacketCache` = "PhysicsPacketCache", `InstancePacketCache` = "InstancePacketCache"): per-key stored bitstream fragments that can be replayed instead of re-serializing unchanged data. Physics cache keys Assemblies with a validity window tied to the physics world step id; Instance cache keys Instances with dirty flags driven by property-changed signals and guid-mismatch staleness detection, keeping separate entries for join-data vs live (`bitStream[2]`).

## API

```cpp
// PhysicsPacketCache
void insert(const Assembly*);            // + child assemblies
void remove(const Assembly*);
bool fetchIfUpToDate(const Assembly*, unsigned char index, BitStream& out);
bool update(const Assembly*, index, BitStream&, startReadBitPos, numBits);  // byte-aligned copy + bit offset bookkeeping
// wired to PhysicsService assemblyAdding/RemovedSignal

// InstancePacketCache
void insert(const Instance*);   // connects propertyChangedSignal → dirty, ancestryChangedSignal → remove on NULL parent
void remove(const Instance*);
bool fetchIfUpToDate(const Instance*, BitStream&, bool isJoinData);
bool update(const Instance*, BitStream&, numBits, bool isJoinData);
```

Both guard `streamCache` with `boost::shared_mutex` (shared fetch / upgrade-to-unique update).

## Usage

- Created by Server when `NetworkSettings::useInstancePacketCache`/`usePhysicsPacketCache` are true; consumed by JoinDataItem/NewInstanceItem and physics senders.
- Stale guid mismatches mark entries dirty and (under `DFFlag::DebugLogStaleInstanceCacheEntry`) report GA `"InstanceCache stale entry"`.

## Gotchas

- Physics cache freshness is exactly one world step: an id match against `getWorldStepId()`.
- GA category here is `GA_CATEGORY_ERROR` — the only error-bucket analytics call in the module.
