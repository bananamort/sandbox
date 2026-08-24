# App/include/v8world/Cylinder.h

## Purpose

Cylinder geometry (`GEOMETRY_CYLINDER`) — but note it derives straight from `Geometry`, **not** `Poly`, and collides exclusively via Bullet (`COLLIDE_BULLET`). Implements the same dragger/surface interface as [Ball.md](Ball.md).

## Declared API

- `class Cylinder : public Geometry`
  - Pool: `GeometryPool<Vector3, BulletCylinderShapeWrapper, Vector3Comparer> BulletCylinderShapePool` + token member.
  - Members: `float realLength, realWidth;` set by `setSize(const Vector3&)` override.
  - Types: `getGeometryType() → GEOMETRY_CYLINDER`; `getCollideType() → COLLIDE_BULLET`.
  - Physics: `Matrix3 getMoment(float) const`; `float getVolume()`; `float getRadius()`; `Vector3 getCenterToCorner(const Matrix3&) const`; `hitTest(ray, hitPoint, normal)`; `bool setUpBulletCollisionData()`.
  - Dragger/surface API: `closestSurfaceToPoint`, `getPlaneFromSurface(size_t)`, `getSurfaceCoordInBody(size_t)`, `getSurfaceNormalInBody(size_t)`, `getMostAlignedSurface(vecInWorld, objectR)`, `getNumSurfaces()`, `getSurfaceVertInBody(size_t, int)`, `getNumVertsInSurface(size_t)`, `vertOverlapsFace(pointInBody, surfaceId)`.
  - Cluster queries: `findTouchingSurfacesConvex(...)`, `FacesOverlapped(...)`, `FaceVerticesOverlapped(...)`, `FaceEdgesOverlapped(...)` — all override declarations (bodies in .cpp).
  - Private: `void updateBulletCollisionData();`

## Gotchas

- No analytic RBX-vs-RBX contact path here (no Poly mesh, `COLLIDE_BULLET`) — cylinder collisions go through the Bullet bridge contacts ([BulletShapeContact.md](BulletShapeContact.md)).
- `realLength`/`realWidth` naming: length is along the cylinder axis, width = diameter; exact mapping is in .cpp.

## UNKNOWN

- Surface count returned by `getNumSurfaces()` for cylinders (implementation-only).

## Cross-links

- Base: [Geometry.md](Geometry.md); Bullet hull pool: [BulletGeometryPoolObjects.md](BulletGeometryPoolObjects.md), pooling: [GeometryPool.md](GeometryPool.md). Buoyancy subclass: [Buoyancy.md](Buoyancy.md) (`BuoyancyCylinderContact` reuses box math).
