# App/include/gui/Widget.h

## Purpose

Declares `RBX::Widget`, the standard interactive GuiItem base: routes input events through `process` into mouse/key handlers, tracks a `Gui::WidgetState`, resets state on focus loss, and exposes the small virtual surface (onClick, font size/color, isEnabled, render2d) subclasses override to build new widgets.

## Declared API

- `class RBX::Widget : public GuiItem`
  - Private: typedef Super = GuiItem; `GuiResponse processMouse(const shared_ptr<InputObject>& event);` `GuiResponse processKey(const shared_ptr<InputObject>& event);`
  - Protected:
    - `Gui::WidgetState widgetState;`
    - override `GuiResponse process(const shared_ptr<InputObject>& event);` — "This should be standard for all widgets, verb widgets, etc."
    - inline override `void onLoseFocus()` → sets `widgetState = Gui::NOTHING;` then `Super::onLoseFocus();`
    - Extension points ("Override these to make new widgets"): override `void render2d(Adorn* adorn);` and virtuals with defaults — `virtual void onClick(const shared_ptr<InputObject>&) {}`, `virtual int getFontSize() const {return 10;}`, `virtual G3D::Color4 getFontColor() {return G3D::Color3::white();}`, `virtual bool isEnabled() {return isVisible();}`
  - Public: `Widget();`

## Usage notes

- Pulls in GUI.h (base), Verb.h, GuiCore.h, InputObject.h.
- Sibling widget docs: [GUI.md](GUI.md), [ChatWidget.md](ChatWidget.md).

## Gotchas

- `processMouse`/`processKey` are private non-virtual dispatch helpers — subclass behavior hooks are the protected virtuals, not these.
- Default `getFontColor` returns Color3::white() implicitly widened to Color4 (alpha defaults to opaque via conversion).
