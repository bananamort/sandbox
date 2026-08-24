# SettingsHub.lua

Source: `roblox-sandbox/content/scripts/Modules/Settings/SettingsHub.lua` (1110 lines)

## Purpose

The escape-menu shell (jeditkacheff): sliding shield + tab bar (HubBar) + scrolling PageView hosting all settings pages, bottom hotkey bar (Leave L/X, Reset R/Y, Resume B/Start), menu stack with PopMenu navigation, Esc binding, dev-console F9 relay, and the ReportPlayer deep-link used by PlayerDropDown.

## API (module surface)

`SetVisibility(visible,noAnimation,customStartPage,switchedFromGamepadInput)`, `ToggleVisibility`, `SwitchToPage(page,ignoreStack)`, `ReportPlayer(player)`, `GetVisibility`, `ShowShield/HideShield`, `SettingsShowSignal`, `.Instance`.

## Behavior highlights

- Singleton built at require time: CreateSettingsHub() → createGui (clippingShield→Shield(#292929 @ .2) → Modal unlock button, HubBar 800×60 (1200×100 ten-foot, small-touch 40), PageViewClipper+PageView ScrollingFrame w/ InputCapture, BottomButtonFrame w/ 3 buttons + per-button gamepad/keyboard hint icons swapped live on input type; Xbox gets InviteToGame (X) instead of Leave unless PlayMyPlace creator). onScreenSizeChanged recomputes page height clamp [150, 600] (800 ten-foot) and re-centers bar/buttons.
- Pages required at build: LeaveGame, ResetCharacter (+Home for small-touch non-userlist), GameSettings always; ReportAbuse (not XboxOne/PS4); Help always; Record Windows-only; Players when FFlag UseUserListMenu && !ten-foot. Registration order defines TabPositions; AddHeader re-lays tabs evenly across HubBar.
- SwitchToPage: direction from header x-compare, Hide(-direction) others, hides BottomButtonFrame+HubBar for Leave/Reset pages, CanvasSize tracks page AbsoluteSize via Changed conn.
- setVisibilityInternal: Quart 0.5 s shield slide, binds RbxSettingsHubStopCharacter (movement freeze), RbxSettingsHubSwitchTab (R1/L1 bumpers w/ wrap), RbxSettingsScrollHotkey (PgUp/PgDn ±100 px), Tab-key tab cycling (Shift reverses), SetMenuIsOpen, mouse-icon override, temporarily hides playerlist ('SettingsMenu')/chat/backpack; customStartPage skips bottom bindings. Close path unbinds everything, clears MenuStack, nils SelectedCoreObject.
- Menu stack: AddToMenuStack dedupes top; PopMenu fires PoppedMenu for non-table entries, restores bottom bindings after Leave/Reset, auto-closes when stack empties.
- Esc bound globally "RBXEscapeMainMenu" → PopMenu(false,true).
- moduleApiTable.ReportPlayer: opens hub straight to ReportAbusePage, then a Displayed→IndexChanged→wait-a-frame dance to SetSelectionByValue(player.Name) (comment explains dropdown reset race).
- GuiService.ShowLeaveConfirmation (Android back) toggles hub or pops.

## Gotchas
- `switchedFromGamepadInput` in setVisibilityInternal does `local switchedFromGamepadInput = switchedFromGamepadInput or isTenFootInterface` — self-reference reads GLOBAL (nil) then shadows param... the actual parameter is silently ignored; harmless but confusing.
- Line 1008: `this.PlayerPage` typo (should be PlayersPage) — nil index guarded only because SwitchToPage returns early on missing PageTable entry... actually it errors calling method on nil? No — `this.PlayerPage` is nil, SwitchToPage(nil,...) hits PageTable[nil]==nil return. Silent no-op bug.
- GetHeaderPosition/switchTab/setVisibilityInternal etc. are GLOBALS (missing local).
- RobloxGui.Changed resize connection never disconnected (TODO admits).
