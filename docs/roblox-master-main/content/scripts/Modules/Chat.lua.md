# Chat.lua

Source: `roblox-sandbox/content/scripts/Modules/Chat.lua` (2654 lines; `RobloxGui.Modules.Chat`)

## Purpose

The Lua-side classic chat window of this CoreScript generation: a bottom-anchored scrolling message history plus a chat bar with All/Team/Whisper modes and slash commands. Replaces the engine-drawn chat when loaded; also wires block/mute/unblock commands to PlayerDropDown's blocking utility and publishes the developer-facing SetCore chat API (`ChatMakeSystemMessage`, `ChatWindowPosition`, `ChatWindowSize`, `ChatBarDisabled`). Header comment documents how game owners can copy it into a normal Module + LocalScript setup ("NON_CORESCRIPT_MODE").

## API (returned module table)

Built once at require time (`CreateChat():Initialize()` runs immediately) and returns:
- `moduleApiTable:ToggleVisibility()` / `:FocusChatBar()` / `:GetVisibility()` / `:GetMessageCount()` / `:TopbarEnabledChanged(enabled)`.
- Signals: `ChatBarFocusChanged` (bool), `VisibilityStateChanged` (bool), `MessagesChanged` (message count; nil until the window exists).

Internal widget layer (not exported but defines behavior):
- **Util** table — IsTouchDevice/IsSmallScreenSize, `Create` builder, easing fns (Linear/EaseOutQuad/EaseInOutQuad), PropertyTweener (RenderStepped tween with Cancel), BindableEvent-backed Signal, SetGUIInsetBounds (SetGlobalGuiInset w/ legacy fallback), GetPlayerByName, memoized GetStringTextBounds via an invisible TextLabel parented to RobloxGui, ComputeChatColor (character-sum name hash → one of 8 CHAT_COLORS), IsPlayerAdminAsync (cached IsInGroup(1200769) check), FilterUnprintableCharacters.
- **CreateChatBarWidget** — TextBox chat bar; regex table matches slash commands `/w name`, `/whisper name`, `%`, `(TEAM)`, `/t(eam)`, `/a(ll)`, `/s(ay)`, `/e(mote)`, `/?(help)`, `/block|/unblock|/mute|/unmute name`; fires `ChatCommandEvent(success, actionType, capture)`, `ChatErrorEvent(msg)` ("You're not on a team.", self-whisper/invalid-target errors), `ChatBarFloodEvent`; sends through pcall'd `PlayersService:Chat/TeamChat/WhisperChat`; FloodCheck = >7 messages in 15 s; double-backspace exits a chat mode; Escape clears text.
- **CreateChatWindowWidget** — ScrollingFrame history capped at 50 messages (`MaxWindowChatMessages`), bottom-up message stacking trickery, PageUp/PageDown/Home/End paging while visible, hover/click fade logic with 30-second message fade-out (`MESSAGES_FADE_OUT_TIME`), unread-message tracking, `AddSystemChatMessage`, `AddDeveloperSystemChatMessage{Text,Color,Font,FontSize}`, UDim-offset rebase when canvas approaches the 16-bit limit (2^15−1).
- **CreateChat** orchestrator — default Settings (SourceSansBold, Size18/Size14 small-screen, colors incl. gold AdminTextColor); message rendering (whisper "To "/"From " prefixes, [Team] tag, per-player name color or TeamColor, '[Content Deleted]' moderation substitution, clickable usernames → whisper target selection, right-click → PlayerDropDown popup); `CoreGuiChanged` handles the '/' ChatHotkey special key and mobile chat button; filters blocked/muted senders and stats-toggle debug strings before display.

## Usage

- Loaded by `StarterScript.lua` (`spawn(function() require(RobloxGui.Modules.Chat) end)`).
- Consumed by `Topbar.lua` (toggle on chat icon click; drives visibility with topbar state via `TopbarEnabledChanged`), `SettingsHub.lua` and `GamepadMenu.lua` (chat toggling).
- In core-script mode it parents everything under `CoreGui.RobloxGui` and requires `RobloxGui.Modules.PlayerDropDown` for the popup/blocking utility. Developers integrate through `StarterGui:SetCore("ChatMakeSystemMessage", {...})` etc., registered here via `RegisterSetCore/RegisterGetCore`.

## Gotchas

- Real crash bug in `createPopupFrame` (~line 513–525): `PopupFrame` is declared `local` inside the `if IsPlayerDropDownEnabled then` block, but the following `for _, button in pairs(PopupFrame:GetChildren())` loop sits outside it and reads an undefined *global* — every right-click username popup errors with "attempt to index global 'PopupFrame' (a nil value)" after the popup is created.
- `Util.FilterUnprintableCharacters` computes two gsub results but returns the second computed from the original `str`, discarding the first replacement (unprintable-char stripping effectively lost).
- FloodCheck and unprintable filtering are both gated behind the `LuaChatFiltering` FastFlag — when off there is no flood protection at all.
- Whisper-name capture pattern `(%w+_?%w+)` accepts at most one underscore and no other punctuation; multi-underscore names won't match `/w`.
- The TextBounds cache in `GetStringTextBounds` grows without bound (keyed text→font→sizeBounds→fontSize) and its probe TextLabel stays parented to RobloxGui forever.
- `BlockPlayerAsync` reads `.userId` while `MutePlayer` reads `.UserId` on the same objects — inconsistent casing that only works because both aliases existed on Player.
- Slash-command dispatch iterates an unordered `pairs()` over the regex table, so overlapping prefixes (/t vs /team, /e vs /emote, /s vs /say, /a vs /all) have nondeterministic match precedence as-you-type.
- `OnPlayerAdded` re-connects `PlayersService.PlayerChatted` on every player join (disconnect-first, so no duplication, but connection churn by design comment).
- If the local player's `ChatMode` isn't TextAndMenu (or platform is XBoxOne) neither widget is created and `MessagesChanged`/`CurrentWindowMessageCountChanged` stay nil — callers must nil-check.
- `createPopupFrame`/`popupHidden` are globals (no `local`).
