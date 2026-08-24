# App/include/gui/ChatOutput.h

## Purpose

Declares the chat display layer: `ChatLine` (immutable per-message record with bubble color/type/lifetime), subclasses `PlayerChatLine`/`GameChatLine`, the per-character `CharacterChats` bubble queue, and `RBX::ChatOutput` — a GuiItem that listens to player/game chat messages, maintains a scrolling FIFO plus character-sorted chat bubbles rendered as billboard GUIs over heads.

## Declared API

- `class RBX::ChatLine`
  - Protected static: `static float ComputeBubbleLifetime(const std::string& msg, bool isSelf);`
  - Public statics: `static const char* ELIPSES;` `static const int CchMaxChatMessageLength;` ("max chat message length, including null terminator and elipses" [sic])
  - Enums: `BubbleColor { WHITE, BLUE, GREEN, RED }`; `ChatType { PLAYER_CHAT, PLAYER_TEAM_CHAT, PLAYER_WHISPER_CHAT, GAME_MESSAGE, PLAYER_GAME_CHAT, BOT_CHAT }`.
  - Members: `std::string message; const BubbleColor bubbleColor; const ChatType chatType; float startTime; float bubbleDieDelay; bool isLocalPlayer; boost::weak_ptr<Instance> origin;`
  - Inline `const Instance* getOrigin() const` (locks weak ptr); virtual dtor; ctor `(ChatType, const std::string& message, float startTime, BubbleColor, bool isLocalPlayer);`
  - Inline `bool isPlayerChat() const` — true for the three PLAYER_* chat types.
- `class RBX::PlayerChatLine : public ChatLine` — statics `ROBLOXNAME`; members `Color3 userColor; std::string user; float historyDieDelay;` methods `const ModelInstance* getCharacter() const;` ctor `(ChatType, shared_ptr<Player>, message, startTime, isLocalPlayer)`.
- `class RBX::GameChatLine : public ChatLine` — ctor `(shared_ptr<Instance> origin, message, startTime, isLocalPlayer, BubbleColor)`.
- `struct RBX::CharacterChats` — `std::deque<shared_ptr<ChatLine> > fifo; bool isVisible; bool isMoving; weak_ptr<BillboardGui> billboardGui;` default ctor sets visible/moving false.
- `class RBX::ChatOutput : public GuiItem`
  - Private constants: `kMaxTextSize = 16`, `kMaxCharsInLine = 20`, `MaxChatBubblesPerPlayer`, `MaxChatLinesPerBubble`.
  - Private helpers: `createBillboardGuiHelper(Instance*, bool character)`, `renderBubbleImposters(Adorn*, owner, head)`, `renderBubbles(Adorn*, owner, head, bool playerAndGameChat, Vector3 extentsOffset, Vector3 studsOffset)`, `acceleratedBubbleDecay(ChatLine*, wallStep, isMoving, isVisible)`, `removeOldest()`, `removeExpired()`, `bubbleChatEnabled()`, `std::string SanitizeChatLine(const std::string& msg)` ("truncate and make safe").
  - Nested `struct ScalingInfo { Vector2 scalingCutoff; UDim2 fixedPosition/fixedSize/scalingPosition/scalingSize; UDim2 getPosition(Vector2 size); UDim2 getSize(Vector2 size); ScalingInfo(...); ScalingInfo(); }` — inline position/size pickers switching on cutoff.
  - State: `RBX::Network::Players* players;` maps BubbleColor→GuiObject for `chatBubble`, `chatBubbleWithTail`, `scalingChatBubbleWithTail`, `chatPlaceholder`, plus `std::map<BubbleColor, ScalingInfo> scalingInfo;` `std::deque<shared_ptr<ChatLine>> fifo;` `CharacterChatMap characterSortedMsg;` (`typedef std::map<const Instance*, CharacterChats>`), `float time;`
  - Connections: heartbeat, playerChatMessage, gameChatMessage; handlers `onHeartbeat(const Heartbeat&)`, `onPlayerChatMessage(const Network::ChatMessage&)`, `onGameChatMessage(shared_ptr<Instance> origin, message, ChatService::ChatColor color)`.
  - Overrides: `onServiceProvider(...)`, `render2d(Adorn*)`, `render2d_bubbleStyle(Adorn*, bool playerBubbleChat)`.
  - Public: `ChatOutput(); ~ChatOutput();`

## Usage notes

- Depends on V8DataModel/ChatService.h for message events and Util/UDim.h for scaling math.
- Sibling docs: [GUI.md](GUI.md), [ChatWidget.md](ChatWidget.md), [SafeChat via v8datamodel](../../v8datamodel/) (SafeChat class forward-declared here).

## Gotchas

- `getOrigin()` locks the weak pointer then immediately `.get()`s it — raw pointer valid only momentarily.
- ChatLine's color/type are const: messages are immutable once queued; edits happen by replacing lines.
- Bubble lifetime scales with message length and self-vs-other (`ComputeBubbleLifetime`) — accelerated decay applies when characters move or hide.
- Forward declares Network::ChatMessage inside namespace Network but the handler signature uses ChatService::ChatColor — two parallel color vocabularies mapped in the .cpp.
