# App/include/v8world/PyramidMesh.h

## Purpose

Pooled payload for parametric pyramid meshes, keyed by `Vector3_2Ints` (size + sides/slices) — prism sibling of [PrismMesh.md](PrismMesh.md) using `mesh.makePyramid`.

## Declared API

- `namespace RBX::POLY { class PyramidMesh : public Allocator<PyramidMesh> }`
  - Members: `Mesh mesh; int NumSides; int NumSlices; Vector3 LocalCofM;`
  - Ctor `(const Vector3_2Ints& params)` — zero sides/slices "cause immediate bail out of mesh builder for speed"; seeds `LocalCofM = zero()` then builds.
  - `const Mesh* getMesh() const;` `void SetNumSides(int)/SetNumSlices(int);` `const Vector3& GetLocalCofMFromMesh() const;`

## Gotchas

- Same vestigial-setter suspicion as PrismMesh: `SetNumSides/SetNumSlices` write members unused within this header.
- Degenerate (zero-param) entries can exist in the pool by design.

## Cross-links

- Consumer: [PyramidPoly.md](PyramidPoly.md); builder: [Mesh.md](Mesh.md) (`makePyramid`); key: [GeometryPool.md](GeometryPool.md).
