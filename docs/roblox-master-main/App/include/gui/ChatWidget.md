# App/include/gui/ChatWidget.h

## Purpose

Declares unified-input chat UI widgets: `UnifiedImageWidget` (a `UnifiedWidget` that draws a `GuiDrawImage` with named image + state), `ChatButton` (image widget with custom visibility), and `ChatWidget` (text/code-driven widget handling menu-state changes and input processing for chat entry).

## Declared API

- `class UnifiedImageWidget : UnifiedWidget`
  - Protected members: `GuiDrawImage guiImageDraw`, `std::string imageName`, `unsigned imageState`.
  - Ctor `(imageName, imageState)`; `Gui::WidgetState getWidgetState() const`; overrides `render2dMe(Adorn*)`, `setSize(Vector2)` → `setImageSize`, `Vector2 getSize(Canvas)`.
- `class ChatButton : UnifiedImageWidget` — same ctor; private override `isVisible()`.
- `class ChatWidget : UnifiedWidget`
  - Ctor `(const std::string& text, std::string code)`; stores `code`.
  - Private: `findMenuString(GuiItem*)`; overrides `onMenuStateChanged()`, `GuiResponse process(const shared_ptr<InputObject>& event)`.

## Usage notes

- Part of the "unified" widget set that renders both to 2D GUI and 3D adorn layers (see Gui/GuiDraw.h); images referenced by name/state resolve through the standard image pipeline.

## Gotchas

- All real behavior (visibility logic, input handling, image loading) lives in the .cpp; the header exposes only ctor signatures.
- `ChatWidget::process` returns `GuiResponse` — input not consumed falls through to other widgets.
