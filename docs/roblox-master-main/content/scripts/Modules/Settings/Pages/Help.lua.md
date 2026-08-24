# Help.lua

Source: `roblox-sandbox/content/scripts/Modules/Settings/Pages/Help.lua` (488 lines)

## Purpose

Settings-hub Help page showing control cheatsheets that SWITCH based on the last input type: three lazily-built layouts — PC keyboard/mouse table, console controller diagram with labels, touch gesture sheet.

## API / Behavior

- Tags: KeyboardMouse / Touch / Gamepad; `GetCurrentInputType()` — remembers last non-Focus/None UserInputType via global InputBegan hook; falls back to platform defaults (XBoxOne/WiiU→gamepad, Windows/OSX→KB+M, else touch). **Contains latent bug: references undefined `inputType` in the Gamepad3 comparison** (`inputType == Enum.UserInputType.Gamepad3`) — would error if evaluation ever reached it (short-circuited unless Gamepad2 matched false... actually the OR chain evaluates left-to-right only until true, so Gamepad3 clause runs when lastInputType is Gamepad1? No — each == is checked; reaching Gamepad3 clause means Gamepad1/2 were false; then referencing nil-global inputType ERRORS).
- PC help: 5 groups in 3 columns — Character Movement (WASD/arrows/Space), Accessories (1-9 equip, Backspace drop, + drop hats), Misc (PrintScreen, F12 record, [F7 Hide HUD gated by FFlag AllowHideHudShortcut], F9 devconsole, Shift mouselock, F10 graphics, F11 fullscreen — OSX gets fn variants), Camera Movement, Menu Items (ESC menu, ~ backpack, TAB playerlist, / chat). Each group auto-heights at 42px rows +2 spacing.
- Gamepad help: platform image Generic/Xbox(1334×570)/PS controller + 10 absolutely-positioned labels per layout family; XboxOne path disables PageView clipping so labels can overflow. Dead-commented dev-console A-button block.
- Touch help: Move/Jump/Equip radial labels + Zoom/Rotate/UseTool gesture images; sizes from screen resolution −350 (−100 small).
- `displayHelp` swaps cached pages by parenting; Hidden handler restores ClipsDescendants, ShowShield(), restores BottomButtonFrame.

## Usage

SettingsHub registers as Help tab; page reacts LIVE to input changes while displayed.

## Gotchas
- The `inputType` nil-global in GetCurrentInputType is a real crash path for gamepad3/4 users (first input after open).
- WaitForChild('ToggleDevConsole') on ControlFrame — hard dependency on engine-created GUI (TODO admits it).
- Xbox-only unclipping leaks into other pages if Hidden never fires.
