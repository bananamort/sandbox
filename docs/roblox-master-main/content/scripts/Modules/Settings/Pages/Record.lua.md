# Record.lua

Source: `roblox-sandbox/content/scripts/Modules/Settings/Pages/Record.lua` (169 lines)

## Purpose

Settings-hub "Record" tab (jeditkacheff): Screenshot + Video recording controls. Both buttons close the menu and fire engine VERBS (`Screenshot` / `RecordToggle`); a selector chooses Save-To-Disk vs Upload-to-YouTube.

## API / Behavior

- Uses `UserSettings().GameSettings` (`VideoUploadPromptBehavior`) and `settings():FindFirstChild("Game Options")` → `VideoRecordingChangeRequest` signal.
- Page surface:
  - `this.RecordingChanged` (BindableEvent Event) + `this:IsRecording()` — public recording-state API.
  - TabHeader "RecordTab", icon RecordTab.png 41×40, width 130.
  - `SetHub(newHubRef)` OVERRIDES the factory hook because the Selector row needs the hub at build time.
  - Screenshot block: title+body labels, 300×44 button, verb "Screenshot".
  - Video block: title+body, `utility:AddNewRow(this,"Video Settings","Selector",{"Save To Disk","Upload to YouTube"},startSetting,270)`; IndexChanged writes `GameSettings.VideoUploadPromptBehavior = Never/Always`.
  - Record button: verb **RecordToggle**; MouseButton1Click fires RecordingChanged with toggled state; label swaps "Record Video" ↔ "Stop Recording" driven by VideoRecordingChangeRequest signal (guarded by FindFirstChild nil-check).
- Displayed handler focuses ScreenshotButton ONLY when switched from gamepad input.

## Usage

SettingsHub registers as the Record tab page; verbs handled engine-side.

## Gotchas
- Header comment has stray `--[[r` (typo) — harmless.
- Recording state tracking only works if "Game Options" child exists in settings() (desktop); on missing it the label never updates.
- Two independent toggle paths (verb via SetVerb + BindableEvent fire) — RecordingChanged listeners get notified even if the engine REJECTS the toggle.
