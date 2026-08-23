# App/include/gui/Layout.h

## Purpose

Declares `RBX::Layout`, a plain data struct describing how a group of GUI elements is arranged: anchor locations on X/Y, pixel offset, horizontal-or-vertical flow style, and an optional backdrop color.

## Declared API

- `class RBX::Layout` (aggregate, all members public)
  - `enum Style { HORIZONTAL = 0, VERTICAL = 1 };`
  - Members: `Rect::Location xLocation; Rect::Location yLocation; Vector2int16 offset; Style layoutStyle; Color4 backdropColor;`
  - Inline default ctor: xLocation=LEFT, yLocation=TOP, offset=(0,0), layoutStyle=HORIZONTAL, backdropColor=Color4::clear().

## Usage notes

- Depends on `Util/Rect.h` (Rect::Location enum) and `Util/G3DCore.h` (Vector2int16, Color4).

## Gotchas

- No behavior at all — consumers interpret the fields; defaults mean "stack horizontally from top-left with transparent backdrop".
