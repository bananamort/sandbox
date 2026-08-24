# App/include/voxel2/Conversion.h

## Purpose

Bridges legacy blocky terrain ([../voxel/Grid.md](../voxel/Grid.md)) to the smooth Voxel2 representation: occupancy-level mapping of old CellBlock shapes, PartMaterial↔voxel-material tables, and a full `convertToSmooth` grid migration. All header-inline.

## Declared API

Namespace `RBX::Voxel2::Conversion`:

- Occupancy constants (derived from [Grid.md](Grid.md) `Cell::Occupancy_Max`=255): `kOccupancySolid = 255`, `kOccupancyWedge = 127`, `kOccupancyCorner = 85`, `kOccupancyInverseCorner = 170`.
- `static const PartMaterial kMaterialTable[]` — 16 entries in fixed order: Air, Water, Grass, Slate, Concrete, Brick, Sand, WoodPlanks, Rock, Glacier, Snow, Sandstone, Mud, Basalt, Ground, CrackedLava.
- `static const int kMaterialDefault = 2;` (Grass is the fallback).
- `unsigned char getOccupancyFromSolidBlock(Voxel::CellBlock)` — Solid→255; Vertical/HorizontalWedge→127; CornerWedge→85; InverseCornerWedge→170; default asserts false → 0.
- `Voxel::CellBlock getCellBlockFromCell(const Cell&)` — quantizes occupancy back to block shapes with rounder = Max/6: Air or <(85−r)→Empty, <(127−r)→CornerWedge, <(170−r)→VerticalWedge, <(255−r)→InverseCornerWedge, else Solid.
- `PartMaterial getMaterialFromVoxelMaterial(unsigned char)` — table lookup with kMaterialDefault fallback on overflow; `unsigned char getVoxelMaterialFromMaterial(PartMaterial)` — reverse linear scan, default fallback.
- `getMaterialFromCellMaterial(Voxel::CellMaterial)` — switch folding many legacy materials onto modern ones (Granite/Gravel/Stone_Block→Slate; Asphalt/Cinder/Cement→Concrete; Wood_Plank+Log→WoodPlanks); default→table[default].
- `getCellMaterialFromMaterial(PartMaterial)` — partial inverse (only 8 cases handled; default→CELL_MATERIAL_Grass!).
- **`void convertToSmooth(const Voxel::Grid& oldGrid, Voxel2::Grid& grid)`** — per non-empty chunk: reads a Region view, iterates y/z/x filling a 32×16×32 Box: explicit water cells → `(Material_Water, OccMax)`; solids → material mapped through getMaterialFromCellMaterial∘getVoxelMaterialFromMaterial + occupancy from block; empty old cells left as Air; writes each box into the new grid over the chunk extents (+1 exclusive max).

## Gotchas

- The conversion is **lossy by design**: wedge orientations and corner shapes collapse into bare occupancy levels (127/85/170), so smooth terrain can approximate but not reconstruct original block geometry.
- `getCellMaterialFromMaterial` returns Grass for any unmapped PartMaterial (Basalt, Snow, etc.) — not symmetric with its forward twin.
- `kMaterialTable` order IS the voxel material id encoding used in saved/streamed data — reorder breaks compatibility.
- Declared `static const` at namespace scope in a header: every TU gets its own copy (bloat + ODR-safe but address-distinct).

## UNKNOWN
- Where convertToSmooth is invoked (migration tooling vs runtime upgrade path).
