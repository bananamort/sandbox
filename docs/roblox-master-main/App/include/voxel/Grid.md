# App/include/voxel/Grid.h

## Purpose

The terrain voxel storage class: chunk-per-SpatialRegion map of cells + packed materials, cell read/write with change notification, and Region views for iteration. Header warning: the grid "frequently allocates and re-allocates memory, and does not take any data model locks, so do not store VoxelRegions for later use (e.g. storing for a later job run)."

## Declared API

- `class Grid` (namespace RBX::Voxel)
  - Forward-declares nested `class Chunk` ([Grid.Chunk.md](Grid.Chunk.md)); `typedef ChunkMap<Chunk> ChunkMapType;` members: `chunkMap`, `unsigned int countOfNonEmptyCells;`
  - Listener list: `std::vector<CellChangeListener*> cellChangeListeners;` — header note: the change signal does NOT fire when `setCell` writes identical values.
  - Private helpers: `getVoxelLikelyThisChunk(id, chunk, coord) const`, `fillLocalAreaInfo(coord, neighbors, out) const`.
  - Public: `typedef RBX::Voxel::Region<Chunk> Region;` ctor `Grid();`
  - `inline unsigned int getNonEmptyCellCount() const;`
  - Listeners: `connectListener(CellChangeListener*)` / `disconnectListener(...)`.
  - **`void setCell(const Vector3int16& location, Cell newCell, CellMaterial newMaterial);`** — notifies listeners only on actual change.
  - `Region getRegion(const Vector3int16& extent1, const Vector3int16& extent2) const;` — "does not support extents that span SpatialRegion boundaries".
  - Single-cell reads: `Cell getCell(pos) const; CellMaterial getCellMaterial(pos) const; Cell getWaterCell(pos) const;`
  - Chunk inventory: `std::vector<SpatialRegion::Id> getNonEmptyChunks() const;` and `getNonEmptyChunksInRegion(const Region3int16&) const;`
  - `bool isAllocated() const;`
- Tail-includes `Voxel/Grid.Chunk.h`.

## Gotchas

- Regions are ephemeral by design — caching one across jobs/frames races reallocation (explicit header contract).
- Single-region limit on `getRegion`: callers spanning boundaries must iterate per region or use [AreaCopy.md](AreaCopy.md).
- Listener callbacks fire synchronously inside setCell — re-entrant setCell from a listener is caller beware.
- `isAllocated()` returns `countOfNonEmptyCells > 0` (App/voxel/Grid.cpp L201–203) — true only once at least one *non-empty* cell exists; an initialized chunk holding all-empty cells still reports false. It is not a "chunks allocated" flag.

## UNKNOWN

- Threading contract details (which jobs call setCell concurrently) live in terrain .cpps outside this tree.
