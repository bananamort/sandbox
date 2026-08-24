# App/include/v8datamodel/StarterPlayerService.h

## Purpose

`StarterPlayerService` — PERSISTENT_LOCAL creatable service holding per-game default player/camera settings (camera mode + movement/occlusion modes for touch and computer, zoom/name/health display distances, mouse-lock, auto-jump, character appearance loading) which are copied onto each joining player via setupPlayer.

## Declared API

`class StarterPlayerService : public DescribedCreatable<StarterPlayerService, Instance, sStarterPlayerService, Reflection::ClassDescriptor::PERSISTENT_LOCAL>, public Service`

- Enums: `DeveloperTouchCameraMovementMode {USER=0, CLASSIC=1, FOLLOW=2}`; `DeveloperComputerCameraMovementMode {same trio}`; `DeveloperCameraOcclusionMode {ZOOM=0, INVISI=1}`; `DeveloperTouchMovementMode {USER=0, THUMBSTICK=1, DPAD=2, THUMBPAD=3, CLICK_TO_MOVE=4, SCRIPTABLE=5}`; `DeveloperComputerMovementMode {USER=0, KBD_MOUSE=1, CLICK_TO_MOVE=2, SCRIPTABLE=3}`.
- Private state: `RBX::Camera::CameraMode cameraMode`; floats nameDisplayDistance / healthDisplayDistance / cameraMaxZoomDistance / cameraMinZoomDistance; bools enableMouseLockOption, autoJumpEnabled, loadCharacterAppearance; the five mode enums; `void setupPlayer(shared_ptr<Instance> instance)`; scoped workspaceLoadedConnection.
- Protected overrides: `askForbidChild`, `askAddChild`, `onServiceProvider`.
- Public: ctor; `void setupPlayerScripts()`; `void recordSettingsInGA() const` — telemetry of settings to Google Analytics; get/set pairs: CameraMode (getter inline), EnableMouseLockOption, Dev{Touch,Computer}CameraMovementMode, DevCameraOcclusionMode, Dev{Touch,Computer}MovementMode, NameDisplayDistance, HealthDisplayDistance, CameraMaxZoomDistance, CameraMinZoomDistance, AutoJumpEnabled, LoadCharacterAppearance.

## Gotchas

- Settings are templates applied at player spawn via setupPlayer — changing them mid-session affects only future joins unless core scripts re-read.
- recordSettingsInGA sends developer configuration to analytics — privacy-relevant behavior worth noting.
- askForbidChild/askAddChild restrict what can be parented here (e.g. StarterPlayerScripts containers — see [PlayerScripts.md](PlayerScripts.md)).

## UNKNOWN

- Exact child-admission rules in askAddChild/askForbidChild (out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/StarterPlayerService.md](../../v8datamodel/StarterPlayerService.md).
- Consumers: [Camera.md](Camera.md), [PlayerScripts.md](PlayerScripts.md), [PlayerGui.md](PlayerGui.md).
