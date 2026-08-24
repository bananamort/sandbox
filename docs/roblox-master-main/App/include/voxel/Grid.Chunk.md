# App/include/voxel/Grid.Chunk.h

## Purpose

Suffix header for [Grid.md](Grid.md) defining `Grid::Chunk` — the private per-SpatialRegion storage box backing the terrain Grid. Header comment: "NOT TO BE USED ANYWHERE EXCEPT Grid.cpp AND Grid.h."

## Declared API

- `class Grid::Chunk`
  - State: `bool initialized; unsigned int countOfNonEmptyCells; std::vector<Cell> data; std::vector<unsigned char> material; const Grid* owner;`
  - Layout constants: `kXOffsetMultiplier = 1`, `kZOffsetMultiplier = SpatialRegion::Constants::kRegionXDimensionInVoxels`, `kYOffsetMultiplier = kRegionXDim * kRegionZDim`; `static const int kFaceDirectionToPointerOffset[7];`
  - Static inline index math: `voxelCoordOffsetToIndexOffset(offset)` (component-weighted sum), **`voxelCoordToArrayIndex(coord)`** via `SpatialRegion::voxelCoordinateRelativeToEnclosingRegion`.
  - `Chunk(); ~Chunk();` plus explicit `void init(const Grid* owner);` — "safe to call multiple times… separate init method was made to allow explicit control over when that memory is allocated" (chunk data is big; deferred allocation).
  - Data access: `getData()/getConstData()`, `getMaterial()/getConstMaterial()` (mutable + const pairs).
  - Empty accounting: inline `updateCountOfNonEmptyCells(int delta)` (asserts non-negative), `hasNoUsefulData()` → count==0.
  - Water hook: `fillLocalAreaInfo(centerCoord, Water::RelevantNeighbors, Water::LocalAreaInfo*)` — forwards to `owner->fillLocalAreaInfo` (may cross chunk boundaries, hence owner delegation).

## Gotchas

- Index layout is z-then-y (`x + z*kRegionXDim + y*kRegionXDim*kRegionZDim`) with region-relative coordinates — global coords must be pre-relativized by the static helper.
- `fillLocalAreaInfo` delegates to the owning Grid, so neighbor reads can cross into *other* chunks transparently — a chunk-local optimization would be wrong here.
- Two cells per material byte (nibble packing) as everywhere in voxel/.
