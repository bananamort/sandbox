# App/include/v8datamodel/ChatService.h

## Purpose

`ChatService` (INTERNAL service) — legacy chat plumbing: broadcast a `chatted` remote signal (speaker, message, color) and server-side string filtering per player via async web callback.

## Declared API

`class ChatService : public DescribedCreatable<ChatService, Instance, sChatService, ClassDescriptor::INTERNAL>, public Service`

- `enum ChatColor { CHAT_BLUE, CHAT_GREEN, CHAT_RED };`
- `void chat(shared_ptr<Instance> instance, std::string message, ChatService::ChatColor chatColor);`
- `void filterStringForPlayer(std::string stringToFilter, shared_ptr<Instance> playerToFilterFor, function<void(std::string)> resumeFunction, function<void(std::string)> errorFunction);`
- Remote signal: `rbx::remote_signal<void(shared_ptr<Instance>, std::string, ChatService::ChatColor)> chattedSignal;`
- Private filter plumbing: `gotFilteredStringSuccess(std::string response, Network::Player* player, resume, error)`; `gotFilterStringError(std::string error, error)`.

## Gotchas

- Only three fixed colors — no arbitrary Color3 chat in this path.
- Filtering is player-scoped and asynchronous: callers must not assume the filtered text arrives synchronously.
- INTERNAL descriptor: engine/legacy CoreScript usage, not general script API.

## UNKNOWN

- Endpoint URL and failure fallback of filtering (.cpp — see [ChatService.md](../../v8datamodel/ChatService.md)).

## Cross-links

- Implementation: [App/v8datamodel/ChatService.md](../../v8datamodel/ChatService.md).
- Related services: [TextService.md](TextService.md) (modern filtering), [Players-side Network docs](../../Network/INDEX-Network.md).
