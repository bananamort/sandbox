# App/include/v8world/TerrainPartition.h

## Purpose

Two occupancy-accelerators over terrain grids, used for fast "what terrain is near this extents" queries: `TerrainPartitionMega` (legacy voxel terrain, bit-packed cell occupancy per chunk) and `TerrainPartitionSmooth` (smooth terrain 8×8×8 chunks with per-slice solid/water bitmasks).

## Declared API

- `class TerrainPartitionMega : public Voxel::CellChangeListener`
  - `TerrainPartitionMega(Voxel::Grid* voxelGrid);` — listens to cell changes to keep chunks current.
  - `void findCellsTouchingExtents(const Extents&, std::vector<Vector3int16>* found) const;`
  - `struct ChunkData { unsigned int count; unsigned int filled[kY_CHUNK_SIZE/2][kXZ_CHUNK_SIZE/4][kXZ_CHUNK_SIZE/4]; }` — "filled[y][z][x] represents a sub-chunk of 4x2x4 cells, where 1 cell = 1 bit"; stored in a `Voxel::ChunkMap<ChunkData>`.
  - Private: `findCellsInRegion(region, chunk, minOffset, maxOffset, found)`.
- `class TerrainPartitionSmooth`
  - Constants: `kChunkSizeLog2 = 3`, `kChunkSize = 8`.
  - `TerrainPartitionSmooth(Voxel2::Grid* grid);`
  - `struct ChunkResult { Vector3int32 id; bool touchesSolid; bool touchesWater; };`
  - `void findChunksTouchingExtents(const Extents&, std::vector<ChunkResult>* found) const;`
  - `void updateChunk(const Vector3int32& id);`
  - Storage: `ChunkSlice { uint64_t solid; uint64_t water; }` ("8x8 bits for each slice"), `ChunkData { ChunkSlice slices[8]; }`, `boost::unordered_map<Vector3int32, ChunkData> chunks;` plus precomputed `uint64_t masksHor[8][8], masksVer[8][8];`

## Gotchas

- Mega partition granularity = **cells** (`Vector3int16`), smooth partition granularity = **chunks** (`ChunkResult`) — callers must not mix them.
- Smooth masks separate solid from water so water-only overlaps can be filtered by `touchesWater`.
- Both hold non-owning grid pointers; the grid must outlive the partition.

## Cross-links

- Consumers: [MegaClusterPoly.md](MegaClusterPoly.md) (`myTerrainPartition`), [SmoothClusterGeometry.md](SmoothClusterGeometry.md) (`partition`).
- Grids/chunk maps: [../voxel/INDEX.md](../voxel/INDEX.md) (ChunkMap.inl folded there), [../voxel2/INDEX.md](../voxel2/INDEX.md). Change notifications also feed [ContactManager.md](ContactManager.md).
