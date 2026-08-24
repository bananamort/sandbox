# App/include/voxel/Water.h

*(coverage includes **Water.inl** — folded per orchestrator ruling)*

## Purpose

Terrain "water on wedge" logic: given a non-solid, non-empty cell (wedge/corner shapes), decide whether it visually/logically holds water by inspecting orientation-dependent neighboring cells. Declares the neighbor-layout tables and two template entry points; **Water.inl** provides the tables and implementations.

## Declared API (Water.h)

Namespace `RBX::Voxel::Water`:

- `struct RelevantNeighbors` — const `Vector3int16 aboveNeighbor, primaryNeighbor, secondaryNeighbor, diagonalNeighbor, diagonalUpNeighbor;` ctor from `CellOrientation`; "some locations will be initialized to the center location if they are irrelevant to the water on wedge state".
- `struct LocalAreaInfo` — same five slots as `Cell` values.
- Templates declared for any `BoxType* reader`: `bool cellHasWater(const BoxType*, const Cell&, const Vector3int16& globalCoord);` `Cell interpretAsWaterCell(const BoxType*, const Cell&, const Vector3int16&);`
- Header tail-includes `Voxel/Water.inl`.

## Water.inl contents

- `extern const RelevantNeighbors kRelevantNeighbors[MAX_CELL_ORIENTATIONS];`
- Anonymous-namespace lookup tables: `kOppositeFaceDirection[Invalid]`, `kPrimaryNeighborByOrientation[4]`, `kSecondaryNeighborByOrientation[4]`, `kAboveNeighborCellOffset(0,1,0)`, per-orientation primary/secondary offsets (±x/±z).
- `bool isWaterOnWedge(const Cell& center, const LocalAreaInfo&)` — core rule set:
  - water above → true;
  - VerticalWedge → true iff primary neighbor is explicit water;
  - otherwise true if inverse-corner-wedge vertical diagonal case (center is InverseCornerWedge + all three ortho neighbors non-empty + diagonal-up has explicit water) OR (diagonal is water AND both ortho neighbors support it — each being water or a wedge with a not-full shared face) OR both ortho neighbors are explicit water.
- Template `isWaterOnWedge(reader, cell, coord)` — fills LocalAreaInfo via `reader->fillLocalAreaInfo(...)` then delegates.
- `cellHasWater` → cell not empty AND block ≠ Solid AND (block == Empty OR water-on-wedge).
- `interpretAsWaterCell` → original cell if empty-with-water; `Constants::kWaterOnWedgeCell` if wedge-with-water; else `Constants::kUniqueEmptyCellRepresentation`.

## Gotchas

- Requires reader type to expose `fillLocalAreaInfo(coord, RelevantNeighbors, LocalAreaInfo*)` — compile error otherwise (duck-typed template).
- Tables assume `MAX_CELL_ORIENTATIONS == 4` ordering; reordering CellOrientation breaks every table silently.
- Anonymous-namespace tables in a header = one copy per TU including the .inl (code bloat, but ODR-safe).
- `interpretAsWaterCell` returns sentinel cells from voxel Constants — comparisons against these sentinels must use full-cell equality.

## UNKNOWN

- Values of `Constants::kWaterOnWedgeCell` / `kUniqueEmptyCellRepresentation` (voxel Constants.cpp).
