# StudioToolMouseCommand.cpp

## Purpose

Implements `StudioToolMouseCommand`, the ScriptMouseCommand subclass binding a StudioTool to the input pipeline: left down → tool Activated, up → Deactivated, and self-destruct semantics when the tool is unequipped from elsewhere.

## Key types and API

Extends ScriptMouseCommand (all pass-through update behavior inherited).

- Ctor(workspace, studioTool): connects the tool's `unequippedSignal` → onEvent_ToolUnequipped (which just disconnects — marking "tool released me").
- Dtor: if STILL connected (command dying while tool thinks it's equipped) → calls `tool->unequip()` then asserts disconnection — ensures Unequipped fires exactly once per equip lifetime.
- `onMouseDown`: fires `tool->activate()`, then EITHER keeps capture (Super::onMouseDown) when connection still alive, OR returns NULL mouse command ("will reset to default") — a race-safe teardown: if unequip happened between signal fire and here, release.
- `onMouseUp`: fires `tool->deactivate()` then Super.

## Usage / reflection touchpoints

Not script-facing; pairs with StudioTool.md, StudioToolVerb.md, ScriptMouseCommand.md in this folder.

## Gotchas

- activate() fires BEFORE the keep/release decision — tools receive Activated even when the command immediately releases.
- The unequip-during-down window produces: Deactivated never paired (activate fired, but onMouseUp path may not run after release).
- RBXASSERT in dtor assumes unequip synchronously disconnects; any async listener would trip debug builds.
