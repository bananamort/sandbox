# App/include/v8world/PrismPoly.h

## Purpose

Parametric prism geometry (`GEOMETRY_PRISM`) as a `Poly`: n-sided, n-slice prism (the classic cylinder-shaped brick), configured through geometry parameters and pooled by size+shape key. Analytic-only collision.

## Declared API

- `class PrismPoly : public Poly`
  - Pool: `GeometryPool<Vector3_2Ints, POLY::PrismMesh, Vector3_2IntsComparer> PrismMeshPool` — keyed on size **and** shape ints; token `prismMesh`.
  - Members: `int numSides; int numSlices;` default ctor zeroes both.
  - Parameter plumbing: `setGeometryParameter(const std::string&, int)` / `getGeometryParameter(...)` overrides — this is the Geometry subclass that accepts parameters ([Geometry.md](Geometry.md) base asserts).
  - Overrides: `getGeometryType() → GEOMETRY_PRISM`; `Matrix3 getMoment(float)`, `Vector3 getCofmOffset()`, `CoordinateFrame getSurfaceCoordInBody(size_t)`, `size_t getFaceFromLegacyNormalId(NormalId)`, `void buildMesh()`; `bool isGeometryOrthogonal() { return false; }`, `bool setUpBulletCollisionData(void) { return false; }` (inline).
  - Private setters: `setNumSides(int)/setNumSlices(int)`.

## Gotchas

- `setUpBulletCollisionData ≡ false`: never route prisms into Bullet-only paths; they rely on analytic `COLLIDE_POLY` contacts.
- Changing sides/slices changes the pool key → new pooled mesh per shape variant.

## UNKNOWN

- The accepted parameter name strings for `setGeometryParameter` (matched in .cpp).

## Cross-links

- Base: [Poly.md](Poly.md); payload: [PrismMesh.md](PrismMesh.md); builder: [Mesh.md](Mesh.md). Buoyancy counterpart treats cylinders via box math: [Buoyancy.md](Buoyancy.md).
