# App/include/v8world/Geometry.h

## Purpose

Abstract base for all collision geometry: owns the part size, an optional embedded Bullet `btCollisionObject`, and the shape taxonomy (`GeometryType`/`CollideType`) plus the dragger "surface" interface every concrete shape must implement.

## Declared API

- `class Geometry`
  - Members: private `Vector3 size;` protected `boost::scoped_ptr<btCollisionObject> bulletCollisionObject;` accessor `getBulletCollisionObject()`.
  - `enum GeometryType { GEOMETRY_UNDEFINED=0, GEOMETRY_BALL, GEOMETRY_BLOCK, GEOMETRY_CYLINDER, GEOMETRY_WEDGE, GEOMETRY_PRISM, GEOMETRY_PYRAMID, GEOMETRY_PARALLELRAMP, GEOMETRY_RIGHTANGLERAMP, GEOMETRY_CORNERWEDGE, GEOMETRY_MEGACLUSTER, GEOMETRY_SMOOTHCLUSTER, GEOMETRY_TRI_MESH };`
  - `enum CollideType { COLLIDE_BALL=1, COLLIDE_BLOCK, COLLIDE_POLY, COLLIDE_BULLET };`
  - Pure virtuals: `getGeometryType()`, `getCollideType()`, `float getRadius()`, `bool setUpBulletCollisionData()`.
  - Dragger surface set (pure): `closestSurfaceToPoint(pointInBody)`, `getPlaneFromSurface(size_t)`, `getSurfaceCoordInBody(size_t)`, `getSurfaceNormalInBody(size_t)`, `getMostAlignedSurface(vecInWorld, objectR)`, `getNumSurfaces()`, `getSurfaceVertInBody(size_t,int)`, `getNumVertsInSurface(size_t)`, `vertOverlapsFace(pointInBody, surfaceId)`.
  - Virtuals with defaults: `setSize`/`getSize`; `setGeometryParameter/getGeometryParameter` — **RBXASSERT(0)** ("stock geometry does not handle parameters"); `getFaceFromLegacyNormalId(NormalId)` = identity; `isGeometryOrthogonal()` = true; `getCenterToCorner(Matrix3)` = zero; `getCofmOffset()` = zero; `getMoment(mass)` = **zero matrix**; `getVolume()` = x·y·z; `hitTest(...)` = false; `collidesWithGroundPlane(cf, yHeight)` = radius test; `polygonIntersectionWithFace(...)` = empty; `hitTestTerrain(...)` = false.
  - Cluster RTTI: `bool isTerrain()` (MEGACLUSTER ∪ SMOOTHCLUSTER).
  - Relative-proximity pure virtuals: `findTouchingSurfacesConvex`, `FacesOverlapped`, `FaceVerticesOverlapped`, `FaceEdgesOverlapped`.

## Gotchas

- Default `getMoment()` returns zero inertia and default `getCofmOffset()` zero offset — a new Geometry subclass that forgets these overrides simulates with degenerate mass properties rather than erroring.
- `setGeometryParameter` asserts in the base: only special geometries (e.g. clusters) accept parameters.
- The dragger surface API is mandatory even for spheres ([Ball.md](Ball.md) fakes 6 surfaces).

## Cross-links

- Implementations: [Ball.md](Ball.md), [Block.md](Block.md), [Cylinder.md](Cylinder.md), [Poly.md](Poly.md), [Mesh.md](Mesh.md), cluster geometries.
- Kernel consumption of moment/CoFm: [v8kernel/SimBody.md](../v8kernel/SimBody.md), [v8kernel/Cofm.md](../v8kernel/Cofm.md).
