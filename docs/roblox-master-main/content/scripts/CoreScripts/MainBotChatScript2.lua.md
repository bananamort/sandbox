# MainBotChatScript2.lua

Source: `roblox-sandbox/content/scripts/CoreScripts/MainBotChatScript2.lua` (728 lines)

## Purpose

The Lua half of the legacy Dialog (NPC conversation) system: floating "!" prompt billboards over Dialog parts, X-button activation for nearest dialog, choice list UI with tone-colored frames, conversation timeout/killswitch machinery, and InUse locking via server RemoteEvent.

## API / Behavior

- Constants per platform (ten-foot: Size36/500w; small-touch: Size14/250w); PURPOSE_DATA maps Quest/Help/Shop → icon+size; tone→ChatColor/FrameStyle/notify-bkg mappings.
- Globals throughout: initialize, presentDialogChoices, doDialog, startDialog, renewKillswitch, addDialog/removeDialog, onLoad, etc.
- Prompt billboards: chatNotificationGui clone per Dialog (adornee=parent part), RobloxLocked everywhere, click → startDialog; Changed handler re-adds on reparent, disables while InUse, refreshes tone/purpose.
- Conversation flow: startDialog (distance check vs ConversationDistance, hides other prompts, binds "Nothing" gamepad freeze, renewKillswitch, wander check loop, doDialog → Chat:Chat initial prompt → presentDialogChoices). Choices sorted by Name, max 4 + Goodbye (GoodbyeChoiceActive flag hides it); heights from TextBounds; small-touch hides TouchControlFrame during convo.
- selectChoice: echoes player's UserDialog via Chat:Chat, SignalDialogChoiceSelected, partner response, variableDelay by length, recurse into children; Goodbye ends.
- Killswitch dual-mode: FFlag FilteringEnabledDialogFix → coroutine timeout (15 s) firing SetDialogInUse RemoteEvent (server: ServerStarterScript handler); else clones engine asset 39226062's TimeoutScript/ReenableDialogScript into the dialog (InsertService fetch with retry).
- Gamepad: Heartbeat loop finds GuiService:GetClosestDialogToPosition, shows ActivationButton + binds X → startDialog; SelectedCoreObject tracking shows A-button on focused choice.
- endDialog: releases InUse (5-s delayed remote or reenable script), re-enables other prompts, restores touch gui.

## Usage

Loaded unconditionally by StarterScript; works with any Dialog instances in CollectionService "Dialog" tag.

## Gotchas
- `Game:GetService` capital-G at lines 472/161 region — legacy alias again.
- `sortedDialogChoices` global (missing local).
- Non-flag path depends on live InsertService fetch of asset 39226062 — fails offline.
- dialogMap keyed by Dialog instance; Changed-based lifecycle can double-fire on rapid reparenting.
