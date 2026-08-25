# App/include/voxel2/Grid.h

## Purpose

Smooth-voxel terrain storage: 2-byte `Cell` (6-bit material + 8-bit occupancy), integer `Region` algebra, lazily-allocated dense `Box` slices, and a chunked `Grid` with per-chunk LOD mip pyramid, change listeners, and string serialize/deserialize. This is the modern replacement for the blocky voxel/ Grid.

## Declared API

Namespace RBX::Voxel2:

- `class Cell`
  - Enums: `Material { Material_Air = 0, Material_Water = 1, Material_Bits = 6, Material_Max = 63 }`; `Occupancy { Occupancy_Bits = 8, Occupancy_Max = 255 }`.
  - Default ctor zeroes (BOOST_STATIC_ASSERT pins Air==0 "since we use memset elsewhere"); `(material, occupancy)` ctor clamps occupancy to 0 for Air via bit trick `occupancy & (-static_cast<int>(material) >> 31)`; getters; ==/!=.
- `class Region` — half-open-ish integer box (`begin_`, `end_`): ctors from (begin,end) or (begin,size); statics `fromChunk(id, chunkSizeLog2)` and `fromExtents(Vector3 min,max)`; accessors begin/end/size; `empty()` (any zero extent); ==/!=; algebra: `aligned(size)`, `inside(other)`, `intersect`, `expand(size)`, `expandToGrid(size)`, `offset`, `downsample(lod)`; chunk enumeration `getChunkIds(chunkSizeLog2)`, `getChunkCount(chunkSizeLog2)` (ull).
- `class Box` — dense Cell array sized `(sizeX,sizeY,sizeZ)`; default ctor + sized ctor; layout index = `x + sizeX*z + sliceXZ*y`; `get(x,y,z)` returns `emptyCell` static when unallocated; `set` allocates on demand; `readRow/writeRow(0,y,z)` hand out row pointers for memcpy; `getSize()/getSizeX/Y/Z()`; `isEmpty()` = !data; `clone()`.
- `class Grid`
  - `Grid();` listeners: `connectListener(GridListener*) / disconnectListener(...)` ([GridListener.md](GridListener.md)).
  - **`Box read(const Region& region, int lod = 0) const;`** and **`void write(const Region& region, const Box& box);`**
  - `Cell getCell(int x, int y, int z) const;`
  - `std::vector<Region> getNonEmptyRegions() const;` `getNonEmptyRegionsInside(const Region&) const;`
  - `unsigned int getNonEmptyCellCountApprox() const;` `bool isAllocated() const` → !chunks.empty().
  - `void serialize(std::string& result) const; void deserialize(const std::string& result);`
  - Private: `enum { kChunkMips = 4 };` nested `struct Chunk { Box data[4]; unsigned int volume; Chunk(); bool isEmpty() const; }`; `boost::unordered_map<Vector3int32, Chunk> chunks; unsigned int chunksVolume; std::vector<GridListener*> listeners;`

## Gotchas

- Occupancy is forced to 0 whenever material is Air — the ctor's arithmetic trick makes explicit zeroing unnecessary but also means you cannot store an Air cell with nonzero occupancy.
- `read(region)` with no allocation in range yields an empty Box whose `get()` returns the shared `emptyCell` — writes through read-modify-write cycles must go through `write`.
- Mip levels: each Chunk keeps 4 Boxes (lod 0..3) — `read(..., lod)` selects one; `Grid::write` regenerates the affected mip chain (mips 1..3) itself, so coherence holds only while all mutations go through write paths (direct Box/chunk edits desync mips).
- Listener vector is raw pointers with no ownership; disconnect before destroying listeners.
- Serialization format is opaque from this header (implemented with [BitSerializer.md](BitSerializer.md) presumably); strings are not self-describing across versions.

## UNKNOWN
- Chunk size used for the Vector3int32 key (not stated in this header; App/voxel2/Grid.cpp pins `kChunkSizeLog2 = 5`, i.e. 32³ chunks).
