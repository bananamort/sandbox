# App/include/v8world/BlockCorners.h

## Purpose

Pooled payload holding the 8 corner `Vector3`s of a block so all same-size blocks share one array (cache/RAM win for collision). Used by [Block.md](Block.md) alongside [BlockMesh.md](BlockMesh.md).

## Declared API

- `namespace RBX::POLY { class BlockCorners : public Allocator<BlockCorners> }`
  - `Vector3 vertices[8];`
  - `BlockCorners(const Vector3& _corner)` — takes the positive half-extent "corner"; negates abs of each component, then three nested sign-flip loops emit every ± combination into `vertices[i*4 + j*2 + k]`.
  - `const Vector3* getVertices() const;`

## Gotchas

- Input is expected as the corner offset (half-extents); negative inputs are normalized via `-std::abs`, so sign of input never changes output.
- The inline loop comments ("positive for i = 0, negative for i = −1") are stale — actual behavior is a plain 8-way ± enumeration starting from the all-negative corner.

## Cross-links

- Consumer/keying: [GeometryPool.md](GeometryPool.md), [Block.md](Block.md).
