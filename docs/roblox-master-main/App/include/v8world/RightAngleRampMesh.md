# App/include/v8world/RightAngleRampMesh.h

## Purpose

Pooled payload for right-angle ramp meshes: builds via `mesh.makeRightAngleRamp(size, LocalCofM)` and caches the off-center local center of mass.

## Declared API

- `namespace RBX::POLY { class RightAngleRampMesh : public Allocator<RightAngleRampMesh> }`
  - `RightAngleRampMesh(const Vector3& size);`
  - `const Mesh* getMesh() const;` `const Vector3& GetLocalCofMFromMesh() const;`

## Gotchas

- CoFm is derived data of the pooled payload — consumers must use it (ramps are not mass-symmetric).
- Allocator-typed; pool-only instantiation.

## Cross-links

- Consumer: [RightAngleRampPoly.md](RightAngleRampPoly.md); builder: [Mesh.md](Mesh.md); pooling: [GeometryPool.md](GeometryPool.md).
