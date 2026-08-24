# App/include/tool/NullTool.h

## Purpose

`NewNullTool` — the default "no tool" MouseCommand: click-to-move waypoints, ClickDetector hover, first-person awareness. Comment in-header calls it the "Super tool — combines click to move, etc."

## Declared API

- `extern const char* const sNewNullTool;`
- `class NewNullTool : public Named<MouseCommand, sNewNullTool>`
  - `NewNullTool(Workspace*)`, `~NewNullTool()`.
  - Private: `std::string cursor; bool hasWaypoint; Vector3 waypoint;` `bool isInFirstPerson();` `void getIndicatedPart(const shared_ptr<InputObject>& inputObject, const bool& clickEvent, PartInstance** instance, bool* clickable, Vector3* waypoint);` `void updateClickDetectorHover(const shared_ptr<InputObject>&);`
  - Overrides: `onMouseIdle`, `onMouseHover`, `onMouseDown`, `onRightMouseDown`, `getCursorName()` → cursor, `isSticky()` (self-recreate), `onMouseUp` inline → `{ releaseCapture(); return shared_from(this); }`, `onRightMouseUp`; IAdornable side: `shouldRender3dAdorn()` → true, `render3dAdorn`.

## Gotchas

- Inline `onMouseUp` returns `shared_from(this)` — requires the instance to already be held by a shared_ptr (else bad_weak_ptr / UB); it keeps the tool installed rather than returning a next command.
- `getIndicatedPart` takes `const bool&` for a value parameter and three out-pointers including nullable ones — C-style multi-out API.
- Waypoint state (`hasWaypoint/waypoint`) feeds click-to-move adorn rendering.
