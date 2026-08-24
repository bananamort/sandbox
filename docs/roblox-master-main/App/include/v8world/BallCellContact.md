# App/include/v8world/BallCellContact.h

## Purpose

Ball-vs-terrain-cell contact: a `CellMeshContact` specialization that, given a ball and one `Vector3int16` cell's poly mesh, finds the closest poly features (face → edge → vertex, with Voronoi-region test) and manufactures the matching kernel-side connectors (BallPlane/BallEdge/BallVertex).

## Declared API

- `class BallCellContact : public CellMeshContact, public Allocator<BallCellContact>`
  - `BallCellContact(Primitive* p0, Primitive* p1, const Vector3int16& cell); ~BallCellContact();`
  - `/*override*/ void findClosestFeatures(ConnectorArray& newConnectors);` — the feature-search entry point.
  - `/*override*/ void generateDataForMovingAssemblyStage(void);`
  - Private feature search: `getFarthestPlane(float& planeToCenter, const Vector3& ballInCell)` → `const POLY::Face*`; `getClosestEdge(const Face*, float&, const Vector3&)`; `getClosestInVoronoiEdge(const Face*, float&, const Vector3&)`; `getClosestVertex(const Edge*, float&, const Vector3&)`.
  - Private connector factories: `newBallPlaneConnector(const POLY::Face*)`, `newBallEdgeConnector(const POLY::Edge*)`, `newBallVertexConnector(const POLY::Vertex*)`.

## Gotchas

- Allocator-instantiated — allocate through the `Allocator<BallCellContact>` machinery, not raw new (consistent with other contact classes).
- The search is hierarchical: farthest plane first, then closest edge of that face (with an in-Voronoi refinement), then closest vertex — callers must not reorder.

## UNKNOWN

- Whether `getClosestEdge` vs `getClosestInVoronoiEdge` selection depends on distance thresholds — logic is implementation-only.

## Cross-links

- Parent contact: [CellContact.md](CellContact.md), base: [Contact.md](Contact.md).
- Kernel connectors created here: [v8kernel/PolyConnectors.md](../v8kernel/PolyConnectors.md) (BallPlane/BallEdge/BallVertexConnector), [v8kernel/ContactConnector.md](../v8kernel/ContactConnector.md).
- Terrain counterpart: [v8world/TerrainPartition.md](TerrainPartition.md), voxel terrain docs under [../voxel/INDEX.md](../voxel/INDEX.md).
