# App/include/v8world/WedgePoly.h

## Purpose

Standard wedge geometry (`GEOMETRY_WEDGE`) as a `Poly`: triangular-prism ramp with remapped legacy faces, off-center mass properties, and — unlike the ramps/prisms/pyramids — a real pooled **Bullet convex hull** shape.

## Declared API

- `class WedgePoly : public Poly`
  - Pools: `GeometryPool<Vector3, POLY::WedgeMesh, Vector3Comparer> WedgeMeshPool` (token `wedgeMesh`), `GeometryPool<Vector3, BulletWedgeShapeWrapper, Vector3Comparer> BulletWedgeShapePool` (token `bulletWedgeShape`).
  - Overrides: `Matrix3 getMoment(float mass) const;` `Vector3 getCofmOffset() const;` `CoordinateFrame getSurfaceCoordInBody(size_t) const;` `size_t getFaceFromLegacyNormalId(NormalId) const;` inline `isGeometryOrthogonal() → false`; `bool setUpBulletCollisionData(void);` (real implementation, unlike ramps); `void setSize(const Vector3&);`
  - Private: `Vector3 getCenterToCorner(const Matrix3&) const;` `void updateBulletCollisionData();`
  - Protected: `getGeometryType() → GEOMETRY_WEDGE`; `buildMesh();`

## Gotchas

- Non-orthogonal: legacy NormalIds must go through the face remap.
- Has both analytic poly contacts and a Bullet hull — collision path depends on which contact machinery engages it ([BulletShapeContact.md](BulletShapeContact.md) vs [PolyContact.md](PolyContact.md)).

## Cross-links

- Base: [Poly.md](Poly.md); payload: [WedgeMesh.md](WedgeMesh.md); Bullet hull: [BulletGeometryPoolObjects.md](BulletGeometryPoolObjects.md). Corner sibling: [CornerWedgePoly.md](CornerWedgePoly.md).
