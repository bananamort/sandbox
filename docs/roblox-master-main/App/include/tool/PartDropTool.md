# App/include/tool/PartDropTool.h

## Purpose

Drop-phase counterpart of [PartDragTool.md](PartDragTool.md) for single-part drags: finishes the drag on mouseUp, supports cancel, and remembers the grab point in part-local space.

## Declared API

- `extern const char* const sPartDropTool;`
- `class PartDropTool : public Named<PartDragTool, sPartDropTool>, public ICancelableTool`
  - Ctor: `PartDropTool(PartInstance* mousePart, const Vector3& hitPointWorld, Workspace* workspace, shared_ptr<Instance> selectIfNoDrag)`; dtor.
  - Overrides: `onMouseDelta`, `onMouseDown`, `onKeyDown` (next-command returns), `getCursorName()` → `isAdvArrowToolEnabled() ? "advClosed-hand" : "DropCursor"`; ICancelableTool `onCancelOperation()`.
  - Private: `Vector3 hitLocal;` — grab offset stored in the dragged part's local frame.

## Gotchas

- Commented-out `onMouseUp` override — drop completion must be reached through base PartDragTool behavior or cancel; check .cpp before assuming mouseUp is handled here.
- Same dual cursor convention as [GroupDropTool.md](GroupDropTool.md).
