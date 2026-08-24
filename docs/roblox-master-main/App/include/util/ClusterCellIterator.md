# util/ClusterCellIterator.h

## Purpose
Voxel/terrain streaming iteration: enumerates every cell (Vector3int16 voxel coordinate) inside a set of cluster chunks or stream regions in a fixed bit-interleaved order. Two flavors: whole chunks (`ClusterChunksIterator`) and quarter-chunks (`OneQuarterClusterChunkCellIterator`).

## Declared API
```cpp
class ClusterChunksIterator {
public:
    ClusterChunksIterator();                                        // empty
    explicit ClusterChunksIterator(const std::vector<SpatialRegion::Id>& chunks);
    explicit ClusterChunksIterator(const SpatialRegion::Id& chunk); // single chunk

    static void nextCellInIterationOrder(const Vector3int16& cellpos, Vector3int16* out);

    void pop(Vector3int16* out);      // yields next global voxel coord
    bool chk(const Vector3int16& pos) const;  // "more left?" (ignores pos)
    size_t size() const;
private:
    std::vector<SpatialRegion::Id> chunks;
    size_t indexOfNextCellToIssue, internalSize;
    enum { kChunkSize = Voxel::kXZ_CHUNK_SIZE * kXZ_CHUNK_SIZE * kY_CHUNK_SIZE };
};

struct OneQuarterClusterChunkCellIterator {   // iterates 1/4 of a chunk
    Vector3int16 cellOffset;
    unsigned short internalCell, internalSize;
    StreamRegion::Id regionId;

    OneQuarterClusterChunkCellIterator();     // starts at region 0,0,0
    void setToStartOfStreamRegion(const StreamRegion::Id& _regionId);
    static void cellFromIndex(const Vector3int16& cellOffset, unsigned int index, Vector3int16* out);
    static void nextCellInIterationOrder(const Vector3int16& cellpos, Vector3int16* out);
    void pop(Vector3int16* out);
    bool chk(const Vector3int16& cellPos) const;   // also checks pos still inside regionId
    size_t size() const;
};
```

## Gotchas
- Index packing is bitfield-style and must match consumers: chunk iterator packs x:5 | z:5<<5 | y:4<<10; quarter iterator packs x:4 | z:4<<4 | y:4<<8.
- `chk()` on `ClusterChunksIterator` ignores its argument (pure "has more"); the quarter iterator's `chk(pos)` additionally verifies the voxel is still within the configured stream region — different semantics despite identical signature.
- `pop()` asserts non-empty (`RBXASSERT`); call `chk()` first.
- Iteration order is deterministic but NOT spatially sorted — code assuming locality will not get it.

## UNKNOWN
- Consumers (terrain serialization/streaming under Voxel/, outside this slice).
