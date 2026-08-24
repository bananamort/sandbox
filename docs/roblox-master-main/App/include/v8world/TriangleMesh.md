# App/include/v8world/TriangleMesh.h

## Purpose

Arbitrary triangle-mesh geometry (`GEOMETRY_TRI_MESH`, `COLLIDE_BULLET`) for MeshParts: collision is a pooled Bullet convex decomposition (`BulletDecompWrapper`); raycasts go through a pooled `KDTree` ([KDTree.md](KDTree.md)); dragger surfaces are faked with an owned bounding-box [Block.md](Block.md). Also hosts the serialized physics-data (de)serialization utilities and the CSG-facing convex types. `PHYSICS_SERIAL_VERSION = 3`.

## Declared API

- `class KDTreeMeshWrapper : public Allocator<...>`
  - `KDTreeMeshWrapper(const std::string& str)` — deserializes mesh, owning `std::vector<Vector3> vertices; std::vector<unsigned int> indices; KDTree tree;`
  - `const KDTree& getTree() const;`
- Pools (keyed by the serialized data string): `GeometryPool<std::string, BulletDecompWrapper, StringComparer> BulletDecompPool;` `GeometryPool<std::string, KDTreeMeshWrapper, StringComparer> KDTreeMeshPool;`
- `class TriangleMesh : public Geometry`
  - Members: `int version;` tokens `compound`/`kdTreeMesh`; `Vector3 kdTreeScale;` **`Block* boundingBoxMesh;`** ("Needed for basic Dragger functions", owned via raw new in ctor); `float centerToCornerDistance;`
  - Ctor seeds `version = PHYSICS_SERIAL_VERSION`, allocates `boundingBoxMesh = new Block()` and resets `bulletCollisionObject` (protected member of [Geometry.md](Geometry.md)).
  - Data setters: `void setStaticMeshData(const std::string& key, const std::string& data, const btVector3& scale = (1,1,1));` `bool setCompoundMeshData(key, data, scale = (1,1,1));` `void updateObjectScale(decompKey, decompStr, const Vector3& scale, const Vector3& meshScale = (-1,-1,-1));`
  - Version/data validation: `static bool validateDataVersions(const std::string& data, int& version);` `static bool validateIsBlockData(const std::string& data);` `int getVersion();`
  - Serialization toolkit (static): `generateDecompositionData(numTriangles, triIdx, numVertices, vertexBase)`, `generateConvexHullData(...)`, `retrieveDecomposition(str) → BulletDecompWrapper::ShapeType*`, `generateStaticMeshData(indices, vertices)`, `readConvexHullData(vertices, numVertices, indices, numIndices, btTransform&, stringstream&)`, `readPrefixData(btVector3& scale, int& currentVersion, stream)`, `getDecompConvexes(data, int& currentVersion, btVector3& scale, bool dataHasScale=false) → std::vector<CSGConvex>`, `serializeConvexHullData(transform, numVertices, verticesBase, numIndices, indicesBase, outstream)`, instance `std::string generateDecompositionGeometry(vertices, indices)`.
  - Placeholders: `static const std::string getPlaceholderData(); static const std::string getBlockData();`
  - Overrides: `hitTest(ray, hitPoint, normal)`; `getGeometryType() → GEOMETRY_TRI_MESH`; `getCollideType() → COLLIDE_BULLET`; `getRadius()`; `getCenterToCorner(rot)` — prefers `boundingBoxMesh->getCenterToCorner`, falls back to uniform distance; `getMoment(mass)` — **hollow** box inertia of the bbox (`getMomentHollow`); full dragger surface set delegating to `boundingBoxMesh` (`getNumSurfaces()` = bbox mesh face count); `setUpBulletCollisionData()`.
- `class CSGConvex { std::vector<btVector3> vertices; std::vector<unsigned int> indices; btTransform transform; };`
- `class BulletConvexDecomposition : public ConvexDecomposition::ConvexDecompInterface` — collects decomposition results into a binary stringstream (`ConvexDecompResult`, `addStreamChildren`).

## Gotchas

- Inertia uses the *hollow box* approximation of the bounding box — mesh parts don't get true shape inertia.
- Dragger surfaces are the **bounding box's**, not the mesh's — surface ids mean box faces here.
- Data strings are pool keys AND wire format: identical meshes across parts share one decomposition; version mismatches are handled by `validateDataVersions`.
- `Block.h` declares `friend class TriangleMesh` — TriangleMesh reaches into Block internals.

## UNKNOWN

- Exact binary layout of the decomposition/hull streams (writer/reader live across these statics + .cpp).

## Cross-links

- Payloads: [BulletGeometryPoolObjects.md](BulletGeometryPoolObjects.md) (`BulletDecompWrapper`, USE_GIMPACT toggle), [KDTree.md](KDTree.md), pooling: [GeometryPool.md](GeometryPool.md).
- Base: [Geometry.md](Geometry.md); bbox donor: [Block.md](Block.md).
