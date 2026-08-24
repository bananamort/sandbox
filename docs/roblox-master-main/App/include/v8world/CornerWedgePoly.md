# App/include/v8world/CornerWedgePoly.h

## Purpose

Corner-wedge geometry (`GEOMETRY_CORNERWEDGE`) as a `Poly`: triangular-prism corner shape with asymmetric mass distribution (custom moment + center-of-mass offset) and its own legacy-surface → face mapping. Pools mesh and Bullet convex hull by size.

## Declared API

- `class CornerWedgePoly : public Poly`
  - Pools: `GeometryPool<Vector3, POLY::CornerWedgeMesh, Vector3Comparer> CornerWedgeMeshPool` (token `aCornerWedgeMesh`), `GeometryPool<Vector3, BulletCornerWedgeShapeWrapper, Vector3Comparer>` (token `bulletCornerWedgeShape`).
  - Overrides (public): `Matrix3 getMoment(float mass) const;` `Vector3 getCofmOffset() const;` — **non-zero CoM offset**, unlike symmetric shapes; `CoordinateFrame getSurfaceCoordInBody(const size_t surfaceId) const;` `bool isGeometryOrthogonal(void) const {return false;}` (inline); `bool setUpBulletCollisionData(void);` `void setSize(const G3D::Vector3&)`.
  - Protected: `getGeometryType() → GEOMETRY_CORNERWEDGE` (inline), `void buildMesh();`, `size_t getFaceFromLegacyNormalId(const NormalId nId) const;` — remaps the 6-way NormalId scheme onto the wedge's faces, `Vector3 getCenterToCorner(const Matrix3&) const;` private.
  - Private: `void updateBulletCollisionData();`

## Gotchas

- `isGeometryOrthogonal() == false` excludes it from orthogonal-only fast paths (face-normal shortcuts); generic poly code must be used.
- Because the CoM is off-center, physics results differ between corner wedges and mirrored orientations — do not "simplify" by using bounding-box center.

## Cross-links

- Base: [Poly.md](Poly.md), [Geometry.md](Geometry.md); payload: [CornerWedgeMesh.md](CornerWedgeMesh.md); Bullet hull: [BulletGeometryPoolObjects.md](BulletGeometryPoolObjects.md).
- Wedge sibling: [WedgePoly.md](WedgePoly.md).
