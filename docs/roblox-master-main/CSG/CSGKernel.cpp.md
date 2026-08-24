# CSGKernel.cpp

## Purpose

The sgCore-backed implementation of Roblox's Constructive Solid Geometry kernel: it turns solid-geometry operations on `Part`s (Union/Subtract/Negate) into renderable triangle meshes. `CSGMeshSgCore` derives from the abstract `CSGMesh` interface (declared in `V8DataModel/CSGMesh.h`) and wraps an `sgCObject*` shape tree owned by the vendored **sgCore** geometry SDK (`sgCore/` subdirectory — third-party kernel, not documented here; see INDEX). The file also contains a pure-C++ vertex-clustering pass (`CSGClustering`) and half-edge mesh machinery used by the newer triangulation path. NOTE: in this source drop the boolean API is dead-in-tree — no caller of `unionMesh`/`subractMesh`/`intersectMesh` and no installer of the sgCore factory exists (see Factory below); Studio-side CSG tooling is not part of this drop.

## API

All in namespace `RBX`.

**Factory**
- `CSGMeshFactorySgCore::createMesh()` — returns `new CSGMeshSgCore`; designed to be installed via `CSGMeshFactory::set()`, but a tree-wide grep finds **no caller of `set()`**, so `CSGMeshFactory::singleton()->createMesh()` (the creation point used by SolidModelContentProvider.cpp:36 and CSGDictionaryService.cpp:122) falls back to the default factory, which returns plain base `CSGMesh` (App/v8datamodel/CSGMesh.cpp:40-46). The sgCore-backed implementation is compiled and linked but never instantiated in-tree.

**CSGMeshSgCore (public overrides of CSGMesh)**
- `clone()`, `operator=`, `isValid()` — copy semantics carry both the raw vertex/index buffers and the opaque BRep; validity means "a shape object exists".
- `translate(v)`, `applyCoordinateFrame(cf)` — bake transforms into vertices (`translate`) or into the sgCore shape tree via `sgCMatrix` + per-object `Translate` (`applyCoordinateFrame`).
- `applyScale(size)`, `applyColor(color)` — propagate scale/color into the sgCore objects.
- `triangulate()` — legacy path: `Triangulate(SG_VERTEX_TRIANGULATION)`, flat normals + box-projected UVs per face (`calcUV` picks one of six `UV_BOX_*` classes stored in `CSGVertex.extra.r`), then O(n²) smooth-normal/tangent averaging over near-coincident positions (`calcSmoothNormal`, 40° threshold), finally `weldMesh()`.
- `newTriangulate()` — current path: triangulate → drop degenerate tris → `clusterVertices(0.001f)` → build half-edge structure → mark creases per edge (normal crease if face normals differ by >40°, uvCrease if box-UV class differs, colorCrease if face colors differ) → duplicate vertices along crease rings (`triangulationVertex` circular neighbor lists) → area-weighted accumulation of normals/tangents that averages across non-creased boundaries only. Returns false on non-manifold edges or mismatched crease flags; calls `computeDecalRemap()` at the end (base-class helper for decal face remapping).
- `weldMesh(positionOnly=false)` — exact-position (<0.001f) welding; without `positionOnly` also requires equal normal/color/uv.
- `unionMesh(a,b)` / `subractMesh(a,b)` — dynamic_cast to `CSGMeshSgCore` then delegate to `sgCoreUnion`/`sgCoreSubtract`; `intersectMesh` is **not implemented** (returns false).
- `buildBRep()` — rebuild an sgCore solid from raw triangles via `sgFileManager::ObjectFromTriangles` with 45° feature angle.
- `getBRepBinaryString()` / `setBRepBinaryString(str)` / `brepFromBinaryString(str)` — serialize the sgCore shape as `[int version][ulong size][bytes]`. These have **no external callers** (only internal use by `EditData::clone`); UnionOperation/NegateOperation MeshData assets actually round-trip through the *base* `CSGMesh::toBinaryString`/`fromBinaryString` vertex/index serialization (see SolidModelContentProvider.cpp:35-37), not this BRep form. Note the reader ignores `brepVersion`.
- `clusterVertices(resolution)` / `makeHalfEdges(vertexEdges)` / `extentsCenter()` / `extentsSize()`.

**File-local helpers** (namespace-level): `initKernel()/initKernelOnce()` (one-time `sgInitKernel` + disable auto-triangulation via boost::call_once), `gather3DObjects`/`applyMatrixTo*`/`applyColorTo*`/`applyScaleTo*`/`applyTranslationTo*` recursive group walkers, `triangulateObject/triangulateGroup/triangulate3D`, normal/tangent calculators, and DXF crash-dump helpers `logError`/`removePreviousErrorFiles`/`removeAllDXFFiles`.

**Flags**: `FASTFLAGVARIABLE(CSGExportFailure, false)` — when set, failed boolean ops export the two operands as `_csgU*.dxf`/`_csgN*.dxf` files next to logs (Windows only, skipped on Durango).

## Usage

Linked into the engine as static library project `CSG.vcxproj` (see CSG.vcxproj.md). The V8DataModel layer instantiates meshes via `CSGMeshFactory::singleton()->createMesh()` (SolidModelContentProvider.cpp, CSGDictionaryService.cpp) — which resolves to the plain base `CSGMesh` because nothing in-tree installs `CSGMeshFactorySgCore` (see Factory). Includes pull from `.\sgCore` (the vendored SDK headers live there), plus Base, g3d, RbxG3D, App includes.

## Gotchas

- `intersectMesh` silently returns false — and no in-tree code calls any of the three boolean ops, so any upstream intersection emulation is outside this drop (UNVERIFIABLE here).
- The copy constructor copies `decalIndexRemap`/`decalVertexRemap` (CSGKernel.cpp:167-171) but `operator=` does **not** (lines 178-186) — assigning a mesh silently drops decal remapping state that cloning preserves.
- sgCore error codes are checked numerically: union aborts on errcode==2; subtract treats errcode==4 as "nothing to subtract" but fails on errcode>1.
- `EditData::clone()` does NOT use `sgCObject::Clone` (comment says it is not a true clone); it round-trips through the binary-string form instead.
- `getBRepBinaryString` leaks the buffer returned by `ObjectToBitArray` (never freed) — UNKNOWN whether sgCore owns/freees it internally.
- `makeHalfEdges` rejects any duplicated directed edge (returns false ⇒ `newTriangulate` fails), so non-manifold input falls back to no-mesh rather than garbage.
- `calcSmoothNormal/calcSmoothTangent` are O(V²) over all vertices regardless of distance cutoff beyond the epsilon test — legacy path only.
- DXF dump paths assume Windows `MainLogManager`; on other platforms `logError` compiles to nothing.
