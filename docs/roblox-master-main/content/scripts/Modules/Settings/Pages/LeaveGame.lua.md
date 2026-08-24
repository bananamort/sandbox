# LeaveGame.lua

Source: `roblox-sandbox/content/scripts/Modules/Settings/Pages/LeaveGame.lua` (123 lines)

## Purpose

Settings-hub confirmation page: "Are you sure you want to leave the game?" with Leave (fires the engine `Exit` verb) and Don't Leave buttons; gamepad-B cancel binding while shown.

## API / Behavior

- Constant: `LEAVE_GAME_ACTION = "LeaveGameCancelAction"`.
- Requires Settings.Utility; blocks at require time on `RobloxGui.Modules.TenFootInterface` then checks `IsEnabled()`.
- Page has NO tab (`this.TabHeader = nil`) — modal-style.
- Cancel surface, three flavors:
  - `DontLeaveFunc(isUsingGamepad)` → `HubRef:PopMenu(isUsingGamepad, true)`.
  - `DontLeaveFromHotkey(name,state,input)` → on Begin, detects gamepad1-4 input type, delegates.
  - `DontLeaveFromButton(isUsingGamepad)` → direct delegate.
- UI: SourceSansBold Size36 white wrapped label ("Are you sure…", 200 tall; Size24/100 on small touch, Size48 + y-offset 100 on ten-foot); two 200×50 buttons (300×80 ten-foot) anchored to bottom of label: LeaveGameButton left (`NextSelectionRight=nil`), DontLeave right (`NextSelectionLeft=nil`) — traps selection cycling between them.
- **Leave button uses `SetVerb("Exit")`** — the actual quit is the engine verb, not Lua.

## Usage

Returned singleton registered by SettingsHub as `LeaveGamePage`; Home page routes here. On Displayed: focus Leave button + BindCoreAction ButtonB→cancel; Hidden: unbind.

## Gotchas
- Module-level blocking WaitForChild(TenFootInterface) — import order dependency.
- Page.Size computed from AbsolutePosition once — same build-time-layout assumption as other pages.
- Gamepad B is the ONLY hotkey bound (no Esc handling here — hub handles that).
