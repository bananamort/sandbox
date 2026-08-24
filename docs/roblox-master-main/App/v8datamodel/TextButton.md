# TextButton.cpp

## Purpose

Implements `GuiTextButton` ("TextButton"), the clickable text GuiObject: GuiButton behavior + GuiTextMixin rendering with ContentFilter gating; also constructible engine-side bound to a Verb.

## Key types and API

- Ctor: mixin named "Button" with brickBlack text color. Verb ctor variant stores `verb` for Studio UI buttons.
- IMPLEMENT_GUI_TEXT_MIXIN expansion supplies Text/Font/FontSize/TextWrapped/etc.
- `render2dContext`: render2dButtonImpl (button chrome into rect) → ContentFilter state resolution (own provider, then context provider) → on Succeeded render2dTextImpl with getText/getFont/getFontSize/render colors + wrap/scale/alignment → renderStudioSelectionBox.

## Usage / reflection touchpoints

Standard script-facing button. Pairs with TextLabel.md, GuiButton docs in this folder family.

## Gotchas

- Unlike TextLabel.md there is no transparency-fix background path here — invisible-text buttons lose their label only (chrome still draws).
- Filter-failed text silently skips the label draw.
