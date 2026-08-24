# App/include/v8world/PrismMesh.h

## Purpose

Pooled payload for parametric prism meshes, keyed by `Vector3_2Ints` (size + sides/slices ints) — "holds Prism Meshes of same size, and parametric shape".

## Declared API

- `namespace RBX::POLY { class PrismMesh : public Allocator<PrismMesh> }`
  - Members: `Mesh mesh; int NumSides; int NumSlices; Vector3 LocalCofM;`
  - Ctor `(const Vector3_2Ints& params)` — comment: "the zero sides and slices will cause immediate bail out of mesh builder for speed"; pre-seeds `LocalCofM = Vector3::zero()` then `mesh.makePrism(params, LocalCofM)`.
  - `const Mesh* getMesh() const;` `void SetNumSides(int num);` `void SetNumSlices(int num);` `const Vector3& GetLocalCofMFromMesh() const;`

## Gotchas

- `SetNumSides/SetNumSlices` write members that nothing in this header reads — the mesh is already built in the ctor; these look like vestigial or externally-consumed scratch (suspect dead code).
- Zero side/slice params intentionally bail out of building — a degenerate pooled entry is possible.

## UNKNOWN

- Whether any consumer calls SetNumSides/SetNumSlices meaningfully post-construction.

## Cross-links

- Consumer: [PrismPoly.md](PrismPoly.md); mesh builder: [Mesh.md](Mesh.md) (`makePrism`); key type: [GeometryPool.md](GeometryPool.md) (`Vector3_2Ints`).
