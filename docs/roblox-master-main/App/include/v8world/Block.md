# App/include/v8world/Block.h

## Purpose

Axis-aligned box geometry (`GEOMETRY_BLOCK`) as a `Poly`: pools its corner array, mesh, and Bullet box shape by size; provides the face/vertex/edge indexing tables and ball-vs-box GeoPair queries used by contact generation. The default Part shape.

## Declared API

- `class Block : public Poly` (friend `TriangleMesh`)
  - Pools: `BlockMeshPool = GeometryPool<Vector3, POLY::BlockMesh, Vector3Comparer>`, `BlockCornersPool` (`POLY::BlockCorners`), `BulletBoxShapePool` (`BulletBoxShapeWrapper`); members are the three pool Tokens.
  - `const Vector3* vertices;` — shortcut into pooled data (object coords, real-world units).
  - Static tables: `BLOCK_FACE_TO_VERTEX[6][4]`, `BLOCK_FACE_VERTEX_TO_EDGE[6][4]`; `static void init();`
  - Type: `getGeometryType() → GEOMETRY_BLOCK`; `getCollideType() → COLLIDE_BLOCK`.
  - `Vector3 getCenterToCorner(const Matrix3&) const`; `Matrix3 getMoment(float mass)` — **hollow** box inertia (`getMomentHollow`); `float getVolume()`; `hitTest(ray, hitPoint, normal)`.
  - Ball-vs-block GeoPair loading: `void projectToFace(Vector3& ray, Vector3int16& clip, int& onBorder);` `GeoPairType getBallInsideInfo(const Vector3& ray, const Vector3*& offset, NormalId& normalID);` `GeoPairType getBallBlockInfo(int onBorder, Vector3int16 clip, const Vector3*& offset, NormalId& normalID);`
  - Topology accessors: `const float* getVertices() const;` `getExtent()` (= `vertices[0]`), `getFaceVertex(NormalId, int)`, `int getClosestEdge(const Matrix3&, NormalId, const Vector3& crossAxis)`, `faceVertexToEdge(NormalId, int)` (CCW), `faceVertexToClockwiseEdge` (= CCW + 12), `getEdgeVertex(int edgeId)`, `NormalId getEdgeNormal(int edgeId)` — "returns X,-X,X,-X,Y,-Y,Y,-Y,Z,-Z,Z,-Z".
  - `Vector2 getProjectedVertex(const Vector3& vertex, NormalId normalID);`
  - Dragger: `CoordinateFrame getSurfaceCoordInBody(const size_t surfaceId) const;`
  - `bool setUpBulletCollisionData(void);`

## Gotchas

- **Suspected bug in `getEdgeVertex`** (header inline): for clockwise edges (`edgeId >= 12`) it computes `int vertId = ccwEdge + 1 % 4;` — C++ precedence makes this `ccwEdge + (1 % 4)` = `ccwEdge + 1`, never wrapped; when `ccwEdge % 4 == 3` this indexes `BLOCK_FACE_TO_VERTEX[faceId][4]`, past the `[6][4]` table row → out-of-bounds read.
- **Off-by-one in `getEdgeNormal`**: clockwise edges are ids 12–23 but the branch tests `edgeId > 12`, so id 12 is misclassified as CCW.
- Inertia is *hollow*-box, unlike [Ball.md](Ball.md)'s solid sphere — matches Roblox part density semantics for shells.
- Moment/volume/hitTest overrides are private — only reachable through the Geometry interface.

## Cross-links

- Base: [Poly.md](Poly.md), [Geometry.md](Geometry.md); pooled payloads: [BlockMesh.md](BlockMesh.md), [BlockCorners.md](BlockCorners.md), [GeometryPool.md](GeometryPool.md).
- Contact params on faces: [v8kernel/ContactParams.md](../v8kernel/ContactParams.md); ball connector math: [v8kernel/PolyConnectors.md](../v8kernel/PolyConnectors.md).
- Triangle-mesh variant built over blocks: [TriangleMesh.md](TriangleMesh.md) (friend).
