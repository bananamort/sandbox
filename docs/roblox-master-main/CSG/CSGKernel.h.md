# CSGKernel.h

## Purpose

Header for the sgCore-backed CSG kernel (see CSGKernel.cpp.md). Declares the concrete `CSGMesh` implementation, its factory, the half-edge/crease support structs, and the vertex-clustering helper used by `newTriangulate`.

## API

Namespace `RBX`:

- `class triangulationVertex` — bookkeeping node for crease duplication: `duplicateCount`, circular `neighborVert[2]` (prev/next duplicate ring), `neighborCreaseFlag[2]`.
- `class CSGHalfEdge` — indexed half-edge: `startVert`, `prevEdge`/`nextEdge`/`oppEdge` (indices; `oppEdge` is ctor-initialized to `-1` = none, `prevEdge`/`nextEdge` are always assigned by `makeHalfEdges`), owning `face`, and `creaseFlag` bits `normalCrease=0x1`, `colorCrease=0x2`, `uvCrease=0x4` plus `creaseSet` latch.
- `class CSGMeshSgCore : public CSGMesh` — overrides clone/assignment/validity, transform appliers (`translate`, `applyCoordinateFrame`, `applyTranslation/Scale/Color`), triangulators (`triangulate`, `newTriangulate`), `weldMesh(bool positionOnly=false)`, BRep serialization (`getBRepBinaryString`, `setBRepFromBinaryString`, plus non-virtual `brepFromBinaryString`), `buildBRep`, booleans (`unionMesh`, `intersectMesh`, `subractMesh` [sic]), clustering/half-edge plumbing (`clusterVertices(float resolution)`, `makeHalfEdges(std::vector<int>& vertexEdges)`), extents accessors. Private nested `EditData` RAII-wraps the owned `sgCObject*` (deep-copies via binary round-trip, destroys via `sgDeleteObject`); private members `halfEdges`, `extents`, `makeExtents()`, and boolean workers `sgCoreUnion`/`sgCoreSubtract`.
- `class CSGMeshFactorySgCore : public CSGMeshFactory` — single override `createMesh()`.
- `class CSGClustering` — spatial clustering of index entries into position classes at a given resolution: ctor takes `(indices, vertices, minpos, invres)`; `cluster()` buckets each indexed vertex into up-to-8 corner classes of a 2×2×2 cell pair keyed by packed uint64 (`makeKey`: 4-bit corner id <<60 | 20-bit z/y/x); `extractVertices()` collapses clusters to one representative vertex and returns max faces-per-cluster. Internals: `VertexCluster {posclasses set, indices set}`, `IPosClassMap = boost::unordered_map<uint64,int>`, `mergeClasses` union-find-ish merge across the 8 keys.

Forward-declares `class sgCObject` (defined by the vendored sgCore SDK under `CSG/sgCore/`).

## Usage

Included by CSGKernel.cpp only — a tree-wide grep finds **no other include site and no consumer** of `CSGMeshFactorySgCore`: in this source drop nothing calls `CSGMeshFactory::set()` to install the sgCore factory, so `CSGMeshFactory::singleton()->createMesh()` (used by SolidModelContentProvider/CSGDictionaryService) returns the plain base `CSGMesh`. Depends on `V8DataModel/CSGMesh.h` (abstract base + `CSGVertex`), `util/Extents.h`, `util/Vector3int32.h`, `boost/unordered_map.hpp`.

## Gotchas

- Method name typo `subractMesh` is part of the virtual interface contract — callers must match the misspelling.
- `neighborVert[2]` comment says "previous - next": index 0 walks the duplicate ring backward, index 1 forward.
- `makeKey` packs 20 bits per axis ⇒ coordinates quantized relative to mesh min-extent; `clusterVertices` clamps invres to `1048574.0f * maxExtent` (`0xffffe`, CSGKernel.cpp:1430).
