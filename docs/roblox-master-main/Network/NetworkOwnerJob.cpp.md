# Network/NetworkOwnerJob.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 304 lines)

## Purpose

Implements the ownership step: under a scoped write request it rebuilds `clientMap` from every ServerReplicator's `readPlayerSimulationRegion` (character head position + simulation radius, stream-adjusted), then for each assembly-root part in all SpatialFilter phases runs the decision tree: manual owners validated; unassigned parts go to their player's owner or Server; otherwise keep current if capable, switch to a strictly closer capable client (`Region2::closerToOtherPoint` with `DistributedPhysics::SERVER_SLOP()`), else revert to Server. Ownership changes notify and set a 0.1 s re-switch delay.

## API

```cpp
#define DEC_SIM_RADIUS_FPS 15.0f
#define INC_SIM_RADIUS_FPS 17.5f      // (unused here; radius pacing constants)
TaskScheduler::StepResult stepDataModelJob(const Stats&);
void updatePlayerLocations(Server*); void updateNetworkOwner(PartInstance*);
ClientMapConstIt findClosestClientToPart/findClosestClient(...);
bool clientCanSimulate/isClientCharacterMechanism/switchOwners(...);
static void resetNetworkOwner(PartInstance*, SystemAddress);
void invalidateProjectileOwnership(SystemAddress);
```

## Usage

See header; per-client `numPartsOwned` counters are reset each pass and incremented on assignment (surfaced in ServerStatsItem "Num Parts Owned").

## Gotchas

- Commented-out alternative delay (3 s for client-owned parts) shows iPad-driven tuning history.
- `findClosestClient` early-exits at exact zero error; ties otherwise resolved by map order (address).
