# App/include/tool/RunDragger.h

## Purpose

Single-part snap dragger ("run dragger"): computes grid/surface snapping of a dragged part against neighboring geometry — ray-hit candidate selection, adjacency tests, fall-off-edge handling, camera proximity checks. An `IAdornable` owned by [PartDragTool.md](PartDragTool.md)/[LuaDragger.md](LuaDragger.md) (comment: "Poor man's version — ultimately, change all internally to shared_ptr's").

## Declared API

- `class RunDragger : public IAdornable`
  - Nested `class SnapInfo { Primitive* snap; size_t mySurfaceId; Vector3 hitWorld, lastHitWorld, lastDragSnap; SnapInfo() /* inits to NULL / (size_t)-1 / Vector3::inf() */; void updateHitFromSurface(const RbxRay&); void updateSurfaceFromHit(); float hitOutsideExtents(); }`
  - State: `weak_ptr<PartInstance> dragPart, snapPart; Workspace* workspace; Primitive* drag; Vector3 dragPointLocal; Matrix3 dragOriginalRotation;` carry-forward `SnapInfo snapInfo;` per-snap `RbxRay mouseRay;` computed-per-snap `NormalId dragSurface; size_t myDragSurfaceId; Vector3 dragHitLocal;`
  - Private machinery: `createSnapSurface(Primitive*, G3D::Array<size_t>* ignore = NULL)`, `moveDragPart()`, `snapDragPart()`, `snapRotatePart()`, `findSafeY()`, `notTried(prim, tried)`, `adjacent(p0, p1)`, `rayHitsPart(triedSnap, forceAdjacent)`, `bestProximatePart(triedSnap, Contact::ProximityTest)`, `fallOffEdge()`, `fallOffPart(bool& snapped)`, `colliding()`, `rayHitsCloserPart()`, `tooCloseToCamera()`, `findSnap(triedSnap)`, `findNoSnapPosition(original)`, `snapInfoFromSnapPart()`, `snapPartFromSnapInfo()`.
  - Public: ctors/dtor; `init(Workspace*, weak_ptr<PartInstance> dragPart, const Vector3& dragPointWorld)` and `initLocal(... dragPointLocal)`; **`bool snap(const RbxRay& mouseRay)`** (main entry per mouse move); `rotatePartAboutSnapFaceAxis(Vector3::Axis, const float& angleInRads)`; `rotatePart90DegAboutSnapFaceAxis(axis)`; `CoordinateFrame getSnapSurfaceCoord();`
  - Statics with header note "these static functions will NOT update dragOriginalRotation": `turnUpright(PartInstance*)`, `rotatePart(PartInstance*)`, `tiltPart(PartInstance*, const CoordinateFrame& camera)`.

## Gotchas

- The static rotate/tilt helpers bypass instance rotation bookkeeping — mixing them mid-drag desyncs `dragOriginalRotation`.
- Snap candidates are tracked via a `tried` list of raw `Primitive*`; prims dying between frames is the caller's problem.
- Sentinel values are `Vector3::inf()` / `(size_t)-1` — check before treating SnapInfo as valid.

## UNKNOWN

- Which surfaces qualify as snap targets (surface-type filtering lives in the .cpp).
