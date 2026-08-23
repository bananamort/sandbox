# App/include/gui/EquationDisplay.h

## Purpose

Declares `RBX::EquationDisplay`, a `TextDisplay` subclass that renders an equation string as its label (label derived from the stored equation unless explicitly provided).

## Declared API

- `class EquationDisplay : TextDisplay`
  - Ctors: `(title, equation)` and `(title, label, equation)`.
  - Protected override `std::string getLabel() const` (supplies the equation-based label).
  - Override `void render2d(Adorn*)`.
  - Private member `std::string equation`.

## Usage notes

- Debug/HUD text widget family (Gui/GUI.h); construction immediately fixes the displayed text — no setter for the equation is exposed here.

## Gotchas

- Header-only knowledge: behavior of getLabel vs. explicit label interplay lives in the .cpp.
