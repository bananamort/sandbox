# App/include/v8datamodel/SafeChat.h

## Purpose

`SafeChat` — plain singleton (NOT an Instance despite the includes) holding the safe-chat option tree: loads a ChatOption hierarchy (from XML, per loadChildren) and decodes message codes chosen by the UI back into chat strings. `ChatOption` is a trivial tree node.

## Declared API

- `class SafeChat`
  - Inline ctor calls `loadChatTree()`.
  - `static SafeChat& singleton()`.
  - `ChatOption* getChatRoot()` inline over `boost::scoped_ptr<ChatOption> chatRoot`.
  - `std::string getMessage(std::vector<std::string> code)` — maps a path of option codes to the final message.
  - Private: `loadChatTree()`, `loadChildren(ChatOption* node, const XmlElement* DOMsubTree)`.
- `class ChatOption`
  - Public data: `std::vector<ChatOption*> children; std::string text;`
  - `ChatOption()`, `~ChatOption()` (owns children), `ChatOption(std::string text)`.
  - Forward-declared in header (`class ChatOption;`), defined below.

## Gotchas

- Not a reflection class: `sSafeChat` extern is commented out and there is no Described base — pure C++ service object.
- Children are raw owning pointers (`vector<ChatOption*>`, dtor deletes) — manual ownership, no copying safety.
- getMessage takes codes by value (vector copy per call).

## UNKNOWN

- Where the chat-tree XML is loaded from (resource path, out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/SafeChat.md](../../v8datamodel/SafeChat.md).
- Chat surface: [ChatService.md](ChatService.md); DataModel context: [DataModel.md](DataModel.md).
