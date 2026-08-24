# App/include/tool/AdvRotateTool.h

## Purpose

Advanced (Studio) rotation tool built on `AdvMoveToolBase`: green rotate handles with local/global space toggle, hover detection of which handle normal the mouse is over, and 2D/3D adorn rendering.

## Declared API

- `extern const char* const sAdvRotateTool;`
- `class AdvRotateTool : public Named<AdvMoveToolBase, sAdvRotateTool>`
  - `AdvRotateTool(Workspace*)` — initializes `mOverHandleNormalId(NORM_UNDEFINED)`.
  - Private: `int getNormalMask() const;` (defined in .cpp); `mutable NormalId mOverHandleNormalId;`
  - Protected virtuals: `Color3 getHandleColor()` → green; `HandleType getDragType()` → `HANDLE_ROTATE`; `bool getLocalSpaceMode() const;` `bool getOverHandle(const shared_ptr<InputObject>&, Vector3& hitPointWorld, NormalId& normalId) const;`
  - Public: `isSticky()` self-recreate; overrides `void render2d(Adorn*)`, `void render3dAdorn(Adorn*)`.

## Gotchas

- Despite the name it derives from **AdvMoveToolBase** (not a rotate base) — move/rotate advanced tools share one base; see [AdvMoveTool.md](AdvMoveTool.md).
- `mOverHandleNormalId` is `mutable` and updated during const hit-testing — render paths read it without recomputing hover.
- Local-vs-global rotation axis comes from `getLocalSpaceMode()`, which reads tool state set by Lua/Studio shortcuts.
