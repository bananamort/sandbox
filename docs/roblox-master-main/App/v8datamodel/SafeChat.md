# SafeChat.cpp

## Purpose

Implements `SafeChat`, a process-wide singleton that parses the canned-chat tree from `fonts/safechat.xml` (asset-file path via ContentProvider) and resolves numeric chat-menu codes ("sc", idx, idx, …) to utterance strings. Plain DOM-mirror data structure; no Instance, no reflection.

## Key types and API

- `SafeChat::singleton()`: boost::call_once scoped_ptr singleton.
- `loadChatTree()`: opens the XML with TextXmlParser, creates ROOT ChatOption, recursively `loadChildren(node, domSubTree)` mirroring `<utterance>` elements depth-first (values trimmed; RBXASSERT on malformed).
- `getMessage(vector<string> code)`: asserts code[0]=="sc"; walks children by atoi'd indices (atoi inside try/catch — note atoi doesn't throw, so the catch is dead code); out-of-range index returns ""; returns node text.
- `ChatOption`: {text, vector<ChatOption*> children}, recursive delete in dtor (Effective STL Item 7 idiom).

## Usage / reflection touchpoints

Consumed by legacy chat GUI (chat menu construction) — pairs with ChatService.md in this folder and [Network WebChatFilter](../../Network/) for the modern filtering counterpart.

## Gotchas

- The runtime_error catch around `atoi` can never fire (atoi returns 0 on garbage) — non-numeric codes silently become index 0.
- No cycle/depth protection on XML recursion — maliciously nested safechat.xml would recurse arbitrarily deep.
- Singleton is never reloaded: loadChatTree must be called explicitly (UNKNOWN caller timing header-side); getMessage before load RBXASSERTs on chatRoot null in debug, UB in release.
