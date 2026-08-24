# ResetCharacter.lua

Source: `roblox-sandbox/content/scripts/Modules/Settings/Pages/ResetCharacter.lua` (138 lines)

## Purpose

Settings-hub confirmation page: "Are you sure you want to reset your character?" — Reset kills the LocalPlayer's Humanoid; Don't Reset pops back. Structurally a twin of LeaveGame.lua.

## API / Behavior

- Constant: `RESET_CHARACTER_GAME_ACTION = "ResetCharacterAction"`.
- Same TenFootInterface blocking require + IsEnabled probe as LeaveGame.
- No tab (`TabHeader = nil`); Page named "ResetCharacter".
- Cancel trio (`DontResetCharFunc` / `FromHotkey` / `FromButton`) identical pattern → `HubRef:PopMenu(isUsingGamepad, true)`.
- **Reset action**: walks `Players.LocalPlayer → Character → FindFirstChild('Humanoid')` and sets `humanoid.Health = 0` (the actual reset mechanism), then closes hub with `SetVisibility(false, true)` (second arg likely "skip animation/force").
- UI mirrors LeaveGame: SourceSansBold label w/ small-touch & ten-foot variants, two 200×50 (or 300×80) buttons bottom-anchored, selection-trap via NextSelectionRight/Left nil.

## Usage

SettingsHub registers as `ResetCharacterPage`; Home routes here. Displayed → focus + BindCoreAction ButtonB; Hidden → unbind.

## Gotchas
- Health=0 respects game scripts' Died handlers but bypasses any custom reset logic — it IS the standard kill path.
- If character/humanoid missing, button silently just closes the menu.
- Same build-time AbsolutePosition layout caveat as sibling pages.
