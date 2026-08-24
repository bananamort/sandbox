# ImageLabel.cpp

## Purpose

Implements `ImageLabel` ("ImageLabel") — a GuiLabel that renders only its mixin image; background rect drawn separately (renderBackground2d) ONLY when BackgroundTransparency < 1. Mixin expanded via IMPLEMENT_GUI_IMAGE_MIXIN.

## Key types and API

Descriptors: none in TU — all via GuiImageMixin/[GuiObject](GuiObject.md). Constants: `sImageLabel = "ImageLabel"`.

Behavior:
- render2d → renderImage(adorn) only.
- renderBackground2d — conditional plain-color rect using getRenderBackgroundColor4.

## Usage / reflection touchpoints

Sibling of [ImageButton](ImageButton.md) (same mixin); 9-slice alternative via [GuiObject](GuiObject.md) ScaleType Slice.

## Gotchas

- BackgroundTransparency == 1 skips the background pass entirely — exactly-1 vs 0.999 behaves differently for hit-testing visuals.
