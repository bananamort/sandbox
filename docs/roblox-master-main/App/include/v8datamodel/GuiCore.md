# App/include/v8datamodel/GuiCore.h

## Purpose

Fourteen-line header contributing a single widget-state enum to `RBX::Gui`: `WidgetState` describing mouse interaction phase for GUI widgets. No classes.

## Declared API

`namespace RBX { namespace Gui { enum WidgetState { NOTHING, HOVER, DOWN_OVER, DOWN_AWAY }; } }`

## Gotchas

- Enum values are unscoped in the Gui namespace — plain comparisons, no serialization implied here.
- DOWN_OVER vs DOWN_AWAY distinguishes press-inside from press-then-leave.

## Cross-links

- Kin GUI event plumbing: [GuiBase.md](GuiBase.md), [GuiObject.md](GuiObject.md).
