# App/include/v8datamodel/TextLabel.h

## Purpose

`TextLabel` — creatable `GuiLabel` + GuiTextMixin: static text display with the mixin's text property surface; only custom behavior is its two render paths.

## Declared API

`class TextLabel : public DescribedCreatable<TextLabel, GuiLabel, sTextLabel>, public GuiTextMixin`

- Ctor `TextLabel()`.
- `DECLARE_GUI_TEXT_MIXIN();` — text properties (Text/Font/TextSize/etc.) via macro.
- Private IAdornable overrides: `render2d(Adorn*)`, `render2dContext(Adorn*, const Instance*)`.

## Gotchas

- No state of its own beyond the mixin — everything else inherited from GuiLabel/GuiObject.

## UNKNOWN

- (none — trivial composition)

## Cross-links

- Implementation: [App/v8datamodel/TextLabel.md](../../v8datamodel/TextLabel.md).
- Base: [GuiObject.md](GuiObject.md); mixin: [GuiText.md](GuiText.md); siblings: [TextButton.md](TextButton.md), [TextBox.md](TextBox.md).
