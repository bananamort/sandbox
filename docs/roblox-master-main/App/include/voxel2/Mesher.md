# App/include/voxel2/Mesher.h

## Purpose

Smooth-voxel meshing pipeline: `generateGeometry` builds a LOD-aware `BasicMesh` from a [Grid.md](Grid.md) Box slice, `generateGraphicsGeometry(Packed)` converts it to render vertices, plus adjacency/edge-flag helpers for physics and texture basis tables. Namespace `RBX::Voxel2::Mesher` of free functions + POD structs.

## Declared API

- `struct Vertex` — `Vector3 position;` bitfields `unsigned int border:1; reserved:7; material:8; seed:16;`
- `struct GraphicsVertex` — `Vector3 position; Color4uint8 normal;` ("xyz = normal, w = vertex index (0-2)") `Color4uint8 material[3];` ("x = layer index, y = normal segment (0-17), zw = random seed").
- `struct GraphicsVertexPacked` — `Vector3int16 position; short id; Color4uint8 normal/material0/material1;` with documented per-channel packing (layer index / normal segment / three random seeds).
- `struct Options { const MaterialTable* materials; bool generateWater; }`
- `struct BasicMesh { std::vector<Vertex> vertices; std::vector<unsigned int> indices; static bool isWater(v0,v1,v2) — any vertex material == Cell::Material_Water; }`
- `struct GraphicsMesh { std::vector<GraphicsVertex> vertices; std::vector<unsigned int> solidIndices, waterIndices; }` and `GraphicsMeshPacked` (packed variant, same split).
- Functions:
  - `void prepareTables();` (must run before generation).
  - **`BasicMesh generateGeometry(const Box& box, const Vector3int32& offset, int lod, const Options& options);`**
  - `GraphicsMesh generateGraphicsGeometry(const BasicMesh&, const Options&);`
  - `GraphicsMeshPacked generateGraphicsGeometryPacked(const BasicMesh&, const Vector4& packInfo, const Options&);`
  - `struct TriangleAdjacency { enum { None = -1, Multiple = -2 }; int neighbor[3]; };` + `void generateAdjacency(std::vector<TriangleAdjacency>&, const BasicMesh&);` + `void generateEdgeFlags(std::vector<unsigned char>&, const BasicMesh&, float cutoff);`
  - `typedef const Vector3 TextureBasis[18];` `const TextureBasis& getTextureBasisU(); getTextureBasisV();`

## Gotchas

- Vertex "material" is an 8-bit index into the [MaterialTable.md](MaterialTable.md) — table size must be ≤256.
- The 18-entry texture basis arrays are sized to the "normal segment (0-17)" encoding baked into GraphicsVertex channels — changing one breaks the other.
- `prepareTables()` is a required global init; calling generateGeometry first is UB.
- Packed path quantizes positions to Vector3int16 relative to packInfo — out-of-range meshes clamp/corrupt rather than error.

## UNKNOWN
- Exact surface-net/marching-cubes flavor used by generateGeometry (implementation in .cpps).
