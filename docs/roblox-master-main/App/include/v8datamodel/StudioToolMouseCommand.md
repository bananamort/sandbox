# App/include/v8datamodel/StudioToolMouseCommand.h

## Purpose

`StudioToolMouseCommand` — `ScriptMouseCommand` subclass bound to a `StudioTool`: routes mouse-down/up into tool activation and tears itself down when the tool is unequipped (scoped connection to the tool's unequip signal).

## Declared API

`class StudioToolMouseCommand : public Named<ScriptMouseCommand, sStudioToolMouseCommand>`

- Private: `shared_ptr<StudioTool> tool`; scoped_connection `toolUnequipped`; `void onEvent_ToolUnequipped()`.
- Ctor `StudioToolMouseCommand(Workspace* workspace, shared_ptr<StudioTool> tool)`; dtor.
- Inline `const StudioTool* getStudioTool() const`.
- Overrides: `shared_ptr<MouseCommand> onMouseDown(const shared_ptr<InputObject>&)`, `onMouseUp(...)`.

## Gotchas

- Holds shared_ptr<StudioTool> while the command lives in the workspace stack — circular-ish ownership broken by onEvent_ToolUnequipped self-removal.
- Inherits ScriptMouseCommand's Mouse plumbing; only down/up are overridden here.

## UNKNOWN

- What activation state changes occur in onMouseDown vs onMouseUp (out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/StudioToolMouseCommand.md](../../v8datamodel/StudioToolMouseCommand.md).
- Base chain: [ScriptMouseCommand.md](ScriptMouseCommand.md), [MouseCommand.md](MouseCommand.md); peer: [ToolMouseCommand.md](ToolMouseCommand.md); tool: [StudioTool.md](StudioTool.md).
