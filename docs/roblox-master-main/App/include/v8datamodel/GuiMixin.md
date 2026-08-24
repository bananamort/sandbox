# App/include/v8datamodel/GuiMixin.h

## Purpose

`GuiImageMixin` — reusable state + getters for image-bearing GUI elements, plus the `DECLARE_GUI_IMAGE_MIXIN`/`IMPLEMENT_GUI_IMAGE_MIXIN` macro pair that stamps in Image property descriptors (Image, ImageRectOffset/Size, ImageTransparency, ImageColor3, SliceCenter, ScaleType), guarded setters, and stretched/sliced render paths.

## Declared API

`class GuiImageMixin`

- Ctor defaults: transparency 0, white color, `SCALE_STRETCH`, empty sliceCenter.
- Getters: `getImage() → TextureId`, `getImageRectOffset()/getImageRectSize() → Vector2`, `getImageTransparency() → float`, `getImageColor3() → Color3`, `getSliceCenter() → Rect2D`, `getImageScale() → GuiObject::ImageScale`.
- Protected state: `TextureId image; float imageTransparency; Color3 imageColor; Vector2 imageRectOffset, imageRectSize; GuiDrawImage guiImageDraw; Rect2D sliceCenter; GuiObject::ImageScale imageScale;`

Macro-declared per class (`DECLARE_GUI_IMAGE_MIXIN(Class)`): setters `setImage/setImageRectOffset/setImageRectSize/setImageTransparency/setImageColor3/setSliceCenter/setImageScale`, renderers `renderStretched/renderSliced/renderImage(Adorn*)`.

Macro-implemented behavior (`IMPLEMENT_GUI_IMAGE_MIXIN(Class)`):
- Registers descriptors: prop_Image, prop_ImageRectOffset/Size, prop_ImageTransparency, prop_ImageColor3, prop_SliceCenter, and EnumProp "ScaleType" (prop_ImageScale) — category_Image.
- All setters no-op on equal value and raise the matching property.
- setImageRectOffset warns (MESSAGE_WARNING) if sliceCenter+offset escapes the new image rect; setImageRectSize *rejects* the change (early return) when slice center falls outside the resized rect; setSliceCenter warns similarly against the current rect. Note asymmetry: offset/slice changes only warn, size change blocks.
- Transparency clamped to [0,1].
- renderStretched: sets texture, computes UV window from rect offset/size, renders with ancestor clipping or absolute rotation fallback.
- renderSliced: scale-9 via `render2dScale9Impl2`, honoring texture-offset sub-rect when non-empty.
- renderImage: dispatch on SCALE_STRETCH/SCALE_SLICED then `renderStudioSelectionBox(adorn)`.

## Gotchas

- The macro body is ~140 lines of code in a header — every includer pays parse cost; debug symbols duplicate per class.
- Setter validation is inconsistent across the three rect properties (see above) — order of assignment matters to avoid silent rejection.
- ScaleType enum lives on GuiObject but the descriptor name is "ScaleType" while C++ names it ImageScale.

## UNKNOWN

- Which classes instantiate the mixin (ImageButton/ImageLabel family — see [ImageButton.md](ImageButton.md)/[ImageLabel.md](ImageLabel.md)).

## Cross-links

- Kin mixin: [GuiText.md](GuiText.md); base [GuiObject.md](GuiObject.md).
