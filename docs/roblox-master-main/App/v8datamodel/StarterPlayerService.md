# StarterPlayerService.cpp

## Purpose

Implements `StarterPlayerService` (instance "StarterPlayer"), the per-place defaults service: developer camera/movement modes, mouse-lock and auto-jump options, camera zoom bounds, name/health display distances, character appearance loading. On server start it stamps every existing Player with these defaults and lazily creates StarterPlayerScripts (and flag-gated StarterCharacterScripts) on workspaceLoaded. Also records the settings mix to Google Analytics.

## Key types and API

Descriptors (categories shown; no security tiers ⇒ default):
- Camera: "DevTouchCameraMovementMode" / "DevComputerCameraMovementMode" / "DevCameraOcclusionMode" (enums), "CameraMode" (Camera::CameraMode, default CLASSIC), "CameraMaxZoomDistance" (default distanceMaxCharacter; clamped [minZoom, maxCharacter]), "CameraMinZoomDistance" (default distanceMin; clamped [distanceMin, maxZoom]).
- Controls: "DevTouchMovementMode" / "DevComputerMovementMode" enums; "EnableMouseLockOption" bool default true.
- Mobile: "AutoJumpEnabled" bool default true.
- Character: "LoadCharacterAppearance" bool default true — setter NO-OPS unless DFFlag UseStarterPlayerCharacter is on.
- Data: "NameDisplayDistance"/"HealthDisplayDistance" floats default 100, clamped ≥ 0.

Enums: DevTouchCameraMovementMode {UserChoice, Classic, Follow}; DevComputerCameraMovementMode {same three}; DevCameraOcclusionMode {Zoom, Invisicam}; DevTouchMovementMode {UserChoice, Thumbstick, DPad, Thumbpad, ClickToMove, Scriptable}; DevComputerMovementMode {UserChoice, KeyboardMouse, ClickToMove, Scriptable}. Source TODO notes remaining enums live in factoryregistration.cpp.

Child rules: askAddChild/askForbidChild accept ONLY StarterPlayerScripts by default; Humanoid / StarterCharacterScripts / ModelInstance each additionally allowed under their respective DFFlags UseStarterPlayerHumanoid / UseStarterPlayerCharacterScripts / UseStarterPlayerCharacter (all default false).

Flow:
- `setupPlayer(Player*)`: copies camera mode/zoom bounds/display distances/autoJump onto the player.
- `onServiceProvider` (server only): setupPlayer over all Players descendants; hooks workspaceLoadedSignal → `setupPlayerScripts` which creates missing StarterPlayerScripts, and under UseStarterPlayerCharacterScripts a missing StarterCharacterScripts (existence check uses the correct `findFirstChildOfType<StarterCharacterScripts>` template; the local variable holding the result is merely declared as the base-class pointer type).
- `recordSettingsInGA()`: seven GA_CATEGORY_GAME events mapping each enum to a string label.

## Usage / reflection touchpoints

Fully script-facing place-settings surface consumed at join time. Pairs with PlayerScripts.md/StarterPlayerScripts handshake in this folder, Camera behavior under Rendering docs, [Network Players](../../Network/).

## Gotchas

- Earlier review note retracted after grep verification: the StarterCharacterScripts existence check does NOT use the wrong template — `findFirstChildOfType<RBX::StarterCharacterScripts>()` is correct (line 341); only the receiving local is typed as base-class `StarterPlayerScripts*`, which is cosmetic.
- LoadCharacterAppearance silently ignores writes when its flag is off — property appears writable but stays stale.
- Zoom-distance setters cross-clamp against each other's CURRENT values, not atomically — setting max below min then min can transiently invert ordering.
- Defaults are stamped onto players only at server provider init; players joining later rely on Network-side calls of setupPlayer (UNKNOWN caller).
