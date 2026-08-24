# TerrainRegion.cpp

## Purpose

Implements `TerrainRegion` ("TerrainRegion"), a standalone terrain chunk Instance holding EITHER a legacy voxel grid (Voxel::Grid, "Mega") OR a smooth-terrain grid (Voxel2::Grid), serialized as packaged binary blobs. Hosts the cell-copy machinery between grids/worlds with 16-bit-extent clamping and the Plugin-only ConvertToSmooth migration.

## Key types and API

Descriptors:
- `prop_Extents("SizeInCells")` — Vector3 read-only (NULL setter), cap UI.
- `prop_ExtentsMin/Max("ExtentsMin"/"ExtentsMax")` — Vector3int16, cap STREAMING.
- `prop_GridV3("GridV3")` — BinaryString legacy-voxel blob, cap **CLUSTER**, **Security::None**; setter ignores empty strings, lazily initializes mega grid, delegates MegaClusterInstance::deserializeGridV3.
- `desc_SmoothGrid("SmoothGrid")` — BinaryString smooth blob, same caps/tiers; Voxel2::Grid serialize/deserialize pair.
- `prop_IsSmooth("IsSmooth")` — bool read-only, cap UI, Security::None.
- `func_convertToSmooth("ConvertToSmooth()")` — **Security::Plugin**.

Copy machinery:
- `copyEmptyVoxels(target, sourceExtents, offset, sourceRegions)`: fills target cells overlapping the region but NOT present in source with kUniqueEmptyCellRepresentation + CELL_MATERIAL_Water (offset==0 fast path vs per-cell offset check).
- `copyVoxels(Voxel overload)`: copies non-empty chunks' cells (+materials), optionally pre-clearing target cells not backed by source when copyEmptyCells.
- `copyVoxels(Voxel2 overload)`: region-box reads/writes; when NOT copying empties it preserves existing target cells by overlaying source AIR cells from the target box row-by-row.
- Ctors from either grid type snapshot extentsMin/Max then copy WITHOUT empty cells; copyTo(corner, copyEmptyCells) computes offset, CLAMPS extents against Voxel::getTerrainExtentsInCells for int16 overflow safety (legacy overload only).
- `convertToSmooth`: throws when already smooth or no legacy grid ("Terrain API is not available"); swaps out old grid, Voxel2::Conversion::convertToSmooth, raises IsSmooth.

## Usage / reflection touchpoints

Script-facing at Security::None for the data properties (blobs are big BinaryStrings). Pairs with MegaCluster.md in this folder (serialization format), PathfindingService.md (voxel consumers).

## Gotchas

- GridV3/SmoothGrid setters silently ignore EMPTY payloads — clearing terrain via property write is impossible.
- initializeGrid* RBXASSERT both-null: setting BOTH GridV3 and SmoothGrid crashes debug builds (first wins, second asserts).
- Legacy copyTo clamps to terrain extents but the SMOOTH copyTo does NOT clamp — large offsets can overflow int16 there too (asymmetric protection).
- askSetParent returns true — regions may live anywhere including workspace (rendering treats them specially elsewhere).
