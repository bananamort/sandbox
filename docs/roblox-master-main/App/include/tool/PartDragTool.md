# App/include/tool/PartDragTool.h

## Purpose

Single-part drag MouseCommand. Combines two drag engines: `RunDragger` ("does snapping") and `MegaDragger` ("does join / unJoin"). Base class of [PartDropTool.md](PartDropTool.md).

## Declared API

- `extern const char* const sPartDragTool;`
- `class PartDragTool : public Named<MouseCommand, sPartDragTool>`
  - Ctor: `PartDragTool(PartInstance* mousePart, const Vector3& hitPointWorld, Workspace* workspace, shared_ptr<Instance> selectIfNoDrag)`; dtor.
  - Protected: `std::auto_ptr<RunDragger> runDragger;` `std::auto_ptr<MegaDragger> megaDragger;` `shared_ptr<Instance> selectIfNoDrag; Vector2 downPoint; bool dragging; Vector3 hitWorld;` + `drawConnectors()` → true.
  - Overrides: full input set — `onMouseDown/onIdle/onMove/onDelta/onUp/onKeyDown`, `render3dAdorn`, `getCursorName()` → `"GrabRotateCursor"` while dragging else `"DragCursor"`.

## Gotchas

- Two dragger members with split responsibilities (snap vs join/unjoin) — behavior changes must consider which one owns a given side effect.
- `std::auto_ptr` members as in [GroupDragTool.md](GroupDragTool.md).
