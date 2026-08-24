# TextLabel.cpp

## Purpose

Implements `TextLabel` ("TextLabel"), the static text GuiObject: GuiTextMixin-backed text properties, ContentFilter-gated rendering, and a transparency-fix flag path that still draws the background when text alpha hits zero.

## Key types and API

DFFlag declared: TextTransparencyRenderingFix(false).

Rendering (`render2dContext`):
- Resolves ContentFilter string state first against own provider then the render context; only Succeeded state draws.
- When `getRenderTextAlpha(getTextTransparency()) > 0`: full render2dTextImpl (background + text + stroke + wrap/scale/alignment).
- Else when DFFlag on: `render2dImpl(adorn, getRenderBackgroundColor4())` — background-only draw so fully-transparent text no longer erases the label's background.
- Always ends with renderStudioSelectionBox.

Ctor: mixin named "Label", black text, GUIQUEUE_TEXT queue.

## Usage / reflection touchpoints

Standard script-facing GuiObject. Pairs with TextButton.md (same mixin), TextBox.md, CoreGuiService.md on-screen messages in this folder.

## Gotchas

- Without the flag, fully transparent text suppresses the background too — pre-fix visual quirk preserved by default.
- Filter-unsucceeded text renders NOTHING silently (no placeholder).
