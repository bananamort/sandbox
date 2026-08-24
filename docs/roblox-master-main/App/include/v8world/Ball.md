# App/include/v8world/Ball.h

## Purpose

Sphere geometry (`GEOMETRY_BALL`) — the shape behind Ball parts. Radius is `size.x/2`; Bullet collision shape comes from a pooled `GeometryPool<float, BulletSphereShapeWrapper>` token. Also implements the 6-pseudo-"surface" interface the Dragger tooling uses.

## Declared API

- `class Ball : public Geometry`
  - `typedef GeometryPool<float, BulletSphereShapeWrapper, FloatComparer> BulletSphereShapePool;` member `Token bulletSphereShape;`
  - `float getRadius() const` (realRadius, kept in sync by `setSize` override); `getCenterToCorner(const Matrix3&) → Vector3(r,r,r)`.
  - `getGeometryType() → GEOMETRY_BALL`; `getCollideType() → COLLIDE_BALL`.
  - `Matrix3 getMoment(float mass) const` — solid-sphere inertia (`getMomentSolid`, private).
  - `float getVolume() const;`
  - `bool hitTest(const RbxRay& rayInMe, Vector3& localHitPoint, Vector3& surfaceNormal)` override.
  - Dragger support: `closestSurfaceToPoint(const Vector3& pointInBody) → size_t`, `getPlaneFromSurface(size_t) → Plane`, `getSurfaceCoordInBody(size_t) → CoordinateFrame`, `getSurfaceNormalInBody(size_t)`, `getMostAlignedSurface(const Vector3&, const Matrix3&)`, `int getNumSurfaces()` (**hardcoded 6**), `getSurfaceVertInBody(size_t, int vertId)`, `getNumVertsInSurface(size_t)`, `vertOverlapsFace(const Vector3&, size_t)`.
  - Cluster-mesh queries: `findTouchingSurfacesConvex(...) → {return false;}` inline; `FacesOverlapped/FaceVerticesOverlapped/FaceEdgesOverlapped(...) → {RBXASSERT(0); return false;}` inline stubs.
  - `bool setUpBulletCollisionData(void)` override.

## Gotchas

- The "6 surfaces" are a fiction to satisfy the box-oriented dragger/surface API on a sphere.
- `FacesOverlapped`/`FaceVerticesOverlapped`/`FaceEdgesOverlapped` assert and return false — never call them on balls in release either; results are meaningless.
- `Ball()` initializes `realRadius(0.0)` only; radius becomes valid after a size is pushed through `setSize`.

## Cross-links

- Base class: [Geometry.md](Geometry.md), pooling: [GeometryPool.md](GeometryPool.md), [BulletGeometryPoolObjects.md](BulletGeometryPoolObjects.md).
- Kernel-side ball connectors: [v8kernel/PolyConnectors.md](../v8kernel/PolyConnectors.md) (Ball vertex/edge/plane), contact math: [v8kernel/ContactConnector.md](../v8kernel/ContactConnector.md).
