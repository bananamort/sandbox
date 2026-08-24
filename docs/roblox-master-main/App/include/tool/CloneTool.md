# App/include/tool/CloneTool.h

## Purpose

Classic clone tool: mouseDown clones the part under the cursor and begins dragging the copy.

## Declared API

- `extern const char* const sCloneTool;`
- `class CloneTool : public Named<MouseCommand, sCloneTool>`
  - `CloneTool(Workspace*)`, `~CloneTool()`.
  - Private: `shared_ptr<PartInstance> clonePart;` — the pending clone; overrides `onMouseIdle`, `getCursorName`, `onMouseDown`; public `isSticky()` (self-recreate), `drawConnectors()` → true.

## Gotchas

- Same MouseCommand family pattern as [GrabTool.md](GrabTool.md)/[GameTool.md](GameTool.md); all logic in the .cpp outside this tree.
