# Home.lua

Source: `roblox-sandbox/content/scripts/Modules/Settings/Pages/Home.lua` (82 lines)

## Purpose

The Settings hub "Home" page (by jeditkacheff): Resume / Reset Character / Leave Game buttons stacked vertically, with gamepad focus support.

## API / Behavior

- Constants: BUTTON_OFFSET=20 (top margin), BUTTON_SPACING=10.
- Requires `Modules.Settings.Utility` and lazily `Modules.Settings.SettingsPageFactory` inside Initialize().
- `Initialize()` builds a factory page:
  - TabHeader named "HomeTab", icon texture `rbxasset://textures/ui/Settings/MenuBarIcons/HomeTab.png` (32×30 at x=5), title "Home", tab width 100.
  - `ResumeButton` ("Resume Game", 200×50) → `this.HubRef:SetVisibility(false)` (closes menu).
  - Reset button → `HubRef:SwitchToPage(HubRef.ResetCharacterPage, false, 1)`.
  - Leave button → `HubRef:SwitchToPage(HubRef.LeaveGamePage, false, 1)`.
  - Buttons positioned via AbsolutePosition of previous + spacing; Page height sized to fit last button.
- Module returns singleton `PageInstance`; on `Displayed` event sets `GuiService.SelectedCoreObject = ResumeButton` when the platform uses selected-object navigation (`utility:UsesSelectedObject()`).

## Usage

Required by SettingsHub.lua which registers it as a page and provides `HubRef`.

## Gotchas
- Layout uses AbsolutePosition at BUILD time — assumes RobloxGui already laid out; reflow/resize won't reposition buttons.
- Page height computed once from AbsolutePosition.Y — same build-time assumption.
