# AppDraw/HitTest.cpp

## Purpose

Implements `RBX::HitTest` — ray-vs-primitive intersection for the three legacy 2005-era part shapes (block/ball/cylinder), operating on a `GfxBase::Part` in **part-local coordinates**. Used by the old drag/selection picking path.

## API (RBX::HitTest, static)

- `hitTest(part, rayInPartCoords, hitPointInPartCoords, gridToReal)` — dispatches on `part.type`: BLOCK_PART→box, BALL_PART→ball, CYLINDER_PART→cylinder; default asserts and returns false.
- `hitTestBox` — G3D `collisionLocationForMovingPointFixedAABox` against an axis-aligned box of half-extents `gridSize·gridToReal·0.5`.
- `hitTestBall` — sphere of radius `gridSize.x·gridToReal·0.5`; hit iff collision time ≠ G3D::inf().
- `hitTestCylinder` — G3D capsule along local X: radius `gridSize.z·gridToReal·0.5`, half-axis `gridSize.x·gridToReal·0.5`.

## Usage

Included by `DrawAdorn.cpp`, `App/v8datamodel/PartInstance.cpp`, `App/tool/AdvRotateTool.cpp`, and `App/util/HitTest.cpp`. The sole actual call site in the tree is `PartInstance.cpp` line 1286 (`bool answer = HitTest::hitTest(getPart(), rayInPartCoords, hitPointInPartCoords, 1.0);`), passing `gridToReal = 1.0`. All math delegated to `G3D::CollisionDetection`. Do not confuse with the separate handle-picker `HandleHitTest` (class declared in `App/include/util/HitTest.h`, implemented in `App/util/HitTest.cpp`), which the Studio tools use.

## Gotchas

- Cylinder is modeled as a capsule — includes rounded end caps, not flat cylinder caps.
- `gridToReal` converts grid units to studs; the only real caller passes 1.0.
- Upstream TODOs admit "big optimization possible" and "offset stuff going on" for the cylinder case.
- Default case of the dispatch asserts then returns false — wedge/corner shapes are simply unhittable through this path.
