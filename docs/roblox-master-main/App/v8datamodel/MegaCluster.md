# MegaCluster.cpp

## Purpose

Implements `MegaClusterInstance`, registered as Instance name "Terrain" (`sMegaCluster`). This is the game's terrain object: a special `PartInstance` subclass that carries either the legacy blocky voxel grid (`Voxel::Grid`, "mega" terrain, geometry `GEOMETRY_MEGACLUSTER`) or the newer smooth voxel grid (`Voxel2::Grid`, geometry `GEOMETRY_SMOOTHCLUSTER`). It owns the entire script-facing terrain API (GetCell/SetCell through ReadVoxels/FillBall), the wire/place-file serialization of terrain data, and the physics identity of terrain as one giant anchored part sized 2044x252x2044 studs (511*4 x 63*4 x 511*4).

## Key types and API

Enums described here (with Variant converters and StringConverters): `CellMaterial` {Empty(deprecated name), Grass, Sand, Brick, Granite, Asphalt, Iron, Aluminum, Gold, WoodPlank, WoodLog, Gravel, CinderBlock, MossyStone, Cement, RedPlastic, BluePlastic, Water}, `CellBlock` {Solid, VerticalWedge, CornerWedge, InverseCornerWedge, HorizontalWedge}, `CellOrientation` {NegZ, X, Z, NegX}, `WaterForce` {None, Small, Medium, Strong, Max}, `WaterDirection` {NegX, X, NegY, Y, NegZ, Z}.

Properties: `ClusterGrid` (string, write-only, LEGACY — V1 format setter), `ClusterGridV2` (string, write-only, LEGACY), `ClusterGridV3` (BinaryString, CLUSTER category — full getter/setter, current legacy format), `SmoothGrid` (BinaryString, CLUSTER), `SmoothReplicate` (int, REPLICATE_ONLY — -1 unset/0 mega/1 smooth, drives lazy grid choice at replication), `MaxExtents` (read-only Region3int16, UI), `IsSmooth` (read-only bool, UI), `WaterColor` (default 0.05,0.33,0.36), `WaterTransparency` (0.3, clamped [0,1]), `WaterWaveSize` (0.15, clamped >=-FLT_MIN i.e. effectively non-negative), `WaterWaveSpeed` (10, same clamp).

Functions: `GetCell(x,y,z)` → Tuple(material,block,orientation); `SetCell(x,y,z,material,block,orientation)`; `SetCells(region,...)` bulk; `GetWaterCell`/`SetWaterCell`; `AutowedgeCell(x,y,z)`→bool, `AutowedgeCells(region)`; `CellCornerToWorld`/`CellCenterToWorld` (+2,2,2 offset = half cell); `WorldToCellPreferSolid`/`WorldToCellPreferEmpty`/`WorldToCell`; `Clear()`; `CountCells()`; `CopyRegion(region)`→new `TerrainRegion`; `PasteRegion(regionInstance, corner, pasteEmptyCells)` (throws "region has to be a TerrainRegion"); `ConvertToSmooth()` (Security::Plugin; throws outside EDIT mode or under CloudEdit; temporarily unparents itself, converts via Voxel2::Conversion::convertToSmooth, reparents, resets ChangeHistoryService base waypoint); `ReadVoxels(region, resolution)` / `WriteVoxels(region, resolution, materials, occupancy)` implemented as raw `lua_State` CustomBoundFuncDescs; `FillRegion(region, resolution=4 enforced, material)`, `FillBlock(cframe, size, material)`, `FillBall(center, radius, material)`.

All script functions call `validateApi()` ("Terrain API is not available") or `validateApiSmooth()` ("Smooth terrain API is not available") when the corresponding grid was never initialized.

Behavioral overrides of the PartInstance surface: `luaClone` throws "Cannot Clone() Terrain"; `destroy` throws "Cannot Destroy() Terrain"; `resize` throws "Cannot Resize() Terrain"; `getTouchingParts` throws "GetTouchingParts is not a valid member of Terrain"; `setAnchored` always anchors true; size/translation setters are no-ops; `setCoordinateFrame` ignores input and applies the fixed clusterCoordinateFrame; constant property values declared (Archivable=true, BrickColor default, CanCollide=true, Elasticity 0.3, Friction 0.5, Locked=true, Material=Plastic, Reflectance 0, Transparency 0, zero Velocity/RotVelocity, default PhysicalProperties, Name "Terrain"). `verifySetParent` allows only a Workspace that has no other terrain ("Unable to change Terrain's parent. Workspace already has Terrain") and triggers lazy `initialize()`. `onAncestorChanged` registers/unregisters itself with `Workspace::setTerrain`. Destructor clears Workspace terrain pointer and forces geometry back to `GEOMETRY_BLOCK` before the voxel grids die. `destroyJoints()` and `join()` are deliberate no-ops. `render3dSelect` draws nothing (no selection box for terrain).

