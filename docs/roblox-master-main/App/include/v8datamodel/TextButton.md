# App/include/v8datamodel/TextButton.h

## Purpose

`GuiTextButton` — creatable `GuiButton` + GuiTextMixin: a clickable button that draws its own text (Text/Font/TextColor3 etc. via the mixin); also has a Verb-taking ctor for accelerator-bound buttons.

## Declared API

`class GuiTextButton : public DescribedCreatable<GuiTextButton, GuiButton, sGuiTextButton>, public GuiTextMixin`

- Ctors: `GuiTextButton()` and `GuiTextButton(Verb* v)`.
- `DECLARE_GUI_TEXT_MIXIN();` — pulls in the standard text property surface.
- Private IAdornable overrides: `render2d(Adorn*)`, `render2dContext(Adorn*, const Instance* context)`.

## Gotchas

- All text properties come from the mixin macro — no text members declared here.
- Button click semantics inherited from [GuiObject.md](GuiObject.md)/GuiButton (not in this header's includes).

## UNKNOWN

- What the Verb* ctor wires (presumably doIt on activation; out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/TextButton.md](../../v8datamodel/TextButton.md).
- Base: [GuiObject.md](GuiObject.md); mixin: [GuiText.md](GuiText.md); sibling: [ImageButton.md](ImageButton.md), [TextLabel.md](TextLabel.md).
