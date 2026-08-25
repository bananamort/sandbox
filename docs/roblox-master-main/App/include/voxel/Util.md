# App/include/voxel/Util.h

## Purpose

Voxel math helpers: nibble-packed material read/write, `FaceDirection` enum, wedge face-corner geometry tables (`BlockAxisFace`/`BlockFaceInfo` + orientation lookup map), and world↔cell coordinate conversions at the fixed 4-stud cell size.

## Declared API

Namespace RBX::Voxel:

- Deprecated legacy access: `getCellMaterial_Deprecated(unsigned char)` / `setCellMaterial_Deprecated(...)` — 3-bit material inside the cell byte (pre-separate-material-storage era).
- **Material nibbles**: `CellMaterial readMaterial(const unsigned char* materials, unsigned int cellIndex, Cell cell)` — Empty block → `CELL_MATERIAL_Water`, else `(nibble)+1`; `void writeMaterial(unsigned char* materials, cellIndex, newMaterial)` — asserts material>0, writes (material−1) into the low/high nibble by cellIndex parity. Two cells per byte.
- `enum FaceDirection { PlusX=0, PlusZ=1, MinusX=2, MinusZ=3, PlusY=4, MinusY=5, Invalid=6 };`
- `struct BlockAxisFace` with nested `enum SkippedCorner { TopRight, TopLeft, BottomLeft, BottomRight, EmptyAllSkipped, FullNoneSkipped }`; statics: `rotate(corner, CellOrientation)` ((corner+orient)%4 for corners), `divideTopLeftToBottomRight(corner)`, `XZAxisMirror`, `YAxisMirror` (static lookup tables), `inverse(face)` (opposite-corner table; note OPPOSITE_CORNER is a function-local `static const` array inside a static function — initialized on first call).
- `struct BlockFaceInfo { BlockAxisFace faces[6]; }` ("indexed by FaceDirection").
- Externs: `const BlockFaceInfo UnOrientedBlockFaceInfos[6];` and **`BlockAxisFace OrientedFaceMap[1536]`** ("2^8 * 6"); `void initBlockOrientationFaceMap();` ("ComputeOrientedFace is not declared because it is an implementation detail").
- Inline lookups: `GetOrientedFace(Cell, FaceDirection)` → `OrientedFaceMap[cellByte*6 + f]` (uses the deprecated byte cast); `isWedgeSideNotFull(cell, f)` — skippedCorner != FullNoneSkipped.
- Coordinate conversion inline set: `worldToCell_floor(Vector3)`, `worldSpaceToCellSpace`, `cellSpaceToWorldSpace`, `cellToWorld_smallestCorner/center/largestCorner` (all divide/multiply by `kCELL_SIZE`=4 from [Cell.md](Cell.md)); vestigial `kXZOffset = 0` in two functions.
- Terrain bounds: `getTerrainExtentsInCells()` → ±32000 cells cube; `getTerrainExtents()` → same in world studs.

## Gotchas

- `OrientedFaceMap` is 1536 entries indexed by raw cell byte ×6 + direction — it must be filled by `initBlockOrientationFaceMap()` before any GetOrientedFace call; there's no guard.
- Material encoding is offset-by-one (stored nibble 0 = material 1); writing `CELL_MATERIAL_Deprecated_Empty` through writeMaterial trips its assert — empty cells are represented by the cell byte, not a material.
- `readMaterial`'s Empty→Water rule means "empty solid" always reports water material — callers must check emptiness separately when they don't want that.
- FaceDirection ordering (+x,+z,−x,−z,+y,−y) differs from axis-sorted intuition; tables across voxel/ depend on this exact order.

## UNKNOWN

- Where initBlockOrientationFaceMap() gets invoked during startup.
