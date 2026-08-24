# App/include/v8world/CornerWedgeMesh.h

## Purpose

Pooled payload for the corner-wedge shape: builds one `Mesh` via `mesh.makeCornerWedge(size, LocalCofM)` and caches the wedge's **off-center** local center of mass produced by that call.

## Declared API

- `namespace RBX::POLY { class CornerWedgeMesh : public Allocator<CornerWedgeMesh> }`
  - `CornerWedgeMesh(const Vector3& size)` — ctor fills `Mesh mesh` and `Vector3 LocalCofM` through `makeCornerWedge`.
  - `const Mesh* getMesh() const;`
  - `const Vector3& GetLocalCofMFromMesh() const;` *(sic: "CofM", PascalCase)*

## Gotchas

- Unlike [BlockMesh.md](BlockMesh.md), the pooled object carries derived data (LocalCofM) — consumers must take it from here rather than recomputing.
- Allocator-typed; instantiate via the pool only.

## Cross-links

- Consumer: [CornerWedgePoly.md](CornerWedgePoly.md); mesh type: [Mesh.md](Mesh.md); pooling: [GeometryPool.md](GeometryPool.md).
