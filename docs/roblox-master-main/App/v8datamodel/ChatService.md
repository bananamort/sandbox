# ChatService.cpp

## Purpose

Implements `ChatService` (registered name "Chat", class ChatService) — server chat plumbing: a validated `Chat` broadcast (part-or-character + message + color) and `FilterStringForPlayerAsync`, which POSTs text to the web moderation endpoint and picks the whitelist/blacklist policy result per target player's filter type.

## Key types and API

Descriptors:
- `func_chat("Chat", "partOrCharacter","message","color"[CHAT_BLUE], Security::None)` — BoundFunc.
- `func_filterString("FilterStringForPlayerAsync", "stringToFilter","playerToFilterFor", Security::None)` — BoundYieldFunc returning string.
- `event_Chatted("Chatted", "part","message","color", Security::None, SCRIPTING, BROADCAST)`.

Enum "ChatColor": Blue, Green, Red (+ Variant/StringConverter plumbing). Flag consumed: `DYNAMIC_FASTFLAG(UseComSiftUpdatedWebChatFilterParamsAndHeader)`. Constant: `sChatService = "Chat"`.

Behavior:
- `chat()` — throws unless instance non-nil, in Workspace, either PartInstance or ModelInstance that resolves to a real player character ("partOrCharacter is not a legal character"), message non-empty; then fireAndReplicate Chatted.
- `filterStringForPlayer()` — GA stat once per process; rejects non-server ("only works from server") and non-Player targets. Params: legacy path sends `filters=white&filters=black&text=<urlencoded>`; ComSift flag path builds params+headers via `Network::ConstructModerationFilterTextParamsAndHeaders` (userId/placeId/gameInstanceId) and uses `postAsyncWithAdditionalHeaders("moderation/filtertext", …APPLICATION_URLENCODED…)` via [HttpRbxApiService](HttpRbxApiService.md).
- `gotFilteredStringSuccess` — parses JSON {data:{whiteListPolicy, blackListPolicy}}; returns the string matching `player->getChatFilterType()` (CHAT_FILTER_WHITELIST or blacklist); parse failure/empty → GA track + errorFunction.

## Usage / reflection touchpoints

Chatted is the transport consumed by legacy chat UIs ([SafeChat](SafeChat.md), CoreScripts under [App/script](../../script/)); filtering rides web moderation like [AssetService](AssetService.md)/[BadgeService](BadgeService.md) HTTP flows.

## Gotchas

- Chat() performs NO filtering itself — whatever passes validation is broadcast verbatim to everyone; filtering is a separate explicit Async call.
- ChatColor enum has only 3 values; modern color sets live in the Lua chat modules.
- Whitelist/blacklist choice is per-PLAYER account setting (`getChatFilterType`), not per-message.
