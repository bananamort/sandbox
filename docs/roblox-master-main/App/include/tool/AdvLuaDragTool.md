# App/include/tool/AdvLuaDragTool.h

## Purpose

Advanced-arrow-tool variant of [LuaDragTool.md](LuaDragTool.md): drives an [AdvLuaDragger.md](AdvLuaDragger.md) for script-controlled drags under the Studio advanced arrow tool, with its own hover gating (`canDrag`) and cursor management.

## Declared API

- `extern const char* const sAdvLuaDragTool;`
- `class AdvLuaDragTool : public Named<AdvArrowToolBase, sAdvLuaDragTool>`
  - Ctor: `AdvLuaDragTool(PartInstance* mousePart, const Vector3& hitPointWorld, const std::vector<weak_ptr<PartInstance>>& partArray, Workspace* workspace, shared_ptr<Instance> selectIfNoDrag)`; dtor.
  - Private: `boost::shared_ptr<AdvLuaDragger> advLuaDragger; boost::weak_ptr<Instance> selectIfNoDrag; std::string cursor; bool dragging; G3D::Vector2 downPoint2d;` + `bool canDrag(const shared_ptr<InputObject>&) const;`
  - Overrides: `onMouseIdle`, `onMouseMove`, `onMouseUp`, `getCursorName()` → cursor, `onKeyDown` (cancel), `setCursor(std::string)`; public `onMouseDown`.

## Gotchas

- Derives from **AdvArrowToolBase** (via [ToolsArrow.md](ToolsArrow.md)) rather than plain MouseCommand — inherits selection adorn behavior of the arrow tool.
- `setCursor` is a virtual setter other code can push cursor changes through — the cursor string is externally owned state here.
- Weak part array as in LuaDragTool: parts may expire mid-drag.