Serialization: chunk-based run-length encoding. Legacy fixed layout 16x4x16 chunks offset (8,0,8); V1 stores single byte-per-cell stream (`decodeChunkDataFromStreamV1_Deprecated`), V2/V3 store cells then materials streams plus per-chunk header (V3 prefixes each chunk with int16 xyz id). Count values use an escape byte 255 followed by uint16. Empty chunks encode as one run of the unique empty cell + Water material. `reloadMaterialTable()` re-reads `rbxasset://terrain/materials.json`, destroys all contacts on the terrain primitive, rebuilds smooth chunks, rechecks terrain contacts.

ReadVoxels details: resolution must be exactly 4 ("Resolution has to be 4"), region must be grid-aligned ("use Region3:ExpandToGrid") and non-empty, Lua-side region capped by `FInt::SmoothTerrainMaxLuaRegion` (default 4,194,304 voxels ≈ 128 MB since each cell is ~32 bytes across two Lua tables), C++-side cap `FInt::SmoothTerrainMaxCppRegion` (64M voxels). Returns two tables (materials, occupancy), both indexed [x][y][z] 1-based, each carrying a `.Size` Vector3; Air occupancy is exactly 0, otherwise `(occupancy+1)/256`. WriteVoxels validates the 3-D array shapes with detailed luaL_error messages, requires every entry be an `Enum.Material` item (checked against the owning descriptor) and numeric occupancy; Air material, occupancy <=0, or NaN/Inf produce an empty cell; occupancy is rounded via `occ*(256)-0.5` clamped to [0,255].

FillBlock: transforms the region into the part's local frame and sets per-voxel occupancy from the min axis distance factor (linear metric, comment notes powf(1/3) would be volumetrically correct but slower); FillBall uses `vradius - d + 0.5` clamp and has a skip-water internal variant (`fillBallInternal(center, radius, material, skipWater)`).

worldToCellWithPreference: tries exact floor cell first; smooth path sorts 27 neighbor candidates by squared distance; legacy path nudges the world position by ±1/2048 epsilon to cross cell borders, then scans 6 face-direction neighbors tracking best solid match and best acceptable water alternative (water accepted when preferring solid; empty-solid-with-water accepted when preferring empty).

FASTINTs: `SmoothTerrainMaxLuaRegion` (4*1024*1024), `SmoothTerrainMaxCppRegion` (64*1024*1024). Log variable TerrainCellListener.

## Usage / reflection touchpoints

One REFLECTION_BEGIN/END block registers everything above against class name "Terrain". The ClusterGrid*/SmoothGrid BinaryString descriptors are how place files (.rbxl/.rbxm via CLUSTER serialization category) and server replication carry terrain payloads; SmoothReplicate being REPLICATE_ONLY lets the receiving side know which grid to lazily construct before any payload arrives. ReadVoxels/WriteVoxels bypass the normal reflection marshalling entirely and manipulate Lua stacks directly for performance. The constants block (kConst*) exists so inherited PartInstance reflection getters return stable values for Terrain.

## Gotchas

- Every mutating API silently no-ops or throws depending on state: before the Terrain is parented under a Workspace no grid exists and ALL script calls throw "Terrain API is not available".
- On a smooth grid, legacy calls still work but are emulated: AutowedgeCell always returns false, SetCells writes uniform occupancy cells derived from the wedge shape, GetCell reports Solid/NegZ orientation always.
- Empty cells read back as material `Deprecated_Empty` named "Empty", NOT Air-like nil.
- SetCell with CELL_MATERIAL_Water routes into SetWaterCell semantics (solid cell emptied, water force/direction zeroed).
- Terrain cannot be cloned, destroyed, resized, or GetTouchingParts'd — these throw runtime errors rather than returning defaults.
- ConvertToSmooth is Plugin-security and destructive-in-place (grid swap); undo history is truncated via resetBaseWaypoint.
- The legacy grid iteration order matters for speed: data stored Y>Z>X; SetCells traverses in that order deliberately.
- UNKNOWN: where `clusterCoordinateFrame` origin lies relative to world (defined in header/V8World).
