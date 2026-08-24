# App/include/v8datamodel/Scale9Frame.h

## Purpose

`Scale9Frame` — non-creatable `GuiObject` implementing 9-slice rendering: a slice-prefix texture family plus `scaleEdgeSize` corners, drawn via IAdornable render2d. Precursor/peer of modern 9-slice ImageRect handling on frames.

## Declared API

`class Scale9Frame : public DescribedNonCreatable<Scale9Frame, GuiObject, sScale9Frame>`

- Private state: `Vector2int16 scaleEdgeSize`, `std::string slicePrefix`, `GuiDrawImage image`.
- Ctor; inline getters/setters: `getSlicePrefix()/setSlicePrefix(std::string)`, `getScaleEdgeSize()/setScaleEdgeSize(Vector2int16)` (setters out-of-line).
- IAdornable: `/*override*/ void render2d(Adorn* adorn)`.

## Gotchas

- Non-creatable: legacy/internal GUI element — user code gets Frame/ImageLabel instead.
- Slice naming via prefix string implies a fixed suffix convention for the 9 pieces (out-of-line in render2d).

## UNKNOWN

- The exact slice filename convention used by setSlicePrefix.

## Cross-links

- Implementation: [App/v8datamodel/Scale9Frame.md](../../v8datamodel/Scale9Frame.md).
- Base: [GuiObject.md](GuiObject.md), [Frame.md](Frame.md); drawing: Gui/GuiDraw layer.
