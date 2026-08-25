# App/include/tool/GameTool.h

## Purpose

In-game drag tool (the "game" grab/drag used during play, as opposed to Studio edit tools): drags parts that pass a `draggablePart` filter.

## Declared API

- `extern const char* const sGameTool;`
- `class GameTool : public Named<MouseCommand, sGameTool>`
  - `GameTool(Workspace*)`, `~GameTool()`.
  - Private: `std::string cursor;`; `bool draggablePart(const PartInstance* part, const Vector3& hitPoint) const` — eligibility gate; overrides `onMouseHover`, `onMouseDown`, `onMouseIdle`, `getCursorName()`; `drawConnectors()` → true.
  - `isSticky()` → self-recreate.

## Gotchas

- The draggable-part predicate is the security-relevant piece — per `App/tool/GameTool.cpp` it is `!part->getPartLocked() && !part->lockedInPlace() && characterCanReach(hitPoint)` (lock flags + reach distance); none of that logic lives in this header.

## UNKNOWN

- Exact `draggablePart` criteria (implementation outside App/include).
