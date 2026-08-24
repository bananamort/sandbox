# App/include/v8world/BulletGeometryPoolObjects.h

## Purpose

Pooled Bullet collision shapes keyed by geometry size, consumed through [GeometryPool.md](GeometryPool.md) by the shape classes ([Ball.md](Ball.md), [Block.md](Block.md), wedges, cylinder, mesh decompositions).

## Declared API

- Build switch: `#define USE_GIMPACT` — selects `btGImpactConvexDecompositionShape` for `BulletDecompWrapper::ShapeType`; comment it out to fall back to `btCompoundShape` ("more robust narrow phase").
- Global: `const float bulletCollisionMargin = 0.05f;`
- `class BulletDecompWrapper : public Allocator<...>` — convex decomposition from a serialized string:
  - `BulletDecompWrapper(const std::string& str); ~BulletDecompWrapper();`
  - `const ShapeType* getCompound() const;` `const std::vector<ConvexExtents>& getExtentArray() const;` with nested `struct ConvexExtents { Vector3 center; Vector3 size; };`
  - Members: `ShapeType* decomp; std::vector<ConvexExtents> extentArray;`
- Simple wrappers (each Allocator-typed, ctor takes the pool key, `getShape()` accessor):
  - `BulletBoxShapeWrapper(const Vector3& key)` → `btBoxShape*`
  - `BulletSphereShapeWrapper(const float& key)` → `btSphereShape*`
  - `BulletCylinderShapeWrapper(const Vector3& key)` → `btCylinderShape*`
  - `BulletWedgeShapeWrapper(const Vector3& key)` → `btConvexHullShape*`
  - `BulletCornerWedgeShapeWrapper(const Vector3& key)` → `btConvexHullShape*`

## Gotchas

- Flipping `USE_GIMPACT` changes the decomposition shape type **and** narrow-phase robustness characteristics — a build-level behavior toggle, not an implementation detail.
- Wedge and corner-wedge both use generic convex hulls (no dedicated Bullet primitive).
- `bulletCollisionMargin` is a file-scope constant in the RBX namespace-less global space — name collisions possible.

## UNKNOWN

- Wire format of the `std::string` fed to `BulletDecompWrapper` (parsed in .cpp; presumably serialized convex pieces + indices).

## Cross-links

- Pool machinery: [GeometryPool.md](GeometryPool.md); consumers: [Ball.md](Ball.md), [Block.md](Block.md), [Mesh.md](Mesh.md).
