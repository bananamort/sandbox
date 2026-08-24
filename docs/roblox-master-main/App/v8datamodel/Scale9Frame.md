# Scale9Frame.cpp

## Purpose

Implements `Scale9Frame` ("Scale9Frame"), a DescribedNonCreatable GuiObject that renders a 9-slice image chosen by prefix (`SlicePrefix` + ".SlicePrefix" suffix convention), sized by `ScaleEdgeSize`. Legacy predecessor of the modern ImageLabel slice properties (see PlayerGui.md's default selection image using SCALE_SLICED).

## Key types and API

Descriptors (category_Data, no security tier ⇒ default):
- `prop_scaleEdgeSize("ScaleEdgeSize")` — Vector2int16, default (0,0); setter raises change + `checkForResize()` (base-class layout hook).
- `prop_slicePrefix("SlicePrefix")` — string; setter raises change only.

Rendering:
- `render2d(Adorn*)`: `image.setImage(adorn, slicePrefix, GuiDrawImage::NORMAL, &imageSize, this, ".SlicePrefix")` — on success builds Rect2D from scaleEdgeSize corner to imageSize−scaleEdgeSize and calls `render2dScale9Impl2(adorn, slicePrefix, image, rect, NULL, color)` with white color modulated by `1 − BackgroundTransparency`.
- Failed image resolution renders NOTHING (silent).

## Usage / reflection touchpoints

Non-creatable from scripts; appears when legacy places deserialize it. Pairs with GuiObject.md family docs in this folder.

## Gotchas

- Slice lookup appends ".SlicePrefix" to the property value — asset naming is convention-coupled.
- No fallback rendering when the sliced image fails to load; frame becomes invisible.
- checkForResize fires on edge-size change but NOT on slice-prefix change.
- UNKNOWN: render2dScaleImpl2 signature details and image cache behavior live in GuiBase/Adorn headers.
