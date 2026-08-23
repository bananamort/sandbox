# Network/ClusterUpdateBuffer.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 89 lines)

## Purpose

Implements `ClusterUpdateBuffer` (see ClusterUpdateBuffer.h): an ordered set of terrain (cluster) voxel updates keyed by spatial region, packing each cell's in-chunk location into a single `unsigned int` bitset entry so bulk terrain replication (`ID_CLUSTER`) is memory-efficient.

## API

```cpp
void ClusterUpdateBuffer::computeUintRepresentingLocationInChunk(
        const ClusterCellUpdate& update, unsigned int* out);
void ClusterUpdateBuffer::computeGlobalLocationFromUintRepresentation(
        const unsigned int& index, const Vector3int16& baseCellOffset, ClusterCellUpdate* out);
ClusterUpdateBuffer::ClusterUpdateBuffer();       // internalSize = 0
size_t ClusterUpdateBuffer::size() const;
void ClusterUpdateBuffer::push(const ClusterCellUpdate& inputData);   // insert; dedup via UintSet
bool ClusterUpdateBuffer::chk(const ClusterCellUpdate& test);         // membership test
void ClusterUpdateBuffer::pop(ClusterCellUpdate* out);                // pop smallest index of first non-empty region
```

Encoding: `(x & 0x1f) | ((z & 0x1f) << 5) | ((y & 0x0f) << 10)` — 32×32×16 cells per chunk.

## Usage

Used by the streaming/terrain replication path: producers `push` changed voxels, the cluster packet builder `pop`s them in iteration order; `chk` supports tests/dedup checks. Region lookup uses `SpatialRegion::regionContainingVoxel`; global coords reconstructed from `SpatialRegion::inclusiveVoxelExtentsOfRegion(...).getMinPos()`.

## Gotchas

- `push` resets `lastFound = bitSetUpdates.begin()` every call because insertion can invalidate iterators — O(1) amortized but keeps the "no updates before lastFound" invariant.
- `pop` asserts `internalSize > 0` and asserts-fails if the map says size>0 but no non-empty set is found (invariant violation).
- Duplicate pushes are silently ignored (UintSet insert returns 0 growth), so `internalSize` counts distinct cells only.
