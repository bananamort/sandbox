# RbxG3D/include/RbxG3D/RbxCamera.h

## Purpose

Declares `RBX::RbxCamera` — Roblox's fork of the **pre-8.0** G3D `GCamera` (header comment: "This is not the G3D 8.0 GCamera… modified by Roblox"; Morgan McGuire provenance 2001–2006). It owns a vertical FOV, near/far plane distances, an image-plane depth, and a `G3D::CoordinateFrame`, and provides projection/unprojection, pixel→world rays, clip planes, and a vertex/face frustum representation. The engine's `V8DataModel::Camera` wraps this for math while keeping its own property model.

## API

State (all private): `float fieldOfView` (vertical, radians), `float imagePlaneDepth` (depth of image plane for 1×1 film), `float nearPlane`, `float farPlane` (**positive** numbers), `CoordinateFrame cframe`.

Nested `class Frustum` — vertex+face form: `Array<G3D::Vector4> vertexPos` (homogeneous; w==0 ⇒ at infinity) and `Array<Face> faceArray` (`Face { int vertexIndex[4]; Plane plane; }`), faces in order N,R,L,B,T,[F] (5 when far is at infinity). Methods `containsPoint(Vector3)`, `intersectsSphere(center, radius)`.

Free-standing methods:
- Frame: `coordinateFrame()`, `getCoordinateFrame(c)`, `setCoordinateFrame(c)`, `setPosition(t)`, `lookAt(position, up = unitY)`.
- Optics: `setFieldOfView(angle)` (default `toRadians(55)`; recomputes imagePlaneDepth = 1/(2·tan(fov/2))), `setImagePlaneDepth(depth, viewport)`, `getFieldOfView()`, `getImagePlaneDepth(viewport)`.
- Planes: `nearPlaneZ()/farPlaneZ()` return **negative** z; `setNearPlaneZ/setFarPlaneZ(z)` assert z<0 and store negated. `getClipPlanes(viewport, outClip)` — world-space planes with normals facing into the frustum, order Near,Right,Left,Top,Bottom,[Far].
- Frustum: `frustum(viewport)` / `frustum(viewport, Frustum& out)`.
- Projection: `project(point, viewport)` → screen x-right/y-down, z = rhw; `inverseProject(point, viewport)`; `projectionMatrix(viewport)` → `Matrix4::perspectiveProjection`; `worldToScreenSpaceArea(area, z, viewport)`.
- Picking: `worldRay(x, y, viewport)` → `RBX::RbxRay` through the pixel (Roblox addition); integer coords are pixel upper-left corners (+0.5 for centers).
- Geometry: `get3DViewportCorners(viewport, UR, UL, LL, LR)` — near-plane corners in world space; `getViewportWidth/Height(viewport)`.

## Lua globals and events

None directly; consumed by `V8DataModel::Camera` which implements the Lua `Camera` instance (Focus, CFrame, ViewportSize, WorldToScreenPoint family).

## Usage (who loads it)

Included wherever camera math is needed without pulling the full engine Camera: e.g. `Rendering/GfxBase/ViewBase.h` (base view class holds one), tool/dragger code via `Workspace::getConstCamera()`-provided views, `MouseCommand.cpp`. `worldRay` callers: `App/v8datamodel/MouseCommand.cpp:102`, `Rendering/GfxBase/ViewportBillboarder.cpp:128`, `App/v8datamodel/BillboardGui.cpp:322`.

## Gotchas

- `project()` returns ±infinity sentinels for points behind the camera, chosen to preserve quadrant information ("helps with clipping") — the y sign convention there looks inverted but is intentional.
- `getZValue` depth-buffer readback exists only as commented-out code (header + cpp).
- File closes with `} // namespace G3D` although the contents are `namespace RBX` — stale comment from the G3D fork.
