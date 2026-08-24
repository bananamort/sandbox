# App/include/tool/ResizeTool.h

## Purpose

Studio resize tool: drag a face handle to scale the selected part along one axis. Tracks hover state, grid-snapped hit points and per-axis increments.

## Declared API

- `extern const char* const sResizeTool;`
- `class ResizeTool : public Named<ArrowToolBase, sResizeTool>`
  - `ResizeTool(Workspace*)` — initializes `overHandle(false), moveAxis(0), movePerp(0)`; `isSticky()` self-recreate.
  - Private: `void findTargetPV(const shared_ptr<InputObject>&); void capturedDrag(int axisDelta);` + `drawConnectors()` → true.
  - Protected state: `weak_ptr<PVInstance> targetPV; bool overHandle; NormalId localNormalId; Vector3 hitPointGrid; Vector2int16 down; int moveAxis; int movePerp; int moveIncrement;`
  - Overrides: `render3dAdorn`, `render2d`, `onMouseHover`, `onMouseDown`, `onMouseMove`, `onMouseUp`, `getCursorName`.

## Gotchas

- `targetPV` is weak — selection can be deleted mid-hover; every use must lock.
- Resize math keys off `localNormalId` + `moveAxis`/`movePerp`/`moveIncrement` ints (axis indices, not enums) — grid snapping lands in `hitPointGrid`.
- Note the ctor does not initialize `moveIncrement` or `down`/`hitPointGrid`/`localNormalId` — first hover must set them before use.
