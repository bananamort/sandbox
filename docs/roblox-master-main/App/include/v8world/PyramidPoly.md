# App/include/v8world/PyramidPoly.h

## Purpose

Parametric pyramid geometry (`GEOMETRY_PYRAMID`) as a `Poly`: n-sided pyramid configured via geometry parameters (sides/slices), pooled by size+shape, analytic-only collision.

## Declared API

- `class PyramidPoly : public Poly`
  - Pool: `GeometryPool<Vector3_2Ints, POLY::PyramidMesh, Vector3_2IntsComparer> PyramidMeshPool`; token `pyramidMesh`.
  - Members: `int numSides; int numSlices;` default ctor zeroes both; private `setNumSides/setNumSlices`.
  - Parameter plumbing: `setGeometryParameter/getGeometryParameter` overrides (base [Geometry.md](Geometry.md) asserts — this subclass accepts parameters).
  - Overrides: `getGeometryType() → GEOMETRY_PYRAMID`, `getMoment(float)`, `getCofmOffset()`, `getSurfaceCoordInBody(size_t)`, `getFaceFromLegacyNormalId(NormalId)`, `buildMesh()`; inline `isGeometryOrthogonal() → false`, `setUpBulletCollisionData() → false`.

## Gotchas

- Analytic-only (`setUpBulletCollisionData ≡ false`) — never feed to Bullet-only paths.
- Non-orthogonal; legacy NormalId → face mapping is remapped here.

## Cross-links

- Base: [Poly.md](Poly.md); payload: [PyramidMesh.md](PyramidMesh.md); builder: [Mesh.md](Mesh.md). Prism sibling: [PrismPoly.md](PrismPoly.md).
