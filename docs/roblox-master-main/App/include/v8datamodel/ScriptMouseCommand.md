# App/include/v8datamodel/ScriptMouseCommand.h

## Purpose

`ScriptMouseCommand` — a `MouseCommand` subclass that adapts the scriptable HopperBin/Tool mouse surface to the engine command architecture: owns the script-facing `Mouse` instance and forwards every mouse event into it (the overrides exist to feed the Mouse's signals, not to change command state).

## Declared API

`class ScriptMouseCommand : public MouseCommand`

- Ctor `ScriptMouseCommand(Workspace* workspace)`, dtor.
- `shared_ptr<Mouse> getMouse()` inline — "A scriptable representation of the Mouse" (private member).
- `virtual TextureId getCursorId() const`.
- Overrides, all taking `shared_ptr<InputObject>`: returning `shared_ptr<MouseCommand>` — `onMouseDown`, `onMouseWheelForward`, `onMouseWheelBackward`, `onRightMouseDown`, `onRightMouseUp`, `onMouseUp`, `onPeekKeyDown`, `onPeekKeyUp`; returning void — `onMouseHover`, `onMouseIdle`; plus `/*override*/ const Name& getName() const`.

## Gotchas

- Return-a-command methods let the handler chain swap commands mid-stream; this class presumably returns itself.
- Lifetime: holds shared_ptr<Mouse> while MouseCommand base is owned by the Workspace command stack.

## UNKNOWN

- Which events map to which Mouse signal fires (out-of-line .cpp).

## Cross-links

- Implementation: [App/v8datamodel/ScriptMouseCommand.md](../../v8datamodel/ScriptMouseCommand.md).
- Base: [MouseCommand.md](MouseCommand.md); mouse: [Mouse.md](Mouse.md); tool twin: [ToolMouseCommand.md](ToolMouseCommand.md), [StudioToolMouseCommand.md](StudioToolMouseCommand.md).
