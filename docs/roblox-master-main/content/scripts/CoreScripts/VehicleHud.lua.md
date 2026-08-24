# VehicleHud.lua

Source: `roblox-sandbox/content/scripts/CoreScripts/VehicleHud.lua` (160 lines)

## Purpose

VehicleSeat HUD (by jmargh): bottom-center speed bar + numeric speed readout while seated in a VehicleSeat with `HeadsUpDisplay` on. Header TODO: "move to PlayerScripts as module" once stable.

## API / Behavior

- Waits for LocalPlayer via busy loop; `script.Parent` shadowed by later `CoreGui:WaitForChild("RobloxGui")` (first assignment dead); blocks on TenFootInterface for 10-foot mode sizing.
- Textures: SpeedBarBKG/SpeedBarEmpty/SpeedBar pngs under textures/ui/Vehicle/.
- Layout: VehicleHudFrame 158×14 (316×50 ten-foot), centered, BOTTOM_OFFSET 70 (100 ten-foot) from bottom; clipping frame drives the fill bar width; SpeedLabel left "Speed", SpeedText right numeric; SourceSans 18 (48 ten-foot) with grey stroke.
- Per-frame `onRenderStepped`: `speed = seat.Velocity.magnitude`; text = floor(min(speed,9999)); bar fill = `(speed / MaxSpeed) * barWidth` clamped.
- `onSeated(active, currentSeatPart)`:
  - Seated: prefers the Humanoid.Seated part if it IS a VehicleSeat, else falls back to `workspace.CurrentCamera.CameraSubject` (legacy path comment); shows frame iff `HeadsUpDisplay`; connects RenderStepped + seat.Changed.
  - Stood up: hides frame, clears seat, disconnects both connections.
- `connectSeated()` busy-waits for a Humanoid then binds Seated; re-runs on every CharacterAdded.

## Usage

Loaded by StarterScript when UseInGameTopBar is set. Parented under RobloxGui.

## Gotchas
- Speed shown is RAW velocity magnitude in studs/sec — MaxSpeed-relative only for the bar.
- Busy-wait loops (`while not Players.LocalPlayer`, `while not humanoid`) spin without timeout.
- If CameraSubject fallback grabs a non-VehicleSeat subject the HUD silently never shows.
- Duplicate `local RobloxGui` declaration (lines 16 vs 21) — first is dead code.
