# App/include/v8datamodel/TerrainRegion.h

## Purpose

`TerrainRegion` — creatable `Instance` holding a self-contained chunk of terrain voxels: either a legacy `Voxel::Grid` ("mega") or a smooth `Voxel2::Grid`, with integer-cell extents and BinaryString packaged payloads for serialization; supports copying into live terrain grids and converting mega→smooth.

## Declared API

`class TerrainRegion : public DescribedCreatable<TerrainRegion, Instance, sTerrainRegion>`

- Ctors: default; `TerrainRegion(const Voxel::Grid* otherGrid, const Region3int16& regionExtents)`; `TerrainRegion(const Voxel2::Grid* otherGrid, const Region3int16& regionExtents)`; virtual dtor.
- Copy-out: `void copyTo(Voxel::Grid& otherGrid, const Vector3int16& corner, bool copyEmptyCells)` + Voxel2 overload.
- Conversion: `void convertToSmooth()`.
- Geometry: `Vector3 getSizeInCells() const`; inline `getExtentsMin()/getExtentsMax()` (Vector3int16) + setters.
- State: inline `bool isSmooth() const { return !!smoothGrid; }`.
- Serialized payloads: `setPackagedGridV3(const BinaryString&)` / `getPackagedGridV3()` (mega grid); `setPackagedSmoothGrid(const BinaryString& clusterData)` / `getPackagedSmoothGrid()`.
- Override: `virtual bool askSetParent(const Instance* parent) const`.
- Private: `scoped_ptr<Voxel::Grid> voxelGrid`, `scoped_ptr<Voxel2::Grid> smoothGrid`, extents pair, initializers `initializeGridMega()/initializeGridSmooth()`.

## Gotchas

- Dual-grid representation: exactly one of voxelGrid/smoothGrid meaningful at a time (isSmooth checks the pointer).
- Extents are in voxel CELL coordinates (Vector3int16), while getSizeInCells returns Vector3 — mixed math types invite truncation bugs.
- Per project recon: voxel2 material-id ordering is the SERIALIZED encoding (Conversion.h kMaterialTable) — never reorder when touching these payloads.

## UNKNOWN

- Whether both grids can coexist transiently during convertToSmooth (out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/TerrainRegion.md](../../v8datamodel/TerrainRegion.md).
- Grid layer: App/include/voxel + voxel2 docs (see root include INDEX); live terrain: [Workspace.md](Workspace.md); listener consumer: [PathfindingService.md](PathfindingService.md).
