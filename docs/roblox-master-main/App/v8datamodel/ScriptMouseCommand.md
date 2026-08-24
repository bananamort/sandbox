# ScriptMouseCommand.cpp

## Purpose

Implements `ScriptMouseCommand`, the MouseCommand subclass installed while a script-owned Mouse is active (legacy LocalScript tool/mouse handling). Wraps a plain `Mouse` Instance: every input callback just forwards the InputObject into `mouse->update(inputObject)` and keeps itself captured; cursor id mirrors the Mouse icon.

## Key types and API

Extends MouseCommand (see MouseCommand.md for base contract).

- Ctor(workspace): FASTLOG lifetime trace, creates `Mouse` via Creatable, sets its workspace.
- Dtor: detaches mouse workspace (NULL).
- `getCursorId()`: returns `mouse->getIcon()` — script-controlled cursor via Mouse.Icon.
- Input overrides — onMouseDown/onMouseWheelForward/onMouseWheelBackward/onRightMouseDown/onRightMouseUp/onMouseUp/onPeekKeyDown/onPeekKeyUp: all are `mouse->update(inputObject); return shared_from(this);` (keep-capture). The two VOID overrides onMouseHover/onMouseIdle only call `mouse->update(inputObject)` with no capture semantics. No filtering anywhere.
- `getName()`: returns `Mouse::className()` — masquerades as "Mouse" for command naming.

## Usage / reflection touchpoints

Not script-facing directly; exists so legacy Mouse events fire through the MouseCommand pipeline. Pairs with Mouse.md, MouseCommand.md, PluginManager.md (its activate/exclusiveMouse sets Workspace null command instead) in this folder.

## Gotchas

- Keyboard events route through mouse->update too (PeekKey*) — Mouse sees key InputObjects though only mouse state is documented.
- Never releases capture on any input — deactivation must come from Workspace command replacement.
- getName lying about identity could confuse debug/diagnostic code expecting the concrete class name.
