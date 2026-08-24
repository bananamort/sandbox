# App/include/v8datamodel/ImageLabel.h

## Purpose

`GuiLabel` + [GuiImageMixin](GuiMixin.md) creatable ("ImageLabel"): a non-interactive image element; render splits background vs image passes.

## Declared API

`class ImageLabel : public DescribedCreatable<ImageLabel, GuiLabel, sImageLabel>, public GuiImageMixin`

- `ImageLabel();`
- `DECLARE_GUI_IMAGE_MIXIN(ImageLabel);`
- Overrides: `render2d(Adorn*)`, `renderBackground2d(Adorn*)` (protected).

## Gotchas

- Inherits GuiLabel's isGuiLeaf → true: no GUI children.
- All image properties come from the mixin macro (see [GuiMixin.md](GuiMixin.md) for setter validation asymmetries).

## Cross-links

- Implementation: [App/v8datamodel/ImageLabel.md](../../v8datamodel/ImageLabel.md).
- Kin: [ImageButton.md](ImageButton.md), base [GuiObject.md](GuiObject.md).
