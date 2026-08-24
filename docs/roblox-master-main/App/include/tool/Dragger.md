# App/include/tool/Dragger.h

## Purpose

All-static collision-aware placement math shared by the dragger family: given a set of primitives, move/rotate them to a target with intersection resolution (search up/down gross-then-fine, Y-drop, along-line bisection) against the world via ContactManager. The `_EXT` variants work on precomputed `std::vector<Extents>` for cheap repeated tests.

## Declared API

- `class Dragger` — all static; private helpers first:
  - `primitivesFromInstances(pvInstances, G3D::Array<Primitive*>&)`; intersection core: `intersectingWorldOrOthers(primitives, contactManager, bottomPlaneHeight)`, `intersectingGroundPlane(primitives, yHeight)` (+ `_EXT` twins taking extents + ignorePrims + movedSoFar), `isIntersecting(prim1, cframe1, prim2, cframe2)` dispatching to `checkBallPolyIntersection` / `checkBallBallIntersection` / `checkPolyPolyIntersection`.
  - Movement core: `movePrimitives(primitives, delta, snapToWorld=true)`, `movePrimitivesDelta(..., Vector3& movedSoFar)`, `movePrimitivesGoal(...goal, movedSoFar, snapToWorld=true)`, `safePlaceAlongLine(primitives, startMove, endMove, movedSoFar, contactManager, snapToWorld=true)`, search ladder `searchFine` / `searchUpGross` / `searchDownGross` (+ `_EXT` versions), `moveExtents` / `moveExtentsDelta`.
  - Public constants:
    - `static const Vector3& dragSnap()` → `(1.0f, 0.1f, 1.0f)`.
    - `static float maxDragDepth()` → **−400** — header comment: "Physics automatically removes parts that fall lower than −500. We'll allow dragging, moving, resizing down to −400."
    - `static float groundPlaneDepth()` → 0.0f.
  - Public safe moves: `safeMoveNoDrop(primitives, tryMove, contactManager)` ("Moves up as necessary for no overlap"); `safeMoveYDrop(primitives, tryMove, contactManager, customPlaneHeight = groundPlaneDepth())` ("Floating — move down; Intersecting — move up"); `safeMoveAlongLine(primitives, tryMove, contactManager, customPlaneHeight = groundPlaneDepth(), snapToWorld = true)` ("quickly find farthest safe move"); `safeRotateAlongLine(primitives, tryMove, contactManager)`; `safeRotate(primitives, rotate, contactManager)` and `safeRotate2(same)` ("Rotate around a grid point, then find a safe place").
  - Queries: `computeExtents` overloads (vector<Primitive*>, G3D::Array — marked "ToDo::Deprecate Array Version" — and vector<PVInstance*>); `computeExtentsRelative(vector or Array, CoordinateFrame& relativeFrame)`; `computePrimaryPart(vector<Primitive*>)` ×2; `intersectingWorldOrOthers(PartInstance&, contactManager, tolerance, bottomPlaneHeight)` and primitives+tolerance overload.

## Gotchas

- Default plane height is 0 (`groundPlaneDepth`) but callers may pass `maxDragDepth` semantics themselves — mixing up the two constants changes drop behavior drastically.
- `_EXT` functions require caller-managed extents vectors kept in sync with primitive moves (`moveExtentsDelta` exists for that).
- `computeExtents(const G3D::Array...)` is flagged for deprecation in-header.
- All tests are discrete-position probes: callers must re-query after any transform change.
