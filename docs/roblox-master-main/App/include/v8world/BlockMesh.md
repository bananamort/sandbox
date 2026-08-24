# App/include/v8world/BlockMesh.h

## Purpose

Trivial pooled payload for [Block.md](Block.md): owns one `Mesh` built via `mesh.makeBlock(size)` so every block of identical size shares a single mesh instance through the GeometryPool.

## Declared API

- `namespace RBX::POLY { class BlockMesh : public Allocator<BlockMesh> }`
  - `BlockMesh(const Vector3& size)` — builds the block mesh in ctor.
  - `const Mesh* getMesh() const;`

## Gotchas

- Allocator-typed; instantiate via the pool ([GeometryPool.md](GeometryPool.md)), not raw new.
- Keyed by size (`Vector3Comparer`) — changing a block's size allocates a new pooled entry.

## Cross-links

- Mesh type: [Mesh.md](Mesh.md); consumer: [Block.md](Block.md).
