# GameBasicSettings.cpp

## Purpose

Implements `GameBasicSettings` (registered "UserGameSettings", instance NAME "GameSettings") — the per-user control/preferences singleton: control/camera/movement mode enums with RobloxScript-gated setters + GA tracking, tutorial completion store, volume/sensitivity/fullscreen/window prefs, and the StudioMode/Fullscreen change signals. Defines hackFlag5 decoy.

## Key types and API

Descriptors:
- category_Control: prop_controlMode("ControlMode" — setter REQUIRES **Security::RobloxScript** "set camera control mode"), prop_cameraMode("CameraMode", STANDARD + Security::RobloxScript), TouchCameraMovementMode / ComputerCameraMovementMode / TouchMovementMode / ComputerMovementMode enums (each setter gated), RotationType(SCRIPTING, no gate).
- CLUSTER props (**Security::Roblox**): TouchCameraMovementChanged, ComputerCameraMovementChanged, TouchMovementChanged, ComputerMovementChanged — "modified" booleans set true by their mode setters.
- Video/Appearance: prop_uploadVideo("VideoUploadPromptBehavior", STANDARD, RobloxScript), prop_uploadScreenshots("ImageUploadPromptBehavior", "Screenshots", RobloxScript), prop_renderQuality("SavedQualityLevel", setter gated).
- Tutorials (**Security::RobloxScript**): GetTutorialState/SetTutorialState funcs, CompletedTutorials(STREAMING, comma-joined ids), AllTutorialsDisabled(STANDARD).
- PUBLIC_SERIALIZED window prefs (RobloxScript): StartMaximized(true), StartScreenSize(800×600), StartScreenPosition(20,20).
- Misc: GameBasicSettings::prop_masterVolume("MasterVolume", setter gated, clamped 0..1), MouseSensitivity(gated, clamped 0.2..10), Fullscreen(STANDARD, RobloxScript; getter is getFullScreenConst), gaID(CLUSTER, RobloxScript), UsedHideHudShortcut.
- Security::None: InFullScreen(), InStudioMode(), events StudioModeChanged(isStudioMode)/FullscreenChanged(isFullscreen).

Enums registered: ControlMode {MouseLockSwitch(+legacy spaced), Classic — CamLock/DragToLook/ClickToLook commented out}, SavedQualitySetting {Automatic + QualityLevel1..10}, CustomCameraMode {Default, Follow, Classic}, Touch/Computer CameraMovementMode {Default/Follow/Classic}, TouchMovementMode {Default/Thumbstick/DPad/Thumbpad/ClickToMove}, ComputerMovementMode {Default/KeyboardMouse/ClickToMove}, RotationType {MovementRelative, CameraRelative}.

Behavior:
- getCameraModeWithDefault — DEFAULT resolves to FOLLOW on iOS/Android else CLASSIC.
- Every mode setter: permission check → GA label track → raise → mark *Modified(true). reset() restores classic/auto defaults.
- verifySetParent — non-Anonymous identities need RobloxScript to re-parent ("set GameSettings parent").
- recordSettingsInGA(touchEnabled) fires 4-6 GA events at startup from [Game](Game.md)::setupDataModel.

## Usage / reflection touchpoints

Singleton consumed by camera/control systems ([UserController](UserController.md), [Camera](Camera.md)); inStudioMode() gates interpolation paths there; tutorials UI via CompletedTutorials.

## Gotchas

- Instance name vs class name inversion AGAIN: registered "UserGameSettings" but setName("GameSettings") while [GameSettings](GameSettings.md) uses "Game Options".
- CONTROL enum reduced to 2 values — legacy scripts setting CharacterLock fail enum conversion.
- Tutorial state map only round-trips TRUE entries through the comma string; false entries vanish on reload.
