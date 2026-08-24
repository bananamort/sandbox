# App/include/v8world/BallPolyContact.h

## Purpose

Ball-vs-poly-part contact (`PolyContact` specialization): finds which face/edge/vertex of an arbitrary `Poly` the ball is touching via hierarchical closest-feature search, then builds the corresponding kernel connectors. Part-vs-part counterpart of [BallCellContact.md](BallCellContact.md).

## Declared API

- `class BallPolyContact : public PolyContact, public Allocator<BallPolyContact>`
  - `BallPolyContact(Primitive* p0, Primitive* p1);`
  - `/*override*/ void findClosestFeatures(ConnectorArray& newConnectors);`
  - `/*override*/ void generateDataForMovingAssemblyStage(void);`
  - Private feature search: `getFarthestPlane(float& planeToCenter, const Vector3& ballInPoly)` → `const POLY::Face*`; `getClosestEdge(const Face*, float&, const Vector3&)`; `getClosestInVoronoiEdge(const Face*, float&, const Vector3&)`; `getClosestVertex(const Edge*, float&, const Vector3&)`.
  - Private factories: `newBallPlaneConnector(const POLY::Face*)`, `newBallEdgeConnector(const POLY::Edge*)`, `newBallVertexConnector(const POLY::Vertex*)`.

## Gotchas

- Same three-tier search shape as BallCellContact (farthest plane → edge incl. Voronoi refinement → vertex); the two classes are near-clones by design.
- Allocator-allocated; construct through the contact allocator path, not raw new.

## UNKNOWN

- Selection rule between `getClosestEdge` and `getClosestInVoronoiEdge` (thresholds live in the .cpp).

## Cross-links

- Base chain: [PolyContact.md](PolyContact.md), [Contact.md](Contact.md); poly geometry: [Poly.md](Poly.md), [Ball.md](Ball.md).
- Kernel-side connector math: [v8kernel/PolyConnectors.md](../v8kernel/PolyConnectors.md), [v8kernel/ContactParams.md](../v8kernel/ContactParams.md).
