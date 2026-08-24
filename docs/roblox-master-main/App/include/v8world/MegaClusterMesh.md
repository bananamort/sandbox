# App/include/v8world/MegaClusterMesh.h

## Purpose

Pooled placeholder mesh for legacy voxel-terrain mega clusters: every MegaClusterPoly shares a block-shaped dummy mesh from the GeometryPool (the real geometry lives in the terrain partition / cell shapes, not here).

## Declared API

- `namespace RBX::POLY { class MegaClusterMesh : public Allocator<MegaClusterMesh> }`
  - `MegaClusterMesh(const Vector3& size)` — `mesh.makeBlock(size)`.
  - `const Mesh* getMesh() const;`
  - `Vector3 GetLocalCofMFromMesh(void)` — returns member `LocalCofM` (by value, non-const method).

## Gotchas

- Despite mirroring [CornerWedgeMesh.md](CornerWedgeMesh.md)'s shape, the ctor never writes `LocalCofM` — it holds whatever `Vector3`'s default ctor yields; don't trust it as a computed center of mass.
- The "mesh" is a dummy block — collision/raycast truth is in [TerrainPartition.md](TerrainPartition.md), not this payload.

## Cross-links

- Consumer: [MegaClusterPoly.md](MegaClusterPoly.md); pooling: [GeometryPool.md](GeometryPool.md); mesh type: [Mesh.md](Mesh.md).
