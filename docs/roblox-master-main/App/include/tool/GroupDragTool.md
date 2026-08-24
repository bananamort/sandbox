# App/include/tool/GroupDragTool.h

## Purpose

Base implementation for dragging multiple parts / models / mixed selections; owns a `MegaDragger` ([MegaDragger.md](MegaDragger.md)) that performs the physics-side drag. Subclassed by [GroupDropTool.md](GroupDropTool.md).

## Declared API

- `extern const char* const sGroupDragTool;`
- `class GroupDragTool : public Named<MouseCommand, sGroupDragTool>`
  - Ctor: `GroupDragTool(PartInstance* mousePart, const Vector3& hitPointWorld, const PartArray& partArray, Workspace* workspace)`; dtor.
  - Protected: `std::auto_ptr<MegaDragger> megaDragger;` `Vector2 downPoint; bool dragging; Vector3 lastHit;` and `drawConnectors()` → true.
  - Overrides: `onKeyDown`, `onMouseDown`, `onMouseIdle`, `onMouseMove`, `onMouseUp`; `getCursorName()` → `"GrabRotateCursor"` while dragging else `"DragCursor"`.

## Gotchas

- `std::auto_ptr` member — pre-C++11 ownership idiom (copy = transfer); do not "modernize" without touching all consumers.
- Cursor name doubles as mode indicator: GrabRotateCursor implies rotate-mode drag in progress.
- `PartArray` comes from DragUtilities.h — see [DragUtilities.md](DragUtilities.md).
