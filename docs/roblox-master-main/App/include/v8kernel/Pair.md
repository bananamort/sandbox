# App/include/v8kernel/Pair.h

## Purpose

Geometric contact-pair descriptors between two bodies: `PairParams` (computed length/normal/position output) and `GeoPair` (defining data — offsets, bodies, per-type union payload) with per-type solvers for point-plane, edge-edge-plane, and edge-edge distance computation.

## Declared API

- `class PairParams`
  - `Vector3 normal; union { float length; float rotation; }; Vector3 position;` ctor zeroes; `bool operator==(const PairParams&)` compares length+position+normal.
- `class GeoPair`
  - Public field `GeoPairType geoPairType;`
  - Header-documented **polarity**: "ball ball: radius0 == point0 body // ball block: ball->point0, block->point1 // point plane: pointBlock->0, planeBlock->1 // edge edge plane: planeBlock->1" and "fixed, not allocated here".
  - Defining data: `Vector3 offset0, offset1; Body* body0; Body* body1; float edgeLength0, edgeLength1;` plus anonymous struct of three unions: `{NormalId normalID0 | float radius0}`, `{NormalId normalID1 | float radiusSum}`, `{NormalId planeID ("edge/edge/plane coords — the normal from the plane") | int point0ID}`.
  - Private computers: `computePointPlane(PairParams&)`, `computeEdgeEdgePlane`, `computeEdgeEdgePlane2`, `computeEdgeEdge`.
  - Public: `GeoPair()`; inline dispatcher `void computeLengthNormalPosition(PairParams&)` — switch over type, `RBXASSERT(0)` default (ball pairs unsupported here).
  - Type setters: `setPointPlane(offsetPoint*, offsetPlane*, int pointID, NormalId planeNormalID)` — "point0ID purely here for the match"; `setEdgeEdgePlane(edge0*, edge1*, normal0, normal1, planeID, edgeLen0, edgeLen1)`; `setEdgeEdge(edge0*, edge1*, normal0, normal1)`. All take Vector3 pointers.
  - `bool match(Body* b0, Body* b1, GeoPairType, int param0, int param1)` — POINT_PLANE matches (body pair + point0ID + normalID1); EDGE_EDGE_PLANE matches normals in order; EDGE_EDGE also accepts swapped body order with correspondingly swapped params.

## Gotchas

- The triple union means setting one interpretation clobbers the others — always go through the typed setters.
- `computeEdgeEdgePlane2` is used by the dispatcher even though `computeEdgeEdgePlane` exists — the non-2 variant is dead or used elsewhere.
- Setter pointer parameters are dereferenced unconditionally — no null tolerance despite pointer syntax.
- EDGE_EDGE match is symmetric but the other two are not — order of bodies matters when matching point-plane pairs.

## UNKNOWN

- Where BALL_* GeoPairs get their length/normal computed ([ContactConnector.md](ContactConnector.md) path).
