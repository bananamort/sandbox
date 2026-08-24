# App/include/v8world/ParallelRampPoly.h

## Purpose

Parallel-ramp geometry (`GEOMETRY_PARALLELRAMP`) as a `Poly`: wedge-like ramp with parallel top/bottom edges. Analytic-only collision (no Bullet shape), off-center mass properties from the pooled mesh.

## Declared API

- `class ParallelRampPoly : public Poly`
  - Pool: `GeometryPool<Vector3, POLY::ParallelRampMesh, Vector3Comparer> ParallelRampMeshPool` (token `aParallelRampMesh`).
  - Overrides: `Matrix3 getMoment(float mass) const;` `Vector3 getCofmOffset() const;` `bool isGeometryOrthogonal(void) { return false; }` (inline); `bool setUpBulletCollisionData(void) { return false; }` (inline — **always false**, no Bullet shape); `getGeometryType() → GEOMETRY_PARALLELRAMP` (protected inline); `void buildMesh();`

## Gotchas

- `setUpBulletCollisionData` returning false means this shape must never be handed to Bullet-only narrow-phase paths ([Cylinder.md](Cylinder.md)-style) — it relies on analytic `COLLIDE_POLY` contacts.
- Non-orthogonal: excluded from axis-aligned fast paths.

## Cross-links

- Base: [Poly.md](Poly.md), [Mesh.md](Mesh.md) (`makeParallelRamp`); payload: [ParallelRampMesh.md](ParallelRampMesh.md). Sibling ramp: [RightAngleRampPoly.md](RightAngleRampPoly.md).
