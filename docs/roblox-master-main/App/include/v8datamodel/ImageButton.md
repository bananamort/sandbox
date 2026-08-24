# App/include/v8datamodel/ImageButton.h

## Purpose

`GuiButton` + [GuiImageMixin](GuiMixin.md) creatable ("ImageButton" descriptor sGuiImageButton): an image-skinned button with a selectable image state (normal/hover/down handled via render2d).

## Declared API

`class GuiImageButton : public DescribedCreatable<GuiImageButton, GuiButton, sGuiImageButton>, public GuiImageMixin`

- Ctors: `GuiImageButton(); GuiImageButton(Verb* verb);` (verb-linked variant for HUD buttons).
- `DECLARE_GUI_IMAGE_MIXIN(GuiImageButton)` — stamps Image property surface + renderers.
- `void setImageState(unsigned imageState)` — plain setter, no change signal.
- Override: `render2d(Adorn*)`; protected member `unsigned imageState;`

## Gotchas

- imageState is a free-form unsigned — the mapping to button states is internal (.cpp render2d).
- Verb ctor ties clicks to Studio verbs.

## UNKNOWN

- Number/meaning of valid imageState values (.cpp).

## Cross-links

- Kin: [ImageLabel.md](ImageLabel.md); base [GuiObject.md](GuiObject.md) (GuiButton section).
