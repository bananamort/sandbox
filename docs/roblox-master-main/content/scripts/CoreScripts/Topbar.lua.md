# Topbar.lua

Source: `roblox-sandbox/content/scripts/CoreScripts/Topbar.lua` (1263 lines)

## Purpose

The new (2015-era) in-game top bar (SolarCrane): 36px dark bar with left menu icons (Settings hamburger, Chat, mobile chat toggle, Backpack, ShiftLock, Stop-Recording) and right items (leaderstats columns, username+health bar), CoreGui enable/disable integration, `SetCore TopbarEnabled` support, and global GUI-inset registration.

## API / Behavior

- **CreateTopBar** — TopBarContainer offscreen at y=−36, slides conceptually via inset; transparency from `PlayerGui:GetTopbarTransparency()` signal or 0.5 default; opaque while settings open; dropshadow when fully opaque.
- **CreateMenuBar('Left'/'Right')** — ordered item list w/ ArrangeItems by GetWidth; dock = the topbar frame.
- **CreateMenuItem(instance)** — proxy-table wrapper (`__index`/`__newindex` forward to instance); SetInstance once-only.
- Items:
  - Settings: Hamburger ↔ HamburgerDown with settingsActive; wired to SettingsHub.SettingsShowSignal + ToggleVisibility.
  - Username+Health: name label + 3px health fill colored by **Shepard's interpolation** over red/yellow/green samples at health% {0.1, 0.5, 0.8}; hurt overlay (asset 34854607) flash on ≥5% max-health drops gated by core Health enabled; ten-foot delegates to TenFootInterface:CreateHealthBar; click toggles Playerlist. SetHealthbarEnabled/SetNameVisible added via metatable juggling.
  - Leaderstats: up to N 75px columns from PlayerlistModule.GetStats()/OnLeaderstatsChanged/OnStatChanged (small touch shows only first column); click toggles playerlist.
  - Chat: hidden on XboxOne; unread counter badge (>99 → "!") unless MobileToggleChatVisibleIcon touch mode; toggle semantics differ for touch/bubble-chat (focus chat bar instead), initial ToggleVisibility(true) on non-touch.
  - MobileHideChatIcon (flag-gated), Backpack (StateChanged icon swap), StopRecording (verb RecordToggle, shown during VideoRecordingChangeRequest), ShiftLock icon CREATED BUT DISABLED (`shiftlockIcon = nil --CreateShiftLockIcon()`) — all CheckShiftLockMode machinery is dead code today.
- OnCoreGuiChanged adds/removes items per PlayerList/Health/Backpack/Chat/All + SetNameVisible logic.
- SetCore("TopbarEnabled") under flag EnableSetCoreTopbarEnabled refires everything; Util.SetGUIInsetBounds sets GlobalGuiInset(0,36) + fires RobloxGui.GuiInsetChanged (consumed by LoadingScript).

## Usage

Loaded by StarterScript only when FFlag UseInGameTopBar — replaces ControlFrame HUD generation.

## Gotchas
- CreateMenuItem proxy swallows ALL writes into instance — no local state possible.
- Shepard interpolation table keyed by Vector3 of Color3 floats.
- stopRecordIcon always built even on platforms without Game Options (just never shown).
