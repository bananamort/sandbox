# App/include/v8world/Mesh.h

## Purpose

The `POLY` half-edge-style polyhedral mesh used by all analytic shapes: vertices carry offsets, edges link exactly two faces (`forward`/`backward`), faces are planar polygons (3–4+ edges) with outward planes and extrusion-side tests. Also the builder that constructs wedge/prism/pyramid/ramp/corner-wedge/block/terrain-cell meshes.

## Declared API

- In-header topology diagram: V−E−V grid comment.
- `class POLY::Vertex` — `size_t id; Vector3 offset; std::vector<Edge*> edges;`
  - `getOffset()`, `getId()`, `addEdge(Edge*)` (asserts uniqueness), `findEdge(const Vertex*)`, `numEdges()`, **`size_t numFaces()` = `edges.size()`** (same count), `getEdge(i)`, `static recoverEdge(v0,v1)`, `getFace(i)`.
- `class POLY::Edge` — `id; const Vertex* vertex[2]; const Face* forward/backward;`
  - `otherFace(test)` (asserts membership), `contains(Vertex*)`, `addFace(face)` (max two), face-aware winding: `getVertex(face, id)` returns swapped vertex for `backward`, `computeNormal(face)`, `computeLine()`, `getVertexFace(v)`, `pointInVaronoi(const Vector3&)` *(sic: Varonoi)*.
- `class POLY::Face` — `id; std::vector<Edge*> edges; Plane outwardPlane;`
  - Ctors for triangle `(e0,e1,e2)`, quad `(…e3)`, and arbitrary `std::vector<Edge*>`; `initPlane();`
  - `getVertex(int)` (via edge winding), `normal()`, `numEdges()/numVertices()` (equal), `plane()` (asserts ≥3 edges), `getSidePlane(edgeId)`, centroid/OBB: `getCentroid()`, `getOrientedBoundingBox(xDir, yDir, boxMin, boxMax, boxCenter)`.
  - Point/extrusion tests: `pointInExtrusion(point)`, `pointInFaceBorders(pointOnPlane)` ("point must be on face plane"), private `lineCrossesExtrusionSide[Below]`, `pointInInternalExtrusion`, intersection helpers `getInternalExtrusionIntersection(pBelowInside, pBelowOutside) → int`, `findInternalExtrusionIntersection`, `findInternalExtrusionIntersections(p0,p1,int& side0,int& side1)`.
- `class POLY::Mesh` — owns vectors of Vertex/Edge/Face.
  - Access: `numFaces/getFace`, `numVertices/getVertex`, `numEdges/getEdge`, `containsFace`, `findFace(i0,i1,i2)`, `farthestVertex(direction)`, `pointInMesh(point)`, `findFaceIntersection(inside, outside)`, `findFaceIntersections(p0,p1,f0,f1)`, `bool hitTest(ray, hitPoint, surfaceNormal)`.
  - Shape factories: `makeBlock(size)`, `makeWedge(size)`, `makePrism(const Vector3_2Ints&, Vector3& cofm)`, `makePyramid(...)`, `makeParallelRamp(size, cofm)`, `makeRightAngleRamp(...)`, `makeCornerWedge(size, cofm)`; terrain cells: `makeCell(size, offset)`, `makeVerticalWedgeCell(size, offset, orient)`, `makeHorizontalWedgeCell`, `makeCornerWedgeCell`, `makeInverseCornerWedgeCell`.

## Gotchas

- Faces assume planar convex polygons; quad ctor takes edges in winding order — wrong order silently flips normals.
- Prism/pyramid sizing uses `Vector3_2Ints` (size + 2 ints, e.g. taper params) rather than plain size; CoFm comes back through out-param.
- Cell meshes are built at a cell-local offset/orientation for terrain use ([MegaClusterPoly.md](MegaClusterPoly.md)).

## UNKNOWN

- Exact meaning/ordering of the orientation ints for wedge cells (implementation-defined in .cpp).

## Cross-links

- Consumers: [Poly.md](Poly.md) subclasses' pooled payloads ([BlockMesh.md](BlockMesh.md), [CornerWedgeMesh.md](CornerWedgeMesh.md)), contact feature search ([BallPolyContact.md](BallPolyContact.md)).
- Feature handles over this mesh: [Feature.md](Feature.md) (GEO::Vertex/Edge/Face vs POLY::* here — distinct types).
