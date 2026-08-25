# App/include/tool/AxisMoveTool.h

## Purpose

Defines `AxisToolBase` (this file's real content; no class literally named AxisMoveTool): the arrow-tool base for axis-gizmo move/rotate tools ([AxisRotateTool.md](AxisRotateTool.md) and the move variant). Owns a MegaDragger, tracks the drag ray/axis, and renders the gizmo.

## Declared API

- `class AxisToolBase : public ArrowToolBase` (from [ToolsArrow.md](ToolsArrow.md))
  - `AxisToolBase(Workspace* workspace)`.
  - Private state: `std::auto_ptr<MegaDragger> megaDragger; std::string cursor; bool dragging; Vector2int16 downPoint2d; RbxRay dragRay; int dragAxis; Vector3 lastPoint3d;` ("dynamic — last point on the Ray we dragged to").
  - Private helpers: `bool getExtents(Extents&) const;` two overloads `getOverHandle(inputObject[, hitPointWorld, normalId])`; private override `drawConnectors()` → true.
  - Protected overrides: `onMouseIdle/onMouseHover/onMouseDown/onMouseMove/onMouseUp`, `render2d`, `render3dAdorn`, `getCursorName()` → cursor.
  - Pure virtuals each subclass must implement: `virtual Color3 getHandleColor() const = 0;` `virtual HandleType getDragType() const = 0;`

## Gotchas

- File/name mismatch: header is AxisMoveTool.h but declares only AxisToolBase — a concrete AxisMoveTool class is not declared here.
- Handle hit-testing is done in screen space via `downPoint2d` vs projected handles; `getOverHandle` overload without out-params returns boolean-only.
- Subclass contract: color + HandleType fully determine gizmo appearance (green/HANDLE_ROTATE for [AxisRotateTool.md](AxisRotateTool.md)).
