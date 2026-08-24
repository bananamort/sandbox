# App/include/v8datamodel/GameBasicSettings.h

## Purpose

User-facing basic settings item (GlobalBasicSettingsItem under GlobalSettings): control/camera/movement mode selection per input type, mouse lock/pan/freelook, render quality, volume/sensitivity, fullscreen/window state, tutorials, video/image upload policy, and Google-Analytics client id. The persisted player-preferences hub.

## Declared API

`class GameBasicSettings : public GlobalBasicSettingsItem<GameBasicSettings, sGameBasicSettings>`

- Enums: `ControlMode {CONTROL_CLASSIC=0, CONTROL_MOUSELOCK, CONTROL_HYBRID, CONTROL_CAMLOCK, CONTROL_MOUSEPAN}`; `RenderQualitySetting {QUALITY_AUTO=0, QUALITY_1..QUALITY_10}`; `CameraMode {DEFAULT, CLASSIC, FOLLOW}`; `TouchCameraMovementMode {DEFAULT, CLASSIC, FOLLOW}`; `ComputerCameraMovementMode {DEFAULT, CLASSIC, FOLLOW}`; `TouchMovementMode {DEFAULT, THUMBSTICK, DPAD, THUMBPAD, CLICK_TO_MOVE}`; `ComputerMovementMode {DEFAULT, KBD_MOUSE, CLICK_TO_MOVE}`; `RotationType {MOVEMENT_RELATIVE=0, CAMERA_RELATIVE}`.
- Reflection: `static PropDescriptor<GameBasicSettings, float> prop_masterVolume;`
- Mode accessors: get/set for controlMode, cameraMode (+`getCameraModeWithDefault()`), touch/computer camera-movement modes each with a `*Modified` flag pair, touch/computer movement modes with modified flags, rotationType.
- Mouse: `setMouseLock(bool)/isMouseLocked()`, `setCanMousePan(bool)/getCanMousePan()`, `setFreeLook(bool)/getFreeLook()`, `getMouseSensitivity()/setMouseSensitivity(float)`.
- Predicates: `inClassicMode/inMouseLockMode/inHybridMode/inCamlockMode/inMousepanMode`, `mouseLockedInMouseLockMode()`, `camLockedInCamLockMode()`.
- Tutorials: `getTutorialState(id)/setTutorialState(id,bool)`, `getCompletedTutorials()/setCompletedTutorials(std::string)`, `getAllTutorialsDisabled()/setAllTutorialsDisabled(bool)`.
- Upload policy: `GameSettings::UploadSetting getUploadVideoSetting()/setUploadVideoSetting(...)`, same for PostImage.
- Video/display: `getRenderQuality/setRenderQuality(RenderQualitySetting)`; fullscreen trio (`getFullScreenConst()` const-correct twin, `getFullScreen()`, inline `setFullScreen` firing `fullscreenChangedSignal`); start-screen pos/size (Vector2), startMaximized.
- Audio: `prop_masterVolume` + `getMasterVolume()/setMasterVolume(float)`.
- Studio: `inStudioMode()`, inline `setStudioMode(bool)` firing `studioModeChangedSignal` before storing; `getUsedHideHudShortcut()/setUsedHideHudShortcut(bool)`.
- Analytics: `getGoogleAnalyticsClientId()/setGoogleAnalyticsClientId(const std::string&)`; `void recordSettingsInGA(bool touchEnabled) const;`
- Overrides: `reset(); verifySetParent(const Instance*) const;`
- Signals: `fullscreenChangedSignal<void(bool)>`, `studioModeChangedSignal<void(bool)>`.
- State: one member per enum + modified flags (note misspelled `touchMoveModeModeModified`, `computerMoveModeModeModified`), mouseLocked/canMousePan/freeLook, upload settings, fullscreen/studio, window geometry, volumes, tutorial map, GA id.

## Gotchas

- setStudioMode fires the signal *before* mutating the flag — listeners read the old value.
- Modified flags track whether user overrode DEFAULT movement modes.
- Member-name typos are verbatim in source.

## UNKNOWN

- Persisted-file mapping of these fields (.cpp / GlobalBasicSettingsItem plumbing).

## Cross-links

- Implementation: [App/v8datamodel/GameBasicSettings.md](../../v8datamodel/GameBasicSettings.md).
- Settings family: [GlobalSettings.md](GlobalSettings.md), [GameSettings.h](GameSettings.md), [DebugSettings.md](DebugSettings.md).
