# App/include/voxel/Voxelizer.h

## Purpose

Rasterizes part geometry into `OccupancyChunk` byte grids (32×16×32) for terrain-vs-part collision occupancy: one fill function per shape family (block/sphere/ellipsoid/cylinders/wedges/torso/mesh), terrain fills from both the legacy Voxel grid and the Voxel2 smooth-voxel grid, with SIMD variants and a deferred two-phase update path via `DataModelPartCache`.

## Declared API

- Chunk constants (namespace RBX): `kVoxelChunkSizeXZ = 32`, `kVoxelChunkSizeY = 16`, `const Vector3int32 kVoxelChunkSize(32,16,32)`.
- `struct OccupancyChunk { unsigned int dirty; unsigned int age; Vector3int32 index; unsigned char occupancy[16][32][32]; Extents getChunkExtents() const; }`
- Forward decls: `MegaClusterInstance`, `ContactManager`, `PartInstance`, `Voxel::Grid`, `Voxel2::Grid`; `struct DataModelPartCache;`
- `class Voxelizer`
  - `Voxelizer(bool collisionTransparency = false);`
  - One-shot: **`void occupancyUpdateChunk(OccupancyChunk& chunk, MegaClusterInstance* terrain, ContactManager* contactManager);`**
  - Two-phase split: `occupancyUpdateChunkPrepare(chunk, terrain, contactManager, std::vector<DataModelPartCache>& partCache)` + `occupancyUpdateChunkPerform(const std::vector<DataModelPartCache>&);`
  - Toggle: `setNonFixedPartsEnabled(bool)/getNonFixedPartsEnabled()` (inline).
  - Private terrain fills: `occupancyFillTerrainMega(+SIMD)(chunk, Voxel::Grid&, chunkOffset, chunkExtents)`; `occupancyFillTerrainSmooth(+SIMD)(chunk, Voxel2::Grid&, chunkExtents)`.
  - Private shape fills, common signature `(chunk, chunkExtents, Vector3 extents, CoordinateFrame cframe, float transparency[, float meshRadius])`: Block (+DF / DFAA / DFSIMD analytic-distance variants), Sphere, Ellipsoid, CylinderX, CylinderY, Wedge, CornerWedge, Torso, Mesh.
  - `addMeshToPartCache(partCache, PartInstance*, chunk, ...)` — defers mesh work into the cache.
  - Template `occupancyFillDF<DistanceFunction>(...)` — generic distance-field filler.
  - `float getEffectiveTransparency(PartInstance*);`
  - Flags: `bool useSIMD; bool nonFixedPartsEnabled; bool collisionTransparency;`
- `struct DataModelPartCache` — deferred fill record: member function pointer `typedef void (Voxelizer::*pfn)(OccupancyChunk&, const Extents&, const Vector3&, const CoordinateFrame&, float, float);` plus `pfn fillFunc; OccupancyChunk* chunk; Vector3 extents; CoordinateFrame cframe; float transparency; float meshRadius;` ctor defaults meshRadius=0.

## Gotchas

- The two-phase Prepare/Perform split exists so DataModel queries happen in one phase and world mutation in another — calling Perform without Prepare on the same cache vector is a logic error.
- `collisionTransparency` mode treats transparent parts as collidable (or vice versa — semantics set by ctor flag consumers); `getEffectiveTransparency` is the policy point.
- Occupancy array indexing is `[y][z][x]` per the declaration order — transposing indices silently reads wrong cells.
- `DataModelPartCache` stores a raw `OccupancyChunk*` — chunks must outlive the deferred perform phase.

## UNKNOWN

- Which shapes route to DF vs analytic fills at runtime (dispatch lives in Voxelizer.cpp).
