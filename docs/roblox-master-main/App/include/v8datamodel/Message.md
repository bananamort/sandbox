# App/include/v8datamodel/Message.h

## Purpose

Legacy full-screen text overlay: `Message` Instance renders its filtered text as a 2D overlay; `Hint` subclass renders differently (top-of-screen hint) and is client-creatable.

## Declared API

`class Message : public DescribedCreatable<Message, Instance, sMessage>, public IAdornable`

- Text: `const std::string& getText() const; void setText(const std::string& value);` protected member + `ContentFilter::FilterResult filterState`.
- Rendering: `shouldRender2d() → true`, `render2d(Adorn*)`, protected `renderFullScreen(Adorn*)`.
- Tree: askSetParent → true (anywhere).
- `getPersistentDataCost()` += string cost of text.

`class Hint : public DescribedCreatable<Hint, Message, sHint>`

- Overrides render2d; `bool canClientCreate() { return true; }`.

## Gotchas

- Filter state mirrors [GuiText](GuiText.md) patterns — text display depends on async filtering.
- Message/Hint are the deprecated era's notification UI (CoreScripts replaced them later).

## UNKNOWN

- Where filtered results re-trigger rendering (.cpp — see [Message.md](../../v8datamodel/Message.md)).

## Cross-links

- Implementation: [App/v8datamodel/Message.md](../../v8datamodel/Message.md).
- Kin: [GuiObject.md](GuiObject.md) family for modern text UI.
