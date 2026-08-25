# App/include/voxel/AreaCopy.h

*(coverage includes **AreaCopy.inl** — folded per orchestrator ruling)*

## Purpose

Template helper for tasks needing fast voxel access across SpatialRegion boundaries: snapshots a `XDim×YDim×ZDim` box of cells into an internal buffer ("Chunk"), refreshable repeatedly from any source exposing `getRegion()`. The buffer complies with the [Region.md](Region.md) API so the same iteration code works over live grids and copies.

## Declared API (AreaCopy.h)

- `template<unsigned int XDim, unsigned int YDim, unsigned int ZDim> class AreaCopy`
  - Nested private `class Chunk` (the Region-API adapter): storage `std::vector<Cell> cells; std::vector<unsigned char> materials; Vector3int16 firstCellLocation; bool isAllEmpty;`
    - Index math constants: `kXOffsetMultiplier=1`, `kYOffsetMultiplier = XDim*ZDim`, `kZOffsetMultiplier = XDim`; `static int kFaceDirectionToPointerOffset[7];`
    - `voxelCoordOffsetToIndexOffset(offset)` static, `voxelCoordToArrayIndex(globalCoord)`, `contains(cellLoc)`, `getConstData()/getConstMaterial()`, **`fillLocalAreaInfo(coord, Water::RelevantNeighbors, Water::LocalAreaInfo*)`** (the duck-typed hook consumed by [Water.md](Water.md)), `fillEmpty(min,max)`, template `fillFromRegion(regionType)`, template `loadData(source, firstCellLocation)`, `getIsAllEmpty()`.
  - Public: `typedef Region<Chunk> Region;` `static const Region kStaticEndRegion;`
  - `Region getRegion(minCoords, maxCoords) const;`
  - `template<class Source> void loadData(const Source* source, const Vector3int16& rootCell);`
- Header tail-includes AreaCopy.inl.

## AreaCopy.inl contents

- `loadData` allocates lazily on first call (cells filled with `Constants::kUniqueEmptyCellRepresentation`, materials 0xff), then walks every SpatialRegion overlapped by the box: clamps query to the box, asserts even x-width and even x-start ("material alignment issues — all x segments must be even, and start from an even location in the region" — two cells pack per material byte), pulls `source->getRegion(queryMin, queryMax)` and either `fillEmpty` (region guaranteed empty) or `fillFromRegion`.
- `fillFromRegion` iterates `xline_iterator`s, memcpy fast-path when lineSize==32 else per-cell copy including half-byte material packing (`materials[(index+i)/2] = src[i/2]`).
- `fillLocalAreaInfo` indexes five neighbors via offset arithmetic; all positions RBXASSERTed inside the box.
- `getRegion` returns `Region(NULL, …)` when the whole copy is empty (all-empty fast path).

## Gotchas

- Material nibble packing means **X dimension must be even** and root x-coordinate even-aligned or the asserts fire / materials corrupt.
- The copy is stale the instant the source changes — refresh with loadData before each use; no dirty tracking.
- `voxelCoordToArrayIndex` has no bounds check in release; out-of-box coordinates silently alias.
- Chunk layout is y-major (`x + z*XDim + y*XDim*ZDim`) — different from Grid::Chunk which uses region dimensions.
- `kStaticEndRegion` (AreaCopy.h L58) is declared but **never defined anywhere in the tree** (grep-verified) — any odr-use (binding a reference, taking its address) is a link error; only the null-region fast path in getRegion is actually usable.

## UNKNOWN

- Which template instantiations exist (e.g. 4×4×4 water-simulation stencils) — instantiation sites are in .cpps outside this tree.
