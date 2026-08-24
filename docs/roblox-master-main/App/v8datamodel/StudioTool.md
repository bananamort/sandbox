# StudioTool.cpp

## Purpose

Implements `StudioTool` ("StudioTool", DescribedNonCreatable), the base for Studio's tool palette items: Enabled flag plus Equipped/Unequipped/Activated/Deactivated events. Equipping installs a StudioToolMouseCommand into the Workspace and hands its Mouse to listeners.

## Key types and API

Descriptors (no security tiers ⇒ default):
- Events: "Equipped(mouse:Instance)", "Unequipped()", "Activated()", "Deactivated()".
- `prop_Enabled("Enabled")` — bool, category "State", default false.

Behavior:
- `equip(workspace)`: raises Equipped with the Mouse from a fresh StudioToolMouseCommand installed via `workspace->setMouseCommand(...)`.
- `unequip()`: raises Unequipped (the mouse command listens to this signal to release itself — see StudioToolMouseCommand.md).
- `activate()/deactivate()`: raise Activated/Deactivated (invoked by the mouse command on down/up).
- `setEnabled`: change-tracked.

## Usage / reflection touchpoints

Events script-facing (plugin tools). Pairs with StudioToolMouseCommand.md / StudioToolVerb.md (menu binding), MouseCommand.md in this folder.

## Gotchas

- equip does not check current Enabled state — equipping is driven by Verb layer.
- No guard against double-equip; each call installs ANOTHER mouse command replacing the previous via setMouseCommand semantics (UNKNOWN whether old one is released header-side).
