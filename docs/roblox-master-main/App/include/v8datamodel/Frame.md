# App/include/v8datamodel/Frame.h

## Purpose

`Frame` Instance — the basic rectangular GUI container ([GuiObject](GuiObject.md) child) with a `Style` enum selecting preset skins (chat boxes, ROBLOX square/round, drop shadow) or custom drawing.

## Declared API

`class Frame : public DescribedCreatable<Frame, GuiObject, sFrame>`

- `enum Style { CUSTOM_STYLE=0, BLUE_CHAT_STYLE=1, ROBLOX_SQUARE_STYLE=2, ROBLOX_ROUND_STYLE=3, GREEN_CHAT_STYLE=4, RED_CHAT_STYLE=5, ROBLOX_DROPSHADOW_STYLE=6 };`
- `Style getStyle() const { return style; } void setStyle(Style style);`
- Overrides: IAdornable `void render2d(Adorn* adorn);` GuiBase2d `Rect2D getChildRect2D() const;`
- Private: `Style style; GuiDrawImage image;`

## Gotchas

- Style values are serialized — append-only.
- Non-custom styles are baked skin presets; per-frame custom drawing only under CUSTOM_STYLE.

## UNKNOWN

- What getChildRect2D measures exactly (padding rules in .cpp — see [Frame.md](../../v8datamodel/Frame.md)).

## Cross-links

- Implementation: [App/v8datamodel/Frame.md](../../v8datamodel/Frame.md).
- Base: [GuiObject.md](GuiObject.md); GUI family: [TextLabel.md](TextLabel.md), [ImageButton.md](ImageButton.md), [ScrollingFrame.md](ScrollingFrame.md).
