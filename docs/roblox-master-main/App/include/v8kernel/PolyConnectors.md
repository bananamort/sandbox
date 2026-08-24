# App/include/v8kernel/PolyConnectors.h

## Purpose

Block/block and ball/surface contact connectors built on [ContactConnector.md](ContactConnector.md): `PolyConnector` base adds match parameters, then six concrete geometric pairs — FaceVertex (vertex-plane), FaceEdge (edge-edge-plane), EdgeEdge, BallVertex, BallEdge, BallPlane — each carrying its defining geometry and overriding `updateContactPoint()`.

## Declared API

- `class PolyConnector : public ContactConnector`
  - Protected ctor `(Body* b0, Body* b1, const ContactParams&, int param0, int param1)` ("for matching"); pure virtual `GeoPairType getConnectorType() const = 0;`
  - Public static `bool match(PolyConnector*, PolyConnector*)` — params equal AND connector type equal.
- `class FaceVertexConnector : public PolyConnector, public Allocator<...>` — type `VERTEX_PLANE_CONNECTOR`; state `Plane facePlane; Vector3 vertexOffset;` ctor `(b0, b1, params, facePlane, vertexOffset, planeId, vertexId)`; overrides updateContactPoint.
- `class FaceEdgeConnector : public PolyConnector, public Allocator<...>` — type `EDGE_EDGE_PLANE_CONNECTOR`; state `facePlane, sideFacePlane, Line faceLine, Line edgeLine;` ctor `(…, faceId, edgeId)`; override.
- `class EdgeEdgeConnector : public PolyConnector, public Allocator<...>` — type `EDGE_EDGE_CONNECTOR`; state `Line edgeLine0/1;` ctor `(…, edgeId0, edgeId1)`; override.
- `class BallVertexConnector : public PolyConnector, public Allocator<...>` — type `BALL_VERTEX_CONNECTOR`; state `float radius; Vector3 offset;` ctor passes `(0, vertexId)` as params; override.
- `class BallEdgeConnector : public PolyConnector, public Allocator<...>` — type `BALL_EDGE_CONNECTOR`; state `radius, offset, normal;` ctor `(…, 0, edgeId)`; override.
- `class BallPlaneConnector : public PolyConnector, public Allocator<...>` — type `BALL_PLANE_CONNECTOR`; state `radius, offset, normal;` ctor `(…, 0, faceId)`; override.

## Gotchas

- All defining geometry (planes/lines/offsets) is captured **at construction** in body-local space; if the underlying part geometry changes after connector creation, connectors must be rebuilt — there is no refresh API here beyond updateContactPoint.
- Ball connectors pass literal `0` for param0 — matching for ball pairs relies on type + second param only.
- Every concrete class multiply-inherits an `Allocator<>` specialization: pooled per-type construction; don't `delete` through foreign pools casually (dtors are non-virtual in Allocator pattern).
