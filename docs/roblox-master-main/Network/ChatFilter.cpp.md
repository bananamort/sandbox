# Network/ChatFilter.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 32 lines)

## Purpose

Base chat-filter hook for server-side chat moderation. `ChatFilter::filterMessageBase` short-circuits "safe chat" messages (fixed-list chats sent as `/sc [0-9]+`) past filtering, invoking the caller's callback asynchronously on a Boost thread; all other messages return `false` so derived/class-level filters (e.g. `WebChatFilter`) run.

## API

```cpp
const char* const RBX::Network::sChatFilter = "ChatFilter";

bool ChatFilter::filterMessageBase(
    shared_ptr<Player> sourcePlayer,
    shared_ptr<Instance> receiver,
    const std::string& message,
    const ChatFilter::FilteredChatMessageCallback callback);
```

`Result` (with `whitelistFilteredMessage`, `blacklistFilteredMessage`) and `FilteredChatMessageCallback` are declared in `Network/include/network/ChatFilter.h` (header not in this root scope).

## Usage

- Called by the Players/chat pipeline before a chat message is broadcast; returning `true` means "already handled".
- Safe-chat detection: `boost::starts_with(message, "/sc ")`.

## Gotchas

- The callback is invoked on a freshly spawned `boost::thread` (`boost::thread t(boost::bind(callback, result))`) whose lifetime management depends on unvendored boost dtor semantics — callbacks must be thread-safe and outlive this stack frame. [UNSUPPORTED as stated: whether the thread is *detached* cannot be confirmed from this repo]
- Includes `"Util/http.h"` but makes no HTTP call itself in this file — UNKNOWN why the include is present (possibly legacy).
- Log group `WebChatFiltering` declared here, used by sibling `WebChatFilter.cpp`.
