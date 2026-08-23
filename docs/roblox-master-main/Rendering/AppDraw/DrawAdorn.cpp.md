# AppDraw/DrawAdorn.cpp

## Purpose

Implementation of `RBX::DrawAdorn` — the grab-bag of static drawing primitives behind Studio's 3D UI: drag handles (move arrows, resize spheres, rotate tori), the Studio ground grid (`zeroPlaneGrid`), surface grids/borders/polygons, the viewport axis widget, chat-bubble shapes, and generic outline/star boxes. Everything renders through the abstract `GfxBase::Adorn` interface, so it is renderer-independent (works over any Adorn backend).

## API (RBX::DrawAdorn)

**Handle machinery**
- `handlePosInObject(cameraPos, localExtents, handleType, normalId)` — where a handle sits in object space: HANDLE_ROTATE at half-diagonal + `4·HandleOffset` along the rotation axis; HANDLE_RESIZE/MOVE/VELOCITY offset along face normals.
- `scaleHandleRelativeToCamera(...)` / private `scaleRelativeToCamera(cameraPos, pos, minAngle, expectedSize)` — constant-screen-size scaling: visual angle = radius/distance, clamps so handles never shrink below minAngle. Per-type constants: Sphere r=0.5 @2°, Arrow len=3 @3.5°, torus thickness 0.025 @2.5°.
- `handles3d(size, position, adorn, handleType, cameraPos, color, useAxisColor, mask, highlightId, highlightColor)` — draws per-normalId spheres/arrows/tori; rotate type skips duplicate X± pairs (`usedaxes`) and re-sets object matrix after torus(); highlighted handle gets `Material_SelfLitHighlight` + +0.08 radius, others alpha×0.65 (axis rings 0.28).
- `handles2d(...)` — screen-space squares (6px rects via `camera.project`), aborts if projection is infinite.

**Grids**
- `zeroPlaneGrid(adorn, camera, studsPerBox, yLevel, smallColor, largeColor)` — the classic Studio baseplate grid. Small grid (400-stud window, fades by distance) only within `ZEROPLANE_GRID_SIZE_BASE` of the plane; large grid every `studsPerBox × 8`; both honor `FFlag::Studio3DGridUseAALines` (line3dAA vs line3d, thickness 2). Ends with red/green/blue origin rays (len 4) under `Material_SelfLitHighlight` if the frustum intersects a unit sphere at origin.
- `surfaceGridOnFace(prim, adorn, surfaceId, color, boxesPerStud)` — computes face bounds from primitive geometry verts then `surfaceGridAtCoord`.
- `surfaceGridAtCoord(adorn, cF, bounds(Vector4=xmax,ymax,xmin,ymin), dirX, dirY, color, boxesPerStud)` — draws stud lines as thin cylinders (r=0.03 major, 0.01 sub-lines).
- `circularGridAtCoord(...)` — radial tick lines around a rotation ring (`boxesPerStud` divisions).

**Shapes/text**
- `torus(adorn, position, axis, radius, thicknessRadius, color)` — extrusion of `CircleRadialNormal` profile (32×8 segments); local class implements `I3DLinearFunc` eval/evalTangent/evalNormal/evalBinormal/hashString ("CircleRN(r,axis)").
- `chatBubble2d(adorn, rect, pointer, cornerRadius, lineWidth, quarterDivs, color)` — rounded speech bubble + black border as two `convexPolygon2d`s (border drawn first).
- `axisWidget(adorn, camera)` — top-right X/Y/Z colored lines + Arial labels projected from a point 2 studs in front of camera.
- `partInfoText2D(...)` — projects 8 box corners, anchors text at the lowest-rightmost projected corner.
- `star`, `outlineBox(AABox|Extents)` (12 wireframe lines), `selectionBox(AABox|Extents)` (3DS-style quarter-length corner ticks, 24 lines).
- `partSurface(part, surfaceId, adorn, color, thickness)` → private `surfaceBorder` (4 border boxes around one face).
- `faceInWorld`, `surfacePolygon(partInstance, ...)`, `polygonRelativeToCoord`, `lineSegmentRelativeToCoord` (lines as cylinders oriented by `Math::getWellFormedRotForZVector`), `verticalLineSegmentSplit` (recursive 3-level midpoint droop — legacy waterfall-curve drawing), `cylinder(adorn, worldC, axis, len, radius, color, cap=true)` (rotates X-aligned cylinder to requested axis).

**Constants**: `axisColors[3] = {red, green, blue}`; named Color3 constants beige…silver (hex from Color3uint8); transparency consts above; `resizeColor()` inline in header returns (0.1,0.6,1.0).

## Usage

The workhorse behind every Studio gizmo render pass: Draggers (move/rotate/resize handles), surface tools, chat bubbles (via Adorn-based UI), the Studio 3D grid, and selection indicators. Includes V8World Primitive + V8DataModel PartInstance/Camera, Tool/DragTypes, GfxBase Adorn.

## Gotchas

- `zeroPlaneGrid`'s second large-grid loop computes lineStart/End with the *Z-centered* i but then draws an X-axis line using `zeroPlaneLargeCenterX/Z` bounds — visually fine but asymmetric; don't "fix" casually (pixel-parity with shipped Studio).
- `handles2d` early-returns from inside the double loop on infinite z (skips remaining handles).
- `verticalLineSegmentSplit` ignores its `magicParam` name vs cpp's `dropFactor`; recursion depth fixed at 3, factor ×0.25 per level.
- `chatBubble2d` border pointer extension is marked "todo: not correct" upstream.
- `scaleHandleRelativeToCamera` switch has no default — unknown HandleType yields uninitialized floats (debug assert absent here, unlike handlePosInObject which RBXASSERTs).
