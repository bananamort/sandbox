# App/include/gui/GuiEvent.h

## Purpose

Declares `RBX::GuiResponse`, the value returned by every GUI input-processing function (`GuiItem::process` and friends). Encodes three orthogonal facts — whether the event was sunk (consumed), whether processing finished, and whether the mouse was previously over the widget — plus an optional weak target Instance (the widget that consumed the event) tracked with a `LOGGROUP(GuiTargetLifetime)` for diagnostics.

## Declared API

- `class GuiResponse`
  - Default ctor = notSunk/notFinished/notMouseOver; private ctors for internal factories.
  - Predicates/mutators: `bool wasSunk()`, `bool wasSunkAndFinished()` (asserts finished ⇒ sunk), `getMouseWasOver()`, `setMouseWasOver()`.
  - Static factories: `notSunk()`, `notSunkMouseWasOver()`, `sunk()`, `sunkAndFinished()`, `sunkWithTarget(Instance*)`.
  - Target: `shared_ptr<Instance> getTarget()` (weak lock), `void setTarget(Instance*)` (weak_from).

## Usage notes

- Widgets return `sunkAndFinished()` when they fully consume an event so parents stop propagation; `sunkWithTarget` records who owns a drag/click for later routing.

## Gotchas

- Target is stored as `weak_ptr` — it can expire between sink and retrieval (`getTarget` returns NULL then); the log group exists to chase such lifetime bugs.
