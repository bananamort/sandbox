# App/include/v8world/SmoothClusterGeometry.h

## Purpose

Smooth-terrain cluster geometry (`Geometry` subclass, `GEOMETRY_SMOOTHCLUSTER` per [Geometry.md](Geometry.md) taxonomy): wraps a `Voxel2::Grid` region through `TerrainPartitionSmooth`, maintains per-chunk Bullet collision shapes indexed in a dynamic AABB tree (`btDbvt`), and provides terrain raycasts with material identification plus incremental garbage collection of unused chunk shapes.

## Declared API

- `class SmoothClusterGeometry : public Geometry`
  - Nested: `struct ChunkMesh;` (defined in .cpp).
  - Ctor `(Primitive* p)` / dtor. Members: `Primitive* myPrim; Voxel2::Grid* grid; scoped_ptr<TerrainPartitionSmooth> partition; boost::unordered_map<Vector3int32, ChunkMesh*> bulletChunks;` GC cursors (`gcChunkKeyNext/gcChunkCountLast/gcUnusedMemory/gcUnusedMemoryNext`), `btDbvt* bulletChunksTree;`
  - Geometry overrides: `getGeometryType/getCollideType/getRadius`, full dragger surface set, `findTouchingSurfacesConvex/FacesOverlapped/FaceVerticesOverlapped/FaceEdgesOverlapped`, `hitTest(ray, hitPoint, normal)`, `collidesWithGroundPlane(cf, yHeight)`, `setUpBulletCollisionData()`, `hitTestTerrain(ray, hitPoint, int& surfId, CoordinateFrame& surfCf)`.
  - Terrain API: `bool castRay(const RbxRay&, Vector3& localHitPoint, Vector3& surfaceNormal, unsigned char& surfaceMaterial, float maxDistance, bool ignoreWater);` `bool findCellsInBoundingBox(min, max);` chunk maintenance: `updateChunk(const Vector3int32&)`, `updateAllChunks()`, `void garbageCollectIncremental();` `shared_ptr<btCollisionShape> getBulletChunkShape(const Vector3int32& id);` `TerrainPartitionSmooth* getTerrainPartition();`
  - Static: `PartMaterial getTriangleMaterial(btCollisionShape*, unsigned int triangleIndex, const Vector3& localHitPoint);` — maps (chunk shape, triangle, hit point) back to a terrain material.

## Gotchas

- Chunk shapes are shared_ptrs but the `ChunkMesh*` map values are raw — GC exists precisely to retire stale entries incrementally rather than in one hitch.
- Material lookup requires the local hit point — triangle index alone is insufficient (interpolation across vertex materials).

## UNKNOWN

- GC policy constants (how much memory is considered unused / cadence) live in the .cpp.

## Cross-links

- Partition data structure: [TerrainPartition.md](TerrainPartition.md); grid docs: [../voxel2/INDEX.md](../voxel2/INDEX.md); legacy counterpart: [MegaClusterPoly.md](MegaClusterPoly.md).
- Contact creation against clusters: [ContactManager.md](ContactManager.md) (`checkSmoothClusterContact`), cell contacts: [BulletShapeCellContact.md](BulletShapeCellContact.md).
