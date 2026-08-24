# App/include/voxel — Index

Legacy blocky terrain voxel system: 1-byte Cell encoding, chunked Grid storage, Region views with iterators, water-on-wedge logic, area snapshots, replication codec, and the part→occupancy Voxelizer.

| File | Doc | .inl folded | Notes |
|---|---|---|---|
| AreaCopy.h | [AreaCopy.md](AreaCopy.md) | AreaCopy.inl | Template snapshot box across SpatialRegion boundaries; even-x material alignment. |
| Cell.h | [Cell.md](Cell.md) | — | 1-byte Cell union (solid/water), all enums, 4-stud cell constants. |
| CellChangeListener.h | [CellChangeListener.md](CellChangeListener.md) | — | terrainCellChanged callback + CellChangeInfo payload. |
| ChunkMap.h | [ChunkMap.md](ChunkMap.md) | ChunkMap.inl | SpatialRegion::Id → ValueType unordered map; insert() = operator[]. |
| Grid.Chunk.h | [Grid.Chunk.md](Grid.Chunk.md) | — | Suffix header defining private Grid::Chunk storage. |
| Grid.h | [Grid.md](Grid.md) | — | Terrain storage: setCell w/ change signal, single-region getRegion. |
| Region.h | [Region.md](Region.md) | Region.inl, Region.iterator.inl, Region.xline_iterator.inl | Read-only view + sequential & xline iterators; all-empty sentinel returns Water material. |
| Serializer.h | [Serializer.md](Serializer.md) | — | Bit-stream cell codec (new/repeat tokens, 8-entry dedup); known OOB-read TODO in-header. |
| Util.h | [Util.md](Util.md) | — | Material nibbles, FaceDirection, oriented-face tables, world↔cell math. |
| Voxelizer.h | [Voxelizer.md](Voxelizer.md) | — | Part-shape → OccupancyChunk rasterizer (Mega + Voxel2 smooth paths, SIMD). |
| Water.h | [Water.md](Water.md) | Water.inl | Water-on-wedge neighbor rules per CellOrientation. |

11 of 11 headers documented; 6 .inl files folded into their parents (AreaCopy←1, ChunkMap←1, Region←3, Water←1).
