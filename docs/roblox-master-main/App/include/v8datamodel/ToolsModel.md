# App/include/v8datamodel/ToolsModel.h

## Purpose

Legacy Studio mouse-command tools over models: base `ModelTool` (hover + adorn over a top-level Instance), `AnchorTool` (toggles anchored with an allAnchored memory), and `LockTool` (toggles Locked). All sticky commands.

## Declared API

`class ModelTool : public MouseCommand`
- Protected: `shared_ptr<Instance> topInstance`; overrides `onMouseHover(InputObject)`, `render3dAdorn(Adorn*)`.
- Ctor/dtor `(Workspace*)`.

`class AnchorTool : public Named<ModelTool, sAnchorTool>`
- Private `bool allAnchored` (init false in inline ctor).
- Overrides: `onMouseHover`, `onMouseDown`, `getCursorName()`, inline `onMouseUp {return shared_from(this);}` — commented "sticky".
- Static helper: `static bool allChildrenAnchored(Instance* test)`.

`class LockTool : public Named<ModelTool, sLockTool>`
- Overrides: `onMouseDown`, `getCursorName()`, inline sticky `onMouseUp`.
- Inline ctor.

## Gotchas

- Sticky pattern: onMouseUp returns the same command (`shared_from(this)`) so the tool stays active across clicks — contrast FillTool which creates a NEW instance in isSticky.
- allAnchored lets AnchorTool decide toggle direction per hover session.

## UNKNOWN

- Cursor names' asset mapping ("AnchorCursor" etc. not shown here).

## Cross-links

- Implementation: [App/v8datamodel/ToolsModel.md](../../v8datamodel/ToolsModel.md).
- Base: [MouseCommand.md](MouseCommand.md); part tools: [ToolsPart.md](ToolsPart.md); surface tools: [ToolsSurface.md](ToolsSurface.md).
