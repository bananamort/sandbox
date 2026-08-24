# GameSettings.lua

Source: `roblox-sandbox/content/scripts/Modules/Settings/Pages/GameSettings.lua` (598 lines)

## Purpose

The main "Settings" tab: graphics mode/quality slider, fullscreen toggle, camera/movement/shift-lock mode selectors with dev-override badges, volume slider (with test sound), mouse-sensitivity curve, and console-only overscan (safe-zone) launcher.

## API / Behavior

- Quality mapping: 10-step UI slider → engine levels via `floor((MaxQualityLevel−1) × pct)` with special cases (==20→21, ==1→1, >max→max−1); writes `GameSettings.SavedQualityLevel` + `settings().Rendering.QualityLevel`; Auto path passes `Enum.QualityLevel.Automatic.Value`. Slider disabled+ZIndex-dimmed in Auto. Listens `game.GraphicsQualityChangeRequest` (+F9-style hotkeys) to nudge slider when not Automatic.
- Fullscreen row → `GuiService:ToggleFullscreen()` per index change.
- Camera/Movement selectors enumerate Touch*/Computer*MovementMode enums, renaming Default per input type; store back to GameSettings on IndexChanged; "Set by Developer" overlay labels shown and rows hidden when LocalPlayer's Dev*Mode ≠ UserChoice — live-updated via LocalPlayer.Changed filtered by PC_CHANGED_PROPS / TOUCH_CHANGED_PROPS tables (uses global `IsTouchClient`, NOT UserInputService.TouchEnabled!).
- Shift Lock Switch row only when MouseEnabled+KeyboardEnabled → GameSettings.ControlMode MouseLockSwitch/Classic; override badge from DevEnableMouseLock.
- Volume: 10-step slider → MasterVolume = n/10; plays `uuhhh.mp3` at that volume as feedback.
- Mouse sensitivity: quadratic curve between GUI 0..10 ↔ engine 0.2..4 (`0.03x²+0.08x+0.2`; inverse via sqrt(75s−11)).
- Overscan (ten-foot): requires Modules.OverscanScreen, opens ScreenManager screen, blurs via PlatformService.BlurIntensity=10, swallows gamepad movement via BindCoreAction no-op "RbxStopOverscanMovement".
- Rows created conditionally: camera always, movement unless ten-foot, mouse if mouse, volume always, graphics only Windows/OSX.

## Usage

SettingsHub registers as the Settings tab; Page ZIndex raised to 5.

## Gotchas
- `IsTouchClient` is an undefined GLOBAL in this file (engine-injected legacy?) — under strict Luau this errors on any LocalPlayer property change.
- GraphicsQualityChangeRequest handler mutates slider even while Auto (guarded by early return).
- Volume test sound parented to RobloxGui.Sounds folder (must exist).
- SetGraphicsQuality's elseif chain means newValue<1 case unreachable after ==1 case... order-dependent clamping logic.
