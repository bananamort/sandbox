# GamepadMenu.lua

Source: `roblox-sandbox/content/scripts/CoreScripts/GamepadMenu.lua` (652 lines)

## Purpose

Radial quick menu on gamepad Start button (jeditkeff v1.1): six wedge buttons (Settings, Player List, Notifications, Leave Game, Backpack, Chat) selected by left-thumbstick angle, activated with A, cancelled with B; CoreGui enable/disable state greys wedges out.

## API / Behavior

- Slots 1–6 map to fixed images/icons/positions (Radial/Top..TopLeft + Empty variants + per-slot icon pngs); disabled state swaps image to `Empty\` path via gsub and hides RadialIcon.
- Buttons: Settings→SettingsHub SetVisibility(true,…,true); PlayerList→PlayerlistModule ToggleVisibility if closed; Notifications→BindableEvent "GamepadNotifications" (child of script) — DISABLED on ten-foot; Leave→hub with LeaveGame page forced; Backpack→BackpackScript OpenClose; Chat→Chat ToggleVisibility — disabled on ten-foot.
- Angle math: thumbstick1 magnitude >0.8 → atan2(x,y) degrees → `getSelectedObjectFromAngle` over 60° ranges (Settings wraps 336→36) with exact-match-then-closest(30° threshold) fallback.
- toggleCoreGuiRadial(goingToSettings): toggles frame 102↔408px with Back/Sine tweens, fades child images, blocks gamepad1 via no-op bind, binds A/B/Thumbstick1(+Thumbstick2 no-op)/Start actions, GuiService:SetMenuIsOpen(true), disables GuiNavigation (new name w/ old-name pcall fallback), overrides mouse icon ForceHide/ForceShow on last-input change. Close path unbinds all + re-enables navigation.
- Gamepad1-connected gate: build gui now or on GamepadConnected.
- StarterGui.CoreGuiChangedSignal → setRadialButtonEnabled maps CoreGuiType→wedge (All = every typed button); ten-foot Chat exempted from updates.

## Usage

Loaded by StarterScript always (harmless without pad). Requires Record page module (for commented-out stop-recording UI — still imported!).

## Gotchas
- Forward references: createGamepadMenuGui references toggleCoreGuiRadial/unbindAllRadialActions defined later as globals inside setupGamepadControls — works because calls happen post-definition, but breaks under strict locals.
- getButtonForCoreGuiType returns mixed types (table for All, button else).
- Notifications wedge dead on consoles by design but still rendered.
