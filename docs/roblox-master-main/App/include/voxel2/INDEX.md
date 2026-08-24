# App/include/voxel2 — Index

Smooth-voxel terrain system (successor to blocky voxel/): 2-byte material+occupancy cells, chunked LOD grid, mesher for render geometry, data-driven materials, legacy conversion, and bit-stream serialization.

| File | Doc | Notes |
|---|---|---|
| BitSerializer.h | [BitSerializer.md](BitSerializer.md) | Delta chunk indices + RLE cell payloads; stateful, throws on chunk overflow. |
| Conversion.h | [Conversion.md](Conversion.md) | Legacy voxel → Voxel2 mapping (lossy block shapes → occupancy levels); kMaterialTable = saved-format order. |
| Grid.h | [Grid.md](Grid.md) | Cell (6-bit material/8-bit occupancy), Region algebra, Box slices, chunked Grid with 4 mips + listeners + serialize. |
| GridListener.h | [GridListener.md](GridListener.md) | onTerrainRegionChanged(region) callback. |
| MaterialTable.h | [MaterialTable.md](MaterialTable.md) | File-loaded material/layer/atlas defs for rendering. |
| Mesher.h | [Mesher.md](Mesher.md) | BasicMesh/GraphicsMesh(Packed) generation, adjacency/edge flags, 18-entry texture bases. |

6 of 6 headers documented. No .inl files in this directory.
