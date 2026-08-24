# App/include/v8world/PolyCellContact.h

## Purpose

Poly-part vs terrain-cell contact: a `CellMeshContact` that evaluates candidate `PolyCellPair` hypotheses (face-face and edge-edge) between the part's mesh and the cell's mesh, keeps the best pair alive across frames (with an epsilon hysteresis), and loads face/edge connectors from it.

## Declared API

- `class PolyCellPair` (abstract)
  - Members: `Primitive* primitive[2]; ContactParams contactParams; bool swapPrims; PolyCellContact* myPCContact;`
  - Ctor: `(Primitive* p0, Primitive* p1, const ContactParams&, PolyCellContact*, bool swap);` virtual dtor.
  - Pure: `bool isFaceFace() const = 0;` `PolyCellPair* allocateClone() = 0;` `float test() = 0;` `void loadConnectors(ConnectorArray&) = 0;`
  - Virtual: `bool pairIsValid() { return true; }`
  - Matching across frames: `bool match(const PolyCellPair* other)` — same isFaceFace **and same primitive[0]**.
  - Protected poly accessors: `poly0()/poly1()/poly(i)`.
- `class CellFaceFacePair : public PolyCellPair`
  - Members: `const POLY::Face* mainFace/otherFace;`
  - `typedef enum {ABOVE_INSIDE, ABOVE_OUTSIDE, BELOW_INSIDE, BELOW_OUTSIDE} VertexStatus;`
  - Vertex classification & connector loading: `computeVertices(FixedArray<Vector3, CONTACT_ARRAY_SIZE>&, const CoordinateFrame& otherInMe)`, `float closestVertex(face, verticesInObject, const POLY::Vertex*& out)`, `findOtherFace(closeVertex)`, `loadVertices(...)`, `testVerticesInside(...)`, `vertexInPoly(planeFace, planeMesh, vertex, otherInMe)`, `vertexInside(...)`, one/two-side intersection checks (`checkOneSideIntersection`, `validateOneSideIntersection`, `checkTwoSideIntersections`), factory `newFaceEdgeConnector(mainFaceEdgeId, v0, v1)`.
  - Overrides: `isFaceFace → true`, `allocateClone`, `test`, `loadConnectors`; public `pairIsValid(void);` ctor mirrors base.
- `class CellEdgeEdgePair : public PolyCellPair`
  - Members: `const POLY::Edge* bestEdge0/bestEdge1;`
  - Private: `computeMinMax(const Plane& planeInMesh, const POLY::Mesh*, float& min, float& max)`, `newEdgeEdgeConnector()`.
  - Overrides: `isFaceFace → false`, `allocateClone/test/loadConnectors`.
- `class PolyCellContact : public CellMeshContact, public Allocator<PolyCellContact>`
  - `PolyCellContact(Primitive* p0, Primitive* p1, const Vector3int16& cell); ~PolyCellContact();`
  - `static float epsilonDistance();` — "distance to switch" pairs.
  - Overrides: `findClosestFeatures(ConnectorArray&)` (drives findBestPair/resetBestPair), `generateDataForMovingAssemblyStage(void)`.

## Gotchas

- Pair persistence is keyed by (face-face-ness, primitive[0]) — a swap of primitive order breaks match continuity deliberately.
- Buffers were widened from 8 → `CONTACT_ARRAY_SIZE` (40): commented-out old signatures remain in the header as archaeology.
- `epsilonDistance()` controls pair switching; two nearby values can oscillate if callers treat it as exact.

## Cross-links

- Base: [CellContact.md](CellContact.md), [Contact.md](Contact.md); sibling analytic contacts: [BallCellContact.md](BallCellContact.md), [PolyContact.md](PolyContact.md).
- Kernel connectors produced: Face/FaceEdge/EdgeEdge — [v8kernel/PolyConnectors.md](../v8kernel/PolyConnectors.md).
