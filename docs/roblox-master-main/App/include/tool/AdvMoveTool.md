# App/include/tool/AdvMoveTool.h

## Purpose

Declares `AdvMoveToolBase` (base for the advanced Studio move/rotate gizmo tools, deriving `AdvArrowToolBase`) and the concrete orange `AdvMoveTool` (`Named<AdvMoveToolBase, sAdvMoveTool>`, HANDLE_MOVE). Parent of [AdvRotateTool.md](AdvRotateTool.md).

## Declared API

- `class AdvMoveToolBase : public AdvArrowToolBase`
  - `AdvMoveToolBase(Workspace*)`; empty virtual dtor.
  - Protected state: `bool dragging; Ray dragRay; int dragAxis; int dragAxisDirection; NormalId dragNormalId; std::string cursor;` + "TODO: Have a single variable in Move and Rotate tool" `mutable NormalId overHandleNormalId;`
  - Private: `std::auto_ptr<MegaDragger> megaDragger; Vector2int16 downPoint2d;` `Vector3 lastPoint3d;` ("dynamic — last point on the Ray we dragged to // only works with one-stud grid..."); `typedef std::map<boost::weak_ptr<PartInstance>, float> PartsTransparencyCollection; PartsTransparencyCollection origPartsTransparency;` (instance copy of the base's static map); `mutable Matrix3 mMultiRotation; mutable Extents mExtents; mutable bool mInitializedExtents;`
  - Private helpers: `float snapRotationAngle(float Angle) const;` (capital-A param), `saveAndModifyPartsTransparency()` / `restoreSavedPartsTransparency()`, `rbx::signals::scoped_connection selectionChangedConnection; void setToSelection();`
  - Protected virtuals: `getLocalSpaceMode()`, `getOverHandle(inputObject, hitPointWorld&, normalId&)`; non-virtual `getExtents(Extents&) const`, `getExtentsAndLocation(Extents&, CoordinateFrame& location, bool& isLocal) const`, single-out `getOverHandle(inputObject)`.
  - Overrides: full input set + `render2d/render3dAdorn`, `getCursorName`, `setCursor(std::string)`; pure virtuals `getHandleColor()` / `getDragType()`.
- `extern const char* const sAdvMoveTool;`
- `class AdvMoveTool : public Named<AdvMoveToolBase, sAdvMoveTool>`
  - Orange handles (`Color3::orange()`), `HANDLE_MOVE`; overrides `render2d`, `onMouseDown`; private `void getGridXYUsingCamera(PartInstance* part, G3D::Vector3& gridXDir, G3D::Vector3& gridYDir);` state `G3D::Vector3 originalLocation;` `isSticky()` self-recreate.

## Gotchas

- Transparency ghosting uses a **static** collection in AdvArrowToolBase plus an instance map here — restore paths must match save paths or parts keep ghost transparency.
- `lastPoint3d` comment warns it "only works with one-stud grid".
- The TODO about duplicated overHandleNormalId is still open: base keeps its own mutable copy alongside [AdvRotateTool.md](AdvRotateTool.md)'s `mOverHandleNormalId`.
