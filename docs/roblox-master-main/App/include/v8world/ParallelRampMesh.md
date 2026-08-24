# App/include/v8world/ParallelRampMesh.h

## Purpose

Pooled payload for the parallel-ramp shape: builds one `Mesh` via `mesh.makeParallelRamp(size, LocalCofM)` and caches the ramp's local center of mass (which is off-center for a ramp).

## Declared API

- `namespace RBX::POLY { class ParallelRampMesh : public Allocator<ParallelRampMesh> }`
  - `ParallelRampMesh(const Vector3& size)` — fills `Mesh mesh` and `Vector3 LocalCofM`.
  - `const Mesh* getMesh() const;` `const Vector3& GetLocalCofMFromMesh() const;`

## Gotchas

- Same pattern as [CornerWedgeMesh.md](CornerWedgeMesh.md): derived CoFm lives in the pooled payload; consumers must use it rather than assume symmetric mass.
- Allocator-typed; instantiate via the pool only.

## Cross-links

- Consumer: [ParallelRampPoly.md](ParallelRampPoly.md); mesh: [Mesh.md](Mesh.md); pooling: [GeometryPool.md](GeometryPool.md).
