# Network/WebChatFilter.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 173 lines)

## Purpose

Implements the server-side web chat moderation call: `WebChatFilter::filterMessage` spawns a worker thread (`"rbx_webChatFilterHttpPost"`) that POSTs the chat text to the ComSift moderation endpoint and parses the JSON response into `ChatFilter::Result {whitelistFilteredMessage, blacklistFilteredMessage}`, then invokes the callback supplied by `Players::OnReceiveChat`.

## API

### HTTP endpoints

| Endpoint | Method | Calling symbol |
|---|---|---|
| `GetWebChatFilterURL(GetBaseURL())` (ComSift text moderation; exact host from RobloxServicesTools) | POST `application/x-www-form-urlencoded`, timeout `DFInt::WebChatFilterHttpTimeoutSeconds`(60)×1000 | `filterMessageHelper` (line ~104–110) |

Request: legacy form `filters=<white>&filters=<black>&text=<urlencoded>` or under `DFFlag::UseComSiftUpdatedWebChatFilterParamsAndHeader`: body from `ConstructModerationFilterTextParamsAndHeaders` (`text`, optional legacy `filters` pair under second flag, `userId`) plus headers `placeId`, `gameInstanceID`. Response JSON: `{"data": {"<whitePolicy>": "...", "<blackPolicy>": "..."}}`.

## Usage

Created on demand by Players via `ServiceProvider::create<WebChatFilter>` during chat receive; failures log GA `"ChatFailure"` and leave the callback uninvoked (message silently dropped).

## Gotchas

- The HTTP call is synchronous but off-thread; there is no retry — one timeout kills the message.
- `filterMessageBase` (header-declared hook) short-circuits for special cases before the thread spawn.
- Response asserts (`RBXASSERT`) on missing members — malformed 200-responses would only fail in debug.
