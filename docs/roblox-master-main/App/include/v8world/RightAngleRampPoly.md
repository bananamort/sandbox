# App/include/v8world/RightAngleRampPoly.h

## Purpose

Right-angle ramp geometry (`GEOMETRY_RIGHTANGLERAMP`) as a `Poly`: 45°-style ramp wedge. Analytic-only collision, off-center mass, remapped legacy face ids.

## Declared API

- `class RightAngleRampPoly : public Poly`
  - Pool: `GeometryPool<Vector3, POLY::RightAngleRampMesh, Vector3Comparer> RightAngleRampMeshPool` (token `aRightAngleRampMesh`).
  - Overrides: `Matrix3 getMoment(float) const;` `Vector3 getCofmOffset() const;` inline `isGeometryOrthogonal() → false`, `setUpBulletCollisionData() → false`; protected `getGeometryType() → GEOMETRY_RIGHTANGLERAMP`, `buildMesh()`, **`size_t getFaceFromLegacyNormalId(NormalId)`** — remaps the 6-face scheme onto ramp faces.

## Gotchas

- Analytic-only: `setUpBulletCollisionData ≡ false`; keep out of Bullet-only paths.
- Legacy NormalId lookups must go through the remap or they address the wrong faces.

## Cross-links

- Base: [Poly.md](Poly.md); payload: [RightAngleRampMesh.md](RightAngleRampMesh.md). Sibling: [ParallelRampPoly.md](ParallelRampPoly.md); builder: [Mesh.md](Mesh.md).
