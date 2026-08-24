# App/include/v8world/PolyPolyContact.h

## Purpose

Part-vs-part analytic contact between two `Poly` primitives: evaluates `PolyPair` hypotheses (face-face, edge-edge), retains the best pair across frames (epsilon hysteresis), and manufactures FaceVertex/FaceEdge/EdgeEdge kernel connectors.

## Declared API

- `class PolyPair` (abstract)
  - Members: `Primitive* primitive[2]; ContactParams contactParams;`
  - Ctor `(Primitive* p0, Primitive* p1, const ContactParams&);` virtual dtor.
  - Pure: `isFaceFace()`, `allocateClone()`, `float test()`, `loadConnectors(ConnectorArray&)`.
  - `bool match(const PolyPair* other)` — same face-face-ness and same `primitive[0]`.
  - Protected: `poly0()/poly1()/poly(i)`.
- `class FaceFacePair : public PolyPair`
  - Members: `mainFace/otherFace/nextBestOtherFace` (`const POLY::Face*`).
  - Public extras: `void setOtherFace(const POLY::Face*);` `const POLY::Face* getNextBestOtherFace(void);`
  - Same VertexStatus machinery as [PolyCellContact.md](PolyCellContact.md): `{ABOVE_INSIDE, ABOVE_OUTSIDE, BELOW_INSIDE, BELOW_OUTSIDE}`, `computeVertices/closestVertex/loadVertices/testVerticesInside/vertexInPoly/vertexInside`, one/two-side intersection checks, `newFaceEdgeConnector`.
- `class EdgeEdgePair : public PolyPair`
  - Members: `bestEdge0/bestEdge1`; private `computeMinMax(planeInMesh, mesh, min, max)`, `newEdgeEdgeConnector()`.
- `class PolyPolyContact : public PolyContact, public Allocator<PolyPolyContact>`
  - `PolyPolyContact(Primitive*, Primitive*); ~PolyPolyContact();`
  - Member `PolyPair* bestPair;` private `findBestPair()`, `resetBestPair(PolyPair* pairOnStack)`.
  - Override: `findClosestFeatures(ConnectorArray&)`; `generateDataForMovingAssemblyStage(void)`.
  - `static float epsilonDistance();` — "distance to switch" pairs.

## Gotchas

- Header keeps the old size-8 FixedArray signatures as comments — buffers grew to `CONTACT_ARRAY_SIZE`; don't reintroduce hardcoded 8s.
- Pair matching ignores `primitive[1]` — asymmetric by design (p0 anchors identity).

## Cross-links

- Base: [PolyContact.md](PolyContact.md), [Contact.md](Contact.md). Terrain twin: [PolyCellContact.md](PolyCellContact.md).
- Connector math: [v8kernel/PolyConnectors.md](../v8kernel/PolyConnectors.md), params: [v8kernel/ContactParams.md](../v8kernel/ContactParams.md).
