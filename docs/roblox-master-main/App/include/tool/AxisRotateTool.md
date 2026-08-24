# App/include/tool/AxisRotateTool.h

## Purpose

Studio-style axis rotation tool: green rotate handles around the selected part. A thin `Named<AxisToolBase>` specialization that only overrides handle color, drag type, and stickiness.

## Declared API

- `extern const char* const sAxisRotateTool;` — reflection name.
- `class AxisRotateTool : public Named<AxisToolBase, sAxisRotateTool>`
  - `AxisRotateTool(Workspace* workspace)`.
  - Private overrides: `Color3 getHandleColor() const` → `Color3::green()`; `HandleType getDragType() const` → `HANDLE_ROTATE`.
  - Public override: `shared_ptr<MouseCommand> isSticky() const` → creates another `AxisRotateTool` via `Creatable<MouseCommand>::create<...>(workspace)` (tool re-installs itself while active).

## Gotchas

- All actual behavior lives in [AxisMoveTool.md](AxisMoveTool.md)'s `AxisToolBase`; this header only parameterizes it.
- `isSticky()` returning a fresh instance of itself is the standard MouseCommand "keep tool selected after click" idiom — each activation allocates a new object.
