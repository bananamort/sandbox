# App/include/tool/GroupDropTool.h

## Purpose

Drop-phase counterpart of [GroupDragTool.md](GroupDragTool.md): carries an existing multi-part drag to completion, with key/mouse handlers and cancel support. Cursor switches between `advClosed-hand` (advanced arrow tool enabled) and `DropCursor`.

## Declared API

- `extern const char* const sGroupDropTool;`
- `class GroupDropTool : public Named<GroupDragTool, sGroupDropTool>, public ICancelableTool`
  - Ctor: `GroupDropTool(PartInstance* mousePart, const PartArray& partArray, Workspace* workspace, bool suppressPartsAlign = false)`; dtor.
  - Overrides: `onKeyDown`, `onMouseDown`, `onMouseUp` (each returns next MouseCommand), `getCursorName()`; ICancelableTool: `onCancelOperation()`.

## Gotchas

- Inherits from GroupDragTool purely to reuse its drag plumbing — a GroupDropTool *is* a GroupDragTool in the type system.
- `onMouseDelta` override is commented out; delta handling falls back to the base class.
- `suppressPartsAlign` default false — same parts-alignment gate as [DropTool.md](DropTool.md).
