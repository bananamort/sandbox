# RbxG3D/RbxCamera.cpp

## Purpose

Implementation of `RBX::RbxCamera` (see RbxCamera.h.md): FOV/image-plane bookkeeping, screen↔world projection, pixel→world rays, world-space clip planes and the vertex/face frustum, plus the nested `RbxCamera::Frustum` containment tests.

## API (key behaviors, with real signatures)

- `RbxCamera::RbxCamera()` — defaults: `nearPlane = 0.1f`, `farPlane = inf()`, FOV 55°.
- `void setFieldOfView(float angle)` — asserts `0 < angle < pi`; stores and derives `imagePlaneDepth = 1/(2·tan(angle/2))`.
- `void setImagePlaneDepth(float depth, const Rect2D& viewport)` — inverse: FOV = `2·atan(viewport.height()/(2·depth))`.
- `float getImagePlaneDepth(const Rect2D&) const` — precomputed 1×1 depth scaled by `viewport.height()`.
- `float getViewportHeight(const Rect2D&) const` — ignores the viewport; returns `nearPlane / imagePlaneDepth`. Width derives from aspect.
- `RBX::RbxRay worldRay(float x, float y, const Rect2D& viewport) const` (ROBLOX addition, lines 88–114): direction `(x−cx, −(y−cy), −imagePlaneDepth)` rotated to world by the camera frame, then normalized; origin = camera translation.
- `Vector3 project(const Vector3& point, const Rect2D& viewport) const` — camera-space point; behind-camera (w≤0) returns ±inf sentinel triple preserving x/y quadrant info; otherwise x/y mapped to pixels (y down), z = rhw = imagePlaneDepth/w.
- `Vector3 inverseProject(...)` — exact inverse of the above.
- `Matrix4 projectionMatrix(const Rect2D&) const` — builds l/r/b/t from FOV·aspect around n/f and calls `Matrix4::perspectiveProjection`.
- `float worldToScreenSpaceArea(float area, float z, const Rect2D&) const` — inf for z≥0 else area·(imagePlaneDepth/z)².
- `void frustum(const Rect2D& viewport, Frustum& fr) const` (lines 319–425) — appends near face (w=1) + far face (w = zNear/zFar) vertices as homogeneous Vector4s; faces N,R,L,B,T,[F] with CCW indices; far face omitted when `farPlane == inf()`; transforms vertices and planes to world space, with an isFinite(d) guard using `Plane::fromEquation` to avoid NaN multiplication for infinite planes. `getClipPlanes` extracts just the plane list (legacy inline implementation kept commented below it).
- `bool RbxCamera::Frustum::containsPoint / intersectsSphere` (lines 427–448).
- `void get3DViewportCorners(...) const` — near-plane UR/UL/LL/LR in world space ("Must be kept in sync with frustum()" per its own comment).

## Lua globals and events

None directly; this math underlies the Lua `Camera` instance's WorldToScreenPoint/ScreenPointToRay family via `V8DataModel::Camera`.

## Usage (who loads it)

Compiled into the RbxG3D static lib (vcxproj/CMake/Xcode all list it). Consumers link RbxG3D and include RbxG3D/RbxCamera.h — GfxBase's ViewBase, tools via workspace camera, BillboardGui/MouseCommand picking.

## Gotchas

- **Latent OOB in the nested Frustum tests**: both `containsPoint` and `intersectsSphere` loop `for i < 6` over `faceArray` while the comment says "ignore front, back". With an infinite far plane the array has only **5** entries → reads index 5 out of bounds (release builds: garbage plane test). Same pattern class as `RBX::Frustum::intersectsAABB`'s hardcoded 6.
- `intersectsSphere` shrinks each plane by radius (`p.distance() − radius`) — a conservative "sphere fully inside" test, not overlap.
- `project()`'s y-sentinel sign looks inverted (`out.y > 0 ? −inf : inf`) but mirrors the flipped y axis intentionally.
- Large commented-out blocks remain: legacy `getClipPlanes` body (255–308) and `getZValue` (206–241).
