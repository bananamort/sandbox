# App/include/voxel/Cell.h

## Purpose

The voxel cell atom: a 1-byte `Cell` union of `SolidTerrainCell` (block shape + orientation) and `WaterCell` (force+direction packed in the same bits), plus the material/block/orientation/water enums, serialization helpers, and chunk/cell size constants.

## Declared API

- `enum CellMaterial` — Grass(1) … Water(17), `CELL_MATERIAL_Unspecified = 255`, `MAX_CELL_MATERIALS = 18`; 0 is `CELL_MATERIAL_Deprecated_Empty`.
- `enum CellBlock` — Solid=0, VerticalWedge=1, CornerWedge=2, InverseCornerWedge=3, HorizontalWedge=4; then "intentionally not reflected" values: Empty=5; `MAX_CELL_BLOCKS = 8`. Comment: "Talk with dignatoff@ before exposing these enums!"
- `enum CellOrientation` — NegZ=0 ("upper left"), X=1, Z=2, NegX=3; "viewed from a downwards vertical perspective… clockwise"; `MAX_CELL_ORIENTATIONS = 4`.
- `enum WaterCellForce` None/Small/Medium/Strong/MaxForce (`MAX_WATER_CELL_FORCES = 5`); `enum WaterCellDirection` ±X/±Y/±Z (`MAX_WATER_CELL_DIRECTIONS = 6`).
- `class SolidTerrainCell` — bitfields `unsigned char DEPRECATED_material : 3; unsigned char block : 3; unsigned char orientation : 2;` (kept for layout compat after material moved out); get/set block+orientation.
- `class WaterCell` — same 8-bit layout as SolidTerrainCell (`dataPart2:3`, `blockMustBeEmpty:3`, `dataPart1:2`); packs `(force*6 + direction) + 1` across the two fields; getters decode force/direction.
- `union Cell` — `solid | water`; ctor memsets to zero (comment explains why setter-based init can't clear DEPRECATED_material); `isEmpty()` (defined below the class, compares against `Constants::kUniqueEmptyCellRepresentation`); `isExplicitWaterCell()` — "water can also exist in wedge cells. Use Region and/or Region::iterator methods … to detect all kinds of water simultaneously" ([Region.md](Region.md), [Water.md](Water.md)); ==/!= compare byte 0 only.
  - Serialization statics (three near-identical pairs): `serializeAsUnsignedChar/deserializeFromUnsignedChar`, `convertToUnsignedCharForFile/readUnsignedCharFromFile`, `asUnsignedCharForDeprecatedUses/readUnsignedCharFromDeprecatedUse` ("Old style voxel access. Avoid using these methods where possible").
- `BOOST_STATIC_ASSERT(sizeof(Cell) == 1);`
- `namespace Constants { extern const Cell kUniqueEmptyCellRepresentation; extern const Cell kWaterOnWedgeCell; }`
- `std::ostream& operator<<(ostream&, const Cell&);`
- Chunk constants: `kXZ_CHUNK_SIZE = 32`, `kY_CHUNK_SIZE = 16`, `kCELL_SIZE = 4` studs, `kHALF_CELL = 2`, `kCELL_SIZE_AS_BIT_SHIFT = 2`.

## Gotchas

- The whole cell is **one byte** shared between solid and water interpretations: writing `solid.block = CELL_BLOCK_Empty` while water data occupies those exact bits is how explicit-water cells are represented — never mix field sets without checking block first.
- Material nibble storage elsewhere ([Util.md](Util.md)) stores material−1 with 0 meaning "see cell" semantics via readMaterial's Empty→Water special case.
- Three serialization pairs are byte-identical implementations kept separate for API history — they are NOT different formats.
- MAX_CELL_MATERIALS (18) ≠ max enum value (255); Unspecified deliberately sits outside the countable range.

## UNKNOWN

- Where kUniqueEmptyCellRepresentation/kWaterOnWedgeCell are defined (voxel Constants.cpp).
