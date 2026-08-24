# Help.lua

Source: `roblox-sandbox/content/scripts/Modules/Settings/Pages/Help.lua` (488 lines)

## Purpose

Settings-hub Help page showing control cheatsheets that SWITCH based on the last input type: three lazily-built layouts — PC keyboard/mouse table, console controller diagram with labels, touch gesture sheet.

## API / Behavior

- Tags: KeyboardMouse / Touch / Gamepad; `GetCurrentInputType()` — remembers last non-Focus/None UserInputType via global InputBegan hook; falls back to platform defaults (XBoxOne/WiiU→gamepad, Windows/OSX→KB+M, else touch). **Contains real bug at line 59: the Gamepad3 clause reads undefined global `inputType`** (`inputType == Enum.UserInputType.Gamepad3` instead of `lastInputType`). Comparing nil to an enum is legal Lua (no error), so this does NOT crash — it silently makes the check always false, so Gamepad3 users fall through to the KEYBOARD_MOUSE_TAG default instead of the gamepad layout. Gamepad1/2/4 are checked correctly.
- PC help: 5 groups in 3 columns — Character Movement (WASD/arrows/Space), Accessories (1-9 equip, Backspace drop, + drop hats), Misc (PrintScreen, F12 record, [F7 Hide HUD gated by FFlag AllowHideHudShortcut], F9 devconsole, Shift mouselock, F10 graphics, F11 fullscreen — OSX gets fn variants), Camera Movement, Menu Items (ESC menu, ~ backpack, TAB playerlist, / chat). Each group auto-heights at 42px rows +2 spacing.
- Gamepad help: platform image Generic/Xbox(1334×570)/PS controller + 10 absolutely-positioned labels per layout family; XboxOne path disables PageView clipping so labels can overflow. Dead-commented dev-console A-button block.
- Touch help: Move/Jump/Equip radial labels + Zoom/Rotate/UseTool gesture images; sizes from screen resolution −350 (−100 small).
- `displayHelp` swaps cached pages by parenting; Hidden handler restores ClipsDescendants, ShowShield(), restores BottomButtonFrame.

## Usage

SettingsHub registers as Help tab; page reacts LIVE to input changes while displayed.

## Gotchas
- The `inputType` nil-global in GetCurrentInputType (line 59) silently misclassifies Gamepad3 as keyboard/mouse — no crash, but gamepad3 users get the wrong cheatsheet.
- WaitForChild('ToggleDevConsole') on ControlFrame — hard dependency on engine-created GUI (TODO admits it).
- Xbox-only unclipping leaks into other pages if Hidden never fires.
