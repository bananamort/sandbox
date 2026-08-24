# App/include/v8datamodel/ToolMouseCommand.h

## Purpose

`ToolMouseCommand` — `ScriptMouseCommand` subclass bound to a game `Tool`: routes mouse events into the tool's Mouse/activation (including target-point replication and ClickDetector interception via tryClickable), tracks button state, and self-removes on tool unequip.

## Declared API

`class ToolMouseCommand : public Named<ScriptMouseCommand, sToolMouseCommand>`

- Private: `shared_ptr<Tool> tool`; scoped_connection `toolUnequipped`; `bool mouseIsDown`; handlers `onEvent_ToolUnequipped()`, `updateTargetPoint(const shared_ptr<InputObject>&, bool replicate)`, `bool tryClickable(inputObject, shared_ptr<PartInstance>)`.
- Ctor `ToolMouseCommand(Workspace* workspace, Tool* tool)`; empty inline dtor.
- Overrides: returning command — `onMouseDown`, `onMouseUp`, `onRightMouseDown`, `onRightMouseUp`; void — `onMouseHover`, `onMouseIdle`.

## Gotchas

- Holds shared_ptr<Tool> while living in the workspace command stack; unequip handler breaks the cycle by self-removal.
- tryClickable implies ClickDetectors intercept tool clicks before the tool's own mouse sees them.
- updateTargetPoint's replicate flag distinguishes local-only hover updates from replicated target points.

## UNKNOWN

- Which activation state values are pushed on down vs up (out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/ToolMouseCommand.md](../../v8datamodel/ToolMouseCommand.md).
- Base chain: [ScriptMouseCommand.md](ScriptMouseCommand.md), [MouseCommand.md](MouseCommand.md); tool: [Tool.md](Tool.md); studio twin: [StudioToolMouseCommand.md](StudioToolMouseCommand.md).
