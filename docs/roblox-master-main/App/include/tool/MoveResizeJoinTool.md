# App/include/tool/MoveResizeJoinTool.h

## Purpose

The modern Studio "move/resize/join" advanced arrow tool (`Named<AdvArrowTool, sMoveResizeJoinTool>`): hover-highlight resize handles, live ghost preview of the resized part (original position/transparency cached), grid-aware increments, and selection-change plumbing.

## Declared API

- `extern const char* const sMoveResizeJoinTool;`
- `class MoveResizeJoinTool : public Named<AdvArrowTool, sMoveResizeJoinTool>`
  - `MoveResizeJoinTool(Workspace*)` — inits overHandle/movePerp/dragging/origPartSize/cursor("advCursor-default")/origPartTransparency; `isSticky()` self-recreate.
  - Private: `findTargetPV(inputObject)`, `capturedDrag(float axisDelta)`, `float moveIncrement(void)`, `int smallGridBoxesPerStud(void)`; `static weak_ptr<PVInstance> scalingPart;` (static!); `drawConnectors()` → true.
  - Protected resize core: `bool resizeFloat(shared_ptr<PartInstance> part, NormalId localNormalId, float amount, bool checkIntersection);` `bool advResizeImpl(same signature);`
  - State: `weak_ptr<PVInstance> targetPV; bool overHandle; NormalId localNormalId; Vector3 hitPointGrid; Vector2int16 down; int movePerp; bool dragging; CoordinateFrame origPartPosition; Vector3 origPartSize; std::string cursor; float origPartTransparency;`
  - Overrides: `render3dAdorn`, `render2d`, `onMouseIdle/Hover/Down/Move/Up`, `getCursorName()` → cursor, `onKeyDown` (cancel), `setCursor(std::string)`.
  - Public static: `static void setSelection(shared_ptr<Instance> oldSelection, shared_ptr<Instance> newSelection);`

## Gotchas

- `scalingPart` is a **static** weak_ptr shared across all tool instances — stale across sessions if not cleared by setSelection.
- Ghost preview contract: ctor snapshot fields (`origPartPosition/Size/Transparency`) must be saved on drag start and restored on failure/cancel; per the .cpp, `resizeFloat(...)` is just `part->destroyJoints()` → `advResizeImpl(...)` → `part->join()` — same `checkIntersection` flag, and the impl itself grid-quantizes `amount` through `moveIncrement()` before resizing.
- Ctor leaves `targetPV` unset and `localNormalId`/`hitPointGrid`/`down` uninitialized until first hover.
