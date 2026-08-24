# App/include/v8world/MegaClusterPoly.h

## Purpose

Legacy voxel-terrain geometry (`GEOMETRY_MEGACLUSTER`): a Poly whose true shape is the terrain cell grid managed by `TerrainPartitionMega`. Builds per-cell Bullet convex-hull shapes (cube, vertical/horizontal wedge, corner wedge, inverse corner wedge), implements terrain raycasts with per-cell-type hit tests, and answers cluster-vs-geometry touch queries.

## Declared API

- File-scope constants: `MC_SEARCH_RAY_MAX = 2048.0f` ("was 500.0f, but normal mouse has range coded to be 2048.0f"), `MC_RAY_ZERO_SLOPE_TOLERANCE = .0005f`, `MC_HUGE_VAL = 9999999`.
- `class MegaClusterPoly : public Poly`
  - Pool: `GeometryPool<Vector3, POLY::MegaClusterMesh, Vector3Comparer> MegaClusterMeshPool` (token `aMegaClusterMesh`).
  - Members: `Primitive* myPrim; scoped_ptr<TerrainPartitionMega> myTerrainPartition; std::vector<btConvexHullShape*> bulletCellShapes;`
  - Ctors: `(Primitive* p)` / dtor.
  - Bullet: `setUpBulletCollisionData() { return false; }` — **no single shape** (cells are individual shapes); `btConvexHullShape* getBulletCellShape(Voxel::CellBlock shape);` private creators: cube / vertical-wedge / horizontal-wedge / corner-wedge / inverse-corner-wedge.
  - Raycasts: `bool hitTest(rayInMe, localHitPoint, surfaceNormal, float searchRayMax = MC_SEARCH_RAY_MAX, bool treatCellsAsBlocks = false, bool ignoreWater = false)` — note **extended signature** vs base Geometry::hitTest; `virtual bool hitTestTerrain(rayInMe, localHitPoint, int& surfId, CoordinateFrame& surfCf);` private per-cell hit helpers (`hitLocationOnBlockCell/VerticalWedgeCell/HorizontalWedgeCell/CornerWedgeCell/InverseCornerWedgeCell`) and `hitTestMC(...)`.
  - Touch queries: `findCellsTouchingGeometry(myCf, otherGeom, otherCf, std::vector<Vector3int16>* found)`, `findCellsTouchingGeometryWithBuffer(float&, ...)`, `findPlanarTouchesWithGeom(...)`, `std::vector<Vector3> findCellIntersectionWithGeom(cell, ...)`, `hasPlanarTouchWithGeom(...)`, `bool cellsInBoundingBox(min, max)`.
  - Overrides: `getSize()` → Super (explicit re-expose), `getGeometryType() → GEOMETRY_MEGACLUSTER`, `Matrix3 getMoment(mass) { return Matrix3::identity(); }`, `getCofmOffset() { return Vector3::zero(); }`, `getSurfaceCoordInBody(size_t)`, `getFaceFromLegacyNormalId(NormalId)`, `buildMesh()`, `isGeometryOrthogonal() { return false; }`, `findTouchingSurfacesConvex(...)`.

## Gotchas

- `hitTest` here takes extra parameters — calling it through a `Geometry*` uses only the base 3-arg signature and loses `treatCellsAsBlocks`/`ignoreWater`.
- Moment of inertia is identity × mass-scale semantics are implementation-defined; terrain primitives aren't meant to simulate as rigid bodies.
- `bulletCellShapes` raw pointers — lifetime tied to the poly (created in `createBulletCellShapes`).

## Cross-links

- Partition data: [TerrainPartition.md](TerrainPartition.md); payload: [MegaClusterMesh.md](MegaClusterMesh.md); base: [Poly.md](Poly.md), [Primitive.md](Primitive.md).
- Smooth-terrain successor geometries & grids: [../voxel2/INDEX.md](../voxel2/INDEX.md), [../voxel/INDEX.md](../voxel/INDEX.md).
