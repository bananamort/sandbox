# App/include/tool/LuaDragTool.h

## Purpose

MouseCommand wrapper that drives a [LuaDragger.md](LuaDragger.md) — the scriptable drag controller exposed to Lua tooling. Bridges raw input events into the Lua dragger and handles key-down cancellation.

## Declared API

- `extern const char* const sLuaDragTool;`
- `class LuaDragTool : public Named<MouseCommand, sLuaDragTool>`
  - Ctor: `LuaDragTool(PartInstance* mousePart, const Vector3& hitPointWorld, const std::vector<weak_ptr<PartInstance>>& partArray, Workspace* workspace, shared_ptr<Instance> selectIfNoDrag)`; `~LuaDragTool()`.
  - Private state: `boost::shared_ptr<LuaDragger> luaDragger;` `boost::weak_ptr<Instance> selectIfNoDrag;`
  - Overrides: `onMouseIdle`, `onMouseMove`, `onMouseUp` (returns next command), `getCursorName`, `onKeyDown` (cancel path); public `onMouseDown`.

## Gotchas

- Mixed smart-pointer eras in one header: engine-side `shared_ptr`/`weak_ptr` (RBX aliases) on parameters vs explicit `boost::shared_ptr<LuaDragger>` member.
- The dragger is constructed with a **weak** part array (`weak_ptr<PartInstance>` elements) — parts may die mid-drag and implementations must tolerate that.
- `selectIfNoDrag` mirrors [DropTool.md](DropTool.md)'s fallback-selection convention but is stored weakly here.
