# StarterScript.lua

Source: `roblox-sandbox/content/scripts/StarterScript.lua` (69 lines)

## Purpose

Client CoreScript bootstrap ("Creates all neccessary scripts for the gui on initial load, everything except build tools" — header comment by Ben T. 10/29/10). Loads every in-game UI core script in a deliberate order, gated by FFlags, into `CoreGui.RobloxGui`.

## API / Behavior

- Services: ScriptContext, UserInputService (TouchEnabled), CoreGui.
- Creates empty `Folder "Sounds"` under RobloxGui (populated later by other scripts).
- FFlags (all via pcall-wrapped `settings():GetFFlag`): `UseInGameTopBar`, `UseLuaCameraAndControl` (read but UNUSED), `LuaBasedBubbleChat`.
- Load order:
  1. If UseInGameTopBar: `CoreScripts/Topbar`.
  2. Always: `CoreScripts/MainBotChatScript2` (Dialogs), `CoreScripts/DeveloperConsole`, `CoreScripts/NotificationScript2`.
  3. If topbar: spawn-require `RobloxGui.Modules.Chat` and `RobloxGui.Modules.PlayerlistModule`.
  4. If LuaBasedBubbleChat: `CoreScripts/BubbleChat`.
  5. Always: `CoreScripts/PurchasePromptScript2`.
  6. If NOT topbar: legacy `CoreScripts/HealthScript`.
  7. Always: spawn-require `RobloxGui.Modules.BackpackScript`.
  8. If topbar: `CoreScripts/VehicleHud`; always: `CoreScripts/GamepadMenu`.
  9. Touch devices: `CoreScripts/ContextActionTouch`, then waits for `RobloxGui.ControlFrame.BottomLeftControl` and hides it.

## Usage

Engine loads this as the client entry CoreScript on join; paths passed to `AddCoreScriptLocal` are relative to content/scripts/.

## Gotchas
- Chat/Playerlist/Backpack loaded via `require(RobloxGui.Modules.X)` (ModuleScripts) while others via AddCoreScriptLocal — two mechanisms.
- `UseLuaCameraAndControl` flag fetched then discarded — dead read.
- HealthScript vs Topbar mutual exclusion encodes the old/new HUD split.
- Touch path BLOCKS on WaitForChild of ControlFrame children — assumes another script created them.
