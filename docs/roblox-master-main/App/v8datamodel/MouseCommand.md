# MouseCommand.cpp

## Purpose

Implements `MouseCommand`, the engine-side raycasting/cursor helper behind the legacy Mouse object and Studio drag tools. It converts a screen-space InputObject into a world ray, casts it through the physics ContactManager honoring filters and camera-ignored primitives, and resolves the hit PartInstance/Surface. Also owns cursor texture naming and character-reach rules. Not itself script-facing — it is consumed by Mouse.cpp, tools (ArcHandles/Handles), and DragUtilities.

## Key types and API

`class MouseCommand` (constructed against a `Workspace*`; statics: `ignoreVector3`, `advArrowToolEnabled=false`).

Core statics/helpers:
- `getUnitMouseRay(inputObject, ICameraOwner*)` → camera->worldRay(rawPosition.x, rawPosition.y); instance overloads use the stored workspace.
- `getSearchRay(unitRay)` extends the unit direction by `maxSearch()` (constant from header).
- `getPart(workspace, inputObject, filter, Vector3& hitWorld)`: guards NaN camera direction (`dir.y != dir.y` check returns NULL), gathers ignore primitives from the Workspace camera's CameraSubject (`getSelectionIgnorePrimitives`), then `getMousePart(...)` → `ContactManager::getHit(searchRay, &ignore, filter, hitPoint)` → `PartInstance::fromPrimitive`. On miss sets hitWorld = origin + 10000*direction.
- `getSurface(workspace, inputObject, filter[, part&, surfaceId&])`: getPart then `part->getSurface(gridRay, surfaceId)`.
- `getPartByLocalCharacter(...)`: wraps caller filter in a `MergedFilter` with `PartByLocalCharacter` (used by Mouse.Hit so your own character is excluded).
- `getUnlockedPartByLocalCharacter`, `getUnlockedPart`: same plus lock filtering.
- `getTopSelectable3d(PartInstance*)`: walks ancestors up to the Workspace preferring the outermost ancestor whose `Selectable::isSelectable3d()` is true; NULL when the part itself isn't selectable3d — this is what makes clicking a part select its Model.
- `getCursorId()`: builds `"Textures/<CursorName>.png"` from virtual `getCursorName()`, but maps StudsCursor/InletCursor/UniversalCursor to `Textures/FlatCursor.png`.
- `capture()`: asserts no current command has captured, sets capturedMouse.
- `distanceToCharacter(hitPoint)` / `characterCanReach(hitPoint)`: distance from the local Humanoid head; reach threshold hardcoded at 60 studs.

## Usage / reflection touchpoints

No REFLECTION block in this file — zero direct Lua surface. Everything reaches scripts indirectly: the legacy Mouse's Hit/Target/TargetSurface/UnitRay getters all funnel into these functions; Studio tools subclass MouseCommand for drag behavior; filters (Filters.h: PartByLocalCharacter, UnlockedPartByLocalCharacter) compose via MergedFilter.

## Gotchas

- Raycast silently fails (NULL part) on NaN camera direction or non-unit ray directions — callers must treat NULL as "sky".
- Miss case still writes hitWorld 10,000 studs out rather than leaving garbage.
- The 60-stud characterCanReach limit is hard-coded here, not configurable.
- Cursor asset substitution means StudsCursor/InletCursor pngs are dead names — FlatCursor.png ships instead.
- UNKNOWN: maxSearch() value and the full MouseCommand subclass hierarchy live in MouseCommand.h / tool files outside this TU.
