# BubbleChat.lua

Source: `roblox-sandbox/content/scripts/CoreScripts/BubbleChat.lua` (656 lines)

## Purpose

Classic bubble-chat renderer (jeditkacheff): per-character BillboardGui above heads showing fading chat bubbles with tails, distance LOD (full → "..." small bubble → hidden), blocked/muted suppression, and game-origin (badge/bot) bubbles.

## API / Behavior

- Constants: SourceSans 24, line height 34, tail 14, width pad 30; billboard 400×250 max; message cap 128 incl. ellipsis; NEAR_BUBBLE_DISTANCE 65 / MAX 100 studs.
- Data structures: fifo (BindableEvent Emptied signal), character→chats map auto-vending `createCharacterChats`, chat-line objects with computed lifetime (self 8–15 s by length/75, others 12–20 s).
- Bubble visuals: 4 color presets (WHITE dialog_white slice 5,5,15,15; BLUE/GREEN/RED inset variants) ×3 forms (plain, tailed, scaled-tail); SmallTalkBubble = scaled bubble + TextScaled "...".
- Rendering: BillboardGui (RobloxLocked=true!) parented to **CoreGuiService**, adornee = Head part (Model) or the Part itself; self-bubbles offset toward camera (+2 z). CreateChatLineRender measures via `TextService:GetTextSize`, Elastic tween in, Bounce re-stack of older bubbles (dimmed to 0.5 text transparency, tails stripped), manual fade loop at CHAT_BUBBLE_FADE_SPEED then destroy+pop. DestroyBubble spin-waits until target reaches queue front.
- LOD: per-camera-move sweep — <65 full, <100 distant (4×3 stud scaled "..."), else Enabled=false.
- Message pipeline: PlayerChatted → skip '/' commands, blocked/muted via PlayerDropDown blockingUtility, **filter probe: sets a throwaway TextLabel.Text and compares** (`isLabelTextAllowed`) to detect silent profanity filtering; SanitizeChatLine truncates w/ ellipsis; Enum.PlayerChatType maps to types (note All→PLAYER_GAME_CHAT mapping oddity). Chat service Chatted → colored game lines.
- Init only when RunService:IsClient() (pcall-guarded).

## Usage

Loaded by StarterScript only when FFlag LuaBasedBubbleChat set. Replaces C++ bubble chat.

## Gotchas
- BillboardGui parented under CoreGui (not player GUI) — invisible to normal game scripts but visible to CoreGui walkers.
- DestroyBubble busy-wait loop can spin forever if queue mutated unexpectedly.
- Camera LOD sweep only fires on CoordinateFrame change events, not per-frame.
