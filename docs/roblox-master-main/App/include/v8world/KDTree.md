# App/include/v8world/KDTree.h

## Purpose

Static k-d tree over a triangle mesh (vertices + per-vertex materials + indices), used for fast AABB and ray queries against clustered/smooth terrain meshes — feeding Bullet-style triangle callbacks and material lookups.

## Declared API

- `union KDNode`
  - `struct branch { float splits[2]; unsigned axis:2; unsigned childIndex:30; }` — left/right children split at splits[0]/splits[1] along axis.
  - `struct leaf { unsigned triangles[2]; unsigned axis:2; unsigned triangleCount:30; }` — `axis == 3` marks a leaf (`isLeaf()`).
- `struct KDTree`
  - Externally owned mesh data: `const Vector3* vertexPositions; const unsigned char* vertexMaterials; const unsigned int* indices;`
  - `std::vector<KDNode> nodes; size_t depth; Vector3 extentsMin/extentsMax;`
  - `void build(const Vector3* vertexPositions, const unsigned char* vertexMaterials, size_t vertexCount, const unsigned int* indices, size_t triangleCount);`
  - Queries: `void queryAABB(btTriangleCallback*, const Vector3& aabbMin, const Vector3& aabbMax) const;` `void queryRay(RayResult&, const Vector3& raySource, const Vector3& rayTarget) const;`
  - `Vector3 getTriangleNormal(unsigned int triangle) const;` `unsigned char getMaterial(unsigned int triangle, const Vector3& position) const;`
  - `struct RayResult { float fraction; const KDTree* tree; unsigned int triangle; bool hasHit() const; }` — hit iff `tree != NULL`; default fraction 1.

## Gotchas

- The tree does **not** own the vertex/index arrays — caller must keep the source mesh alive for the tree's lifetime.
- Leaf nodes store up to 2 triangle indices inline (`triangles[2]`) with count in a bitfield; larger leaves must be handled by the builder's splitting policy.
- `getMaterial(triangle, position)` interpolates/barylocates against per-vertex materials (exact scheme in .cpp).

## UNKNOWN

- Max triangles per leaf / build heuristic (implementation-only).

## Cross-links

- Terrain users: [TerrainPartition.md](TerrainPartition.md), [MegaClusterMesh.md](MegaClusterMesh.md), [TriangleMesh.md](TriangleMesh.md); voxel grids: [../voxel/INDEX.md](../voxel/INDEX.md).
