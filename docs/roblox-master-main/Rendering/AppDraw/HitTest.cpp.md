# AppDraw/HitTest.cpp

## Purpose

Implements `RBX::HitTest` — ray-vs-primitive intersection for the three legacy 2005-era part shapes (block/ball/cylinder), operating on a `GfxBase::Part` in **part-local coordinates**. Used by the old drag/selection picking path.

## API (RBX::HitTest, static)

- `hitTest(part, rayInPartCoords, hitPointInPartCoords, gridToReal)` — dispatches on `part.type`: BLOCK_PART→box, BALL_PART→ball, CYLINDER_PART→cylinder; default asserts and returns false.
- `hitTestBox` — G3D `collisionLocationForMovingPointFixedAABox` against an axis-aligned box of half-extents `gridSize·gridToReal·0.5`.
- `hitTestBall` — sphere of radius `gridSize.x·gridToReal·0.5`; hit iff collision time ≠ G3D::inf().
- `hitTestCylinder` — G3D capsule along local X: radius `gridSize.z·gridToReal·0.5`, half-axis `gridSize.x·gridToReal·0.5`.

## Usage

Included by DrawAdorn.cpp and (UNKNOWN exactly where else) the drag/selection services that need cheap analytic picks before finer mesh tests. All math delegated to `G3D::CollisionDetection`.

## Gotchas

- Cylinder is modeled as a capsule — includes rounded end caps, not flat cylinder caps.
- `gridToReal` converts grid units to studs; callers must supply it (1.0 in most modern paths — UNKNOWN historical value).
- Upstream TODOs admit "big optimization possible" and "offset stuff going on" for the cylinder case.
