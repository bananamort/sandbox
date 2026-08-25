# App/include/voxel2/MaterialTable.h

## Purpose

Data-driven material definitions for smooth-voxel terrain rendering: loaded from a file, each material names its texture layers (top/side/bottom), a Type (soft/hard blend), UV Mapping mode, and a Deformation shape with a float parameter. Also carries layer tiling data and atlas layout.

## Declared API

- `class MaterialTable`
  - Nested enums:
    - `Type { Type_Soft, Type_Hard, Type_HardSoft }`
    - `Deformation { Deformation_None, Deformation_Shift, Deformation_Cubify, Deformation_Quantize, Deformation_Barrel, Deformation_Water }`
    - `Mapping { Mapping_Default, Mapping_Cube }`
  - `struct Material { std::string name; int topLayer; int sideLayer; int bottomLayer; Type type; Mapping mapping; Deformation deformation; float parameter; }` (note mixed indentation on sideLayer — historical).
  - `struct Layer { float tiling; float detiling; }`
  - `struct Atlas { int width, height, tileSize, tileCount, borderSize; }`
  - `MaterialTable(const std::string& file, unsigned int materialCount);` `~MaterialTable();`
  - Accessors: `getMaterial(index)`, `getMaterialCount()`, `getLayer(index)`, `getLayerCount()`, `getAtlas()` — all inline, **no bounds checks**.
  - Private: `atlas`, `materials`, `layers`, `void load(const std::string& file);`

## Gotchas

- All getters index raw vectors — an out-of-range material id from grid data is UB here, not an exception.
- The format of `file` is defined by load() in the .cpp (not visible from this header); `materialCount` acts as a floor, not an exact match — a short file table is padded with dummy materials (and a failed load leaves only those dummies plus a 1×1 dummy atlas), while a larger file table is kept as-is.
- Material ids in [Grid.md](Grid.md) cells are indices into this table — table order is serialization-relevant.

## UNKNOWN
- (Resolved from App/voxel2/MaterialTable.cpp:) `file` is rapidjson JSON with a `platform` selector, a per-platform `atlas` object (width/height/tileSize/tileCount/borderSize), and a `materials` array keyed by name, texture_top/side/bottom (or single texture), type ("soft"/"hard"/"hardsoft"), mapping ("cube" or default), and optional deformation nodes (shift/cubify/quantize/barrel/water).
