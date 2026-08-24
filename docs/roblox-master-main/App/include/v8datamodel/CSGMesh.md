# App/include/v8datamodel/CSGMesh.h

## Purpose

Solid-modeling mesh value types: `CSGVertex` (position/normal/color/UV/tangent plus per-vertex UV-generation tag), polymorphic `CSGMesh` (indexed triangle soup with binary serialization, boolean-op entry points, decal remaps), and the `CSGMeshFactory` singleton hook used to swap concrete implementations.

## Declared API

`class CSGVertex`

- Fields: `G3D::Vector3 pos, normal; G3D::Color4uint8 color; G3D::Color4uint8 extra; // red = uv generation type` ; `G3D::Vector2 uv, uvStuds, uvDecal; G3D::Vector3 tangent; G3D::Vector4 edgeDistances;`
- `enum UVGenerationType { NO_UV_GENERATION=0, UV_BOX_X..UV_BOX_Z_NEG };`
- `generateUv(const Vector3& pos) const` / `void generateUv();`

`class CSGMesh`

- Ctors: `CSGMesh(); virtual ~CSGMesh(); virtual CSGMesh* clone() const;`
- Access: `getVertices()/getIndices()` (const refs); decal remaps `getIndexRemap(unsigned idx)/getVertexRemap(unsigned idx)` — RBXASSERT(idx < 6) (six face slots).
- Hashing: `std::string createHash(const std::string salt = "") const;`
- Validity: `bool isBadMesh() const; virtual bool isValid() const { return true; }`
- Mutation: `set(vertices, indices)`, `clearMesh()`, `isNotEmpty()`.
- Virtual transform/edit ops (all default no-ops): `translate`, `applyCoordinateFrame`, `applyTranslation`, `applyColor(Vector3)`, `applyScale(Vector3)`, `triangulate()`, `bool newTriangulate()` (default true), `weldMesh(bool positionOnly=false)`, `buildBRep()`.
- Boolean ops (default false/failure): `unionMesh(a,b)`, `intersectMesh(a,b)`, `subractMesh(a,b)` (sic).
- Serialization: `toBinaryString()`, `toBinaryStringForPhysics()`, `bool fromBinaryString(const std::string&)`; virtual BRep pair `getBRepBinaryString()` (default "") / `setBRepFromBinaryString(...)`.
- Analysis: `virtual size_t clusterVertices(float resolution)` (default 0); `virtual bool makeHalfEdges(std::vector<int>& vertexEdges)` (default true); `extentsCenter()/extentsSize()` default zero vectors.
- Decals: `void computeDecalRemap();`
- Protected state: `int version; int brepVersion; bool badMesh; std::vector<CSGVertex> vertices; std::vector<unsigned int> indices; std::vector<unsigned> decalVertexRemap[6]; std::vector<unsigned> decalIndexRemap[6];`

`class CSGMeshFactory`

- `virtual CSGMesh* createMesh(); static CSGMeshFactory* singleton(); static void set(CSGMeshFactory* factory);`

## Gotchas

- Base-class booleans/triangulation are deliberate no-ops returning failure/success-neutral values — only subclasses implement real CSG.
- Method typo `subractMesh` is verbatim.
- Remap arrays are fixed at 6 (NormalId count); index ≥ 6 asserts.
- `extra.color.red` doubles as the UVGenerationType tag — a packed semantic into an RGBA byte.

## UNKNOWN

- Binary format versions (`version`/`brepVersion` semantics) (.cpp — see [CSGMesh.md](../../v8datamodel/CSGMesh.md)).

## Cross-links

- Implementation: [App/v8datamodel/CSGMesh.md](../../v8datamodel/CSGMesh.md).
- Consumers: [PartOperation.md](PartOperation.md), [CSGDictionaryService.md](CSGDictionaryService.md).
