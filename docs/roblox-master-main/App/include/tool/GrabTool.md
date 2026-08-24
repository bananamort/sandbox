# App/include/tool/GrabTool.h

## Purpose

Classic grab tool: hover highlights, mouseDown starts dragging the part under the cursor. One of the original 2003–2005 tools.

## Declared API

- `extern const char* const sGrabTool;`
- `class GrabTool : public Named<MouseCommand, sGrabTool>`
  - `GrabTool(Workspace*)`, `~GrabTool()`.
  - Private: `std::string cursor;` — mutable cursor name swapped by handlers; overrides `onMouseIdle`, `onMouseHover`, `onMouseDown` (returns next MouseCommand), `getCursorName()` → cursor; `drawConnectors()` → true ("default mouse command no draw connectors").
  - `isSticky()` → recreates itself via `Creatable<MouseCommand>::create<GrabTool>(workspace)`.

## Gotchas

- `drawConnectors()==true` opts into physics-connector rendering that most MouseCommands suppress.
