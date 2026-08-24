# Network/ClusterUpdateBuffer.h

**Module**: Network (root) · **Type**: header (.h, 58 lines)

## Purpose

Declares `ClusterUpdateBuffer`, a deduplicating buffer of terrain voxel updates organized per `SpatialRegion::Id` (boost::unordered_map of `UintSet`). Constants `kXZ_CHUNK_SIZE_AS_BITSHIFT=5`, `kXZ_CHUNK_SIZE_AS_BITMASK=0x1f`, `kY_CHUNK_SIZE_AS_BITSHIFT=4`, `kY_CHUNK_SIZE_AS_BITMASK=0x0f` are exposed at global scope "for testing".

## API

```cpp
typedef Vector3int16 ClusterCellUpdate;
typedef unsigned int ChunkIndex;

struct ClusterUpdateBuffer {
    static void computeUintRepresentingLocationInChunk(const ClusterCellUpdate&, unsigned int* out);
    static void computeGlobalLocationFromUintRepresentation(const unsigned int& info,
                                                            const Vector3int16& baseCellOffset,
                                                            ClusterCellUpdate* out);
    ClusterUpdateBuffer();
    size_t size() const;
    void push(const ClusterCellUpdate& inputData);
    bool chk(const ClusterCellUpdate& test);
    void pop(ClusterCellUpdate* out);
    static inline void nextCellInIterationOrder(const Vector3int16& cellpos, Vector3int16* out); // delegates to ClusterChunksIterator
};
```

## Usage

Terrain replication (`ID_CLUSTER` packets) in `Replicator.cpp`/`Replicator.h` — the only consumers of this type in the module (verified by grep).

## Gotchas

- Y extent is 4 bits (16 cells) vs 5 bits (32) for X/Z — cells with y-offset ≥ 16 within a chunk cannot be represented; chunk layout must match `ClusterChunksIterator`.
- `lastFound` iterator is a private scheduling optimization; the map type's hash is `SpatialRegion::Id::boost_compatible_hash_value`.
