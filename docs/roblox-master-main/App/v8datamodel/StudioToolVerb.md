# StudioToolVerb.cpp

## Purpose

Implements `StudioToolVerb`, the Verb (menu/keyboard command) wrapper that equips/toggles a StudioTool. Checked state derives from whether the Workspace's current mouse command IS this tool's command.

## Key types and API

Extends Verb (Studio UI command abstraction).

- Ctor(name, studioTool, workspace, toggle): toggle=true makes re-invoking a checked tool turn it off.
- `isEnabled()`: tool exists AND tool->getEnabled().
- `isChecked()`: dynamic_cast current workspace mouse command to StudioToolMouseCommand and compare its getStudioTool() to this tool.
- `doIt(IDataState*)`: if checked AND toggle → `workspace->setNullMouseCommand()` (which cascades unequip); else → `studioTool->equip(workspace)`.

## Usage / reflection touchpoints

No reflection — Studio menu plumbing. Pairs with StudioTool.md / StudioToolMouseCommand.md in this folder; Verb base under App docs.

## Gotchas

- Non-toggle verbs re-equip every invocation even when already active (replaces mouse command).
- isChecked relies on the CURRENT command being exactly a StudioToolMouseCommand — tools wrapped by other command types lose their checked state.
