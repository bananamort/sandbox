# App/include/voxel/Region.h

*(coverage includes **Region.inl**, **Region.iterator.inl**, **Region.xline_iterator.inl** — folded per orchestrator ruling)*

## Purpose

Read-only view over an axis-aligned voxel sub-box, templated on the storage type (`Grid::Chunk`, `AreaCopy<N>::Chunk`, …). Provides point queries plus two iterators: a full sequential iterator (Y-Z-X order) and a bulk `xline_iterator` handing out whole X-axis lines for memcpy-style operations. All implementations live in the three tail-included .inl files.

## Declared API (Region.h)

- `template<class InternalStorageType> class Region`
  - Ctors: default (null storage) and `(const InternalStorageType* internalStorage, minCoords, maxCoords)`.
  - `bool isGuaranteedAllEmpty() const` — "may return false if all cells are empty, but will never return true if some cells are set".
  - `contains(globalCoord)`; queries `voxelAt(coord) → const Cell&`, `materialAt(coord)`, `hasWaterAt(coord)`.
  - Iteration: `begin()/end()` (iterator), `xLineBegin()/xLineEnd()`; assignment/equality operators.
  - Static sentinels: `kEndRegion`, `kEndIterator`, `kEndXLineIterator`; private fast paths `voxelAtSkipAllEmptyCheck`, `hasWaterAtSkipAllEmptyCheck`.
- `class Region<...>::iterator` — ctor takes owning region; reads at current location (`getCurrentLocation/getCellAtCurrentLocation/hasWaterAtCurrentLocation/getMaterialAtCurrentLocation`); neighbor reads "should only be used when the caller knows … cells are contained in the Region": `getNeighborCell(dir[, dir2])`, `getNeighborMaterial(dir[, dir2])`, `getArbitraryNeighborCell(Vector3int16 offsets)`, `hasWaterAtNeighbor(dir)`; prefix `operator++`, ==/!=.
- `class Region<...>::xline_iterator` — ctor; `getCurrentLocation()`, `getLineSize()`, **`getLineCells()`** ("contiguous array of Cells … exactly lineSize elements"), **`getLineMaterials()`** ("exactly lineSize/2 elements… half-byte material information"); ==/!=/++.

## Region.inl contents

- Sentinels: `kEndRegion(NULL, one(), zero())`; end iterators wrap it.
- All-empty regions answer queries from constants: `voxelAt` → `Constants::kUniqueEmptyCellRepresentation`, **`materialAt` → `CELL_MATERIAL_Water`** (!), `hasWaterAt` → false.
- Real regions index through `internalStorage->voxelCoordToArrayIndex` + `getConstData()/getConstMaterial()` with `readMaterial(...)` nibble unpacking ([Util.md](Util.md)).
- `end()` returns reference to the static kEndIterator.

## Region.iterator.inl contents

- `VoxelIteratorConstants::kFaceDirectionToLocationOffset[6]` (+x,+z,−x,−z,+y,−y).
- Ctor computes "carriage return" pointer skips (end-of-x-line and end-of-x-z-plane wraps, degenerate-safe when z or y dimension is 1); caches currentLocation/currentIndex/currentCell; empty regions start at reachedEnd.
- Neighbor accessors use storage's `kFaceDirectionToPointerOffset[]` (raw pointer arithmetic); asserts are RBXASSERT_SLOW only.
- `operator++`: x-major walk with skip-based wraps; ends when y exceeds max.
- Equality: once either side reachedEnd, compare only reached flags; else region identity + location.

## Region.xline_iterator.inl contents

- Ctor fixes lineSize/minZ/zDimSize/maxY; asserts **currentIndex is even** ("half byte material alignment reasons") at construction and after every ++.
- `getLineMaterials` returns `&materials[currentIndex / 2]`.
- `++` walks z then y (one xline per step).

## Gotchas

- **Source-level syntax bug**: Region.iterator.inl line ~124, two-direction `getNeighborMaterial` assert reads `kFaceDirectionToLocationOffset[direction2))` — missing closing `]`. Latent because the broken tokens live inside the `RBXASSERT_SLOW(...)` argument: builds where that macro discards its argument compile fine even when the overload is instantiated; builds with slow asserts active fail with `expected ']'` in any TU that *instantiates* it (verified by compiler repro). The overload DOES have live callers: Rendering/GfxRender/MegaCluster.cpp L1043 (`detectOutlines`) and L1119 (`detectWedgeOutlines`) call it on RenderArea (=AreaCopy) region iterators — those paths depend on slow asserts being compiled out.
- All-empty `materialAt` returns **Water**, not a neutral material — code treating it as "default material" will mislabel empty terrain.
- Iterator holds a reference to the owning region: regions from [Grid.md](Grid.md) must outlive their iterators (no storing, per Grid's contract).
- Neighbor accessors are unchecked-in-release pointer arithmetic — stepping outside the box aliases adjacent memory silently.
- Even-index invariant ties xline iteration to even region widths/x-starts (same constraint as AreaCopy).
