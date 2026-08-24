# Network/NetworkClusterPacketCache.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 132 lines)

## Purpose

Implements the terrain (cluster) serialization caches as explicit template instantiations of `ClusterPacketCacheBase<Key>`: `ClusterPacketCache` (`SpatialRegion::Id` keys, legacy voxel grid — marks the containing spatial region dirty per cell change) and `OneQuarterClusterPacketCache` (`StreamRegion::Id` keys, smooth terrain via `onTerrainRegionChanged` chunk-id fan-out). Base provides shared-mutex-guarded fetch/update of cached bitstreams plus grid listener wiring to the `MegaClusterInstance`.

## API

```cpp
const char* const sClusterPacketCacheBase = "ClusterPacketCacheBase";
const char* const sClusterPacketCache = "ClusterPacketCache";
const char* const sOneQuarterClusterPacketCache = "OneQuarterClusterPacketCacheBase";

template<class Key> class ClusterPacketCacheBase {
    unsigned int getCachedBitStreamBytesUsed(const Key&);
    bool fetchIfUpToDate(const Key&, BitStream&);      // shared lock
    bool update(const Key&, BitStream&, numBits);      // unique lock
    void setupListener(MegaClusterInstance*);          // smooth or voxel grid
    void onServiceProvider(...);                       // clear + disconnect
};
template class ClusterPacketCacheBase<StreamRegion::Id>;
template class ClusterPacketCacheBase<SpatialRegion::Id>;
```

## Usage

Created by Server (`ServiceProvider::create<OneQuarterClusterPacketCache>`/`ClusterPacketCache` always; used when streaming/smooth); consumed in Replicator cluster send paths.

## Gotchas

- Legacy `ClusterPacketCache::onTerrainRegionChanged` asserts false — it only supports per-cell notifications.
- `streamCache[regionId]` default-inserts on lookup even during a failed fetch.
