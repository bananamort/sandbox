# App/include/v8world/WedgeMesh.h

## Purpose

Pooled payload for standard wedge meshes: builds via `mesh.makeWedge(size)` so all same-size wedges share one mesh through the GeometryPool.

## Declared API

- `namespace RBX::POLY { class WedgeMesh : public Allocator<WedgeMesh> }`
  - `WedgeMesh(const Vector3& size)` — builds the wedge in ctor.
  - `const Mesh* getMesh() const;`

## Gotchas

- Unlike [CornerWedgeMesh.md](CornerWedgeMesh.md)/ramp payloads there is **no LocalCofM member** here — `makeWedge` produces no out-param; [WedgePoly.md](WedgePoly.md) computes its CoFm override independently.
- Allocator-typed; pool-only instantiation.

## Cross-links

- Consumer: [WedgePoly.md](WedgePoly.md); builder: [Mesh.md](Mesh.md) (`makeWedge`); pooling: [GeometryPool.md](GeometryPool.md).
