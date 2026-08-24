# Frame.cpp

## Purpose

Implements `Frame` ("Frame") — the rectangular GuiObject container with a Style enum: Custom (plain background path) plus six skinned 9-slice presets (ChatBlue/Green/Red, RobloxSquare/Round, DropShadow) that override rendering with hardcoded rbxasset textures and forced background transparency.

## Key types and API

Descriptors:
- `prop_style("Style", category_Data)` — enum registered as "FrameStyle": Custom, ChatBlue, RobloxSquare, RobloxRound, ChatGreen, ChatRed, DropShadow. No Security:: arguments.

Constants: `sFrame = "Frame"`; ctor `DescribedCreatable<Frame, GuiObject, sFrame>("Frame", false)`.

Behavior:
- `getChildRect2D` — Custom → plain rect; chat styles → Scale9Rect2D(17,60) borders; Roblox styles → Scale9Rect2D(8,21).
- `setStyle` — raise + `forceResize()`.
- `render2d` — Custom defers to GuiObject; chat skins render `dialog_{color}.png` 9-slice with white tint over (7,7)-(33,33) source rect; square/round use blackBkg textures (7,7 corner, 14,14 center); DropShadow uses newBkg_square (10,10 / 40,40); square/round/dropshadow FORCE `setBackgroundTransparency(0.0f)` on every render; all paths honor first ancestor clipping + studio selection box.
- Static TextureIds resolved once per process.

## Usage / reflection touchpoints

Base container of the modern GUI tree under [GuiObject](GuiObject.md)/[ScreenGui](ScreenGui.md); 9-slice machinery shared with [Scale9Frame](Scale9Frame.md).

## Gotchas

- Non-Custom styles OVERWRITE BackgroundTransparency to 0 every frame — scripts setting transparency while a skin is active are silently reverted.
- Style changes trigger forceResize, which re-runs descendant layout.
- The skin textures are engine-embedded rbxasset paths — no way to substitute custom art through this class.
