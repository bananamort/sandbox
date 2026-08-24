# UserInputService.cpp

## Purpose

Implements `UserInputService`, the central input hub: platform capability flags (touch/keyboard/mouse/gamepad/motion/VR), thread-safe input queues drained on render step, the dual core/gameplay event split (RobloxScript contexts get events even with menu open), gesture recognition dispatch (tap/pinch/swipe/long-press/rotate/pan), keyboard state map + modified-key synthesis, mouse behavior/icon stack, camera zoom/pan accumulation, gamepad connection/state plumbing into GamepadService, textbox focus tracking, and legacy touch→fake-mouse translation.

## Key types and API

Enums: SwipeDirection {Right,Left,Up,Down,None}; Platform {Windows, OSX, IOS, Android, XBoxOne, PS4, PS3, XBox360, WiiU, NX, Ouya, AndroidTV, Chromecast, Linux, SteamOS, WebOS, DOS, BeOS, UWP, None}; MouseBehavior enum "MouseBehavior" {Default, LockCenter, LockCurrentPosition}; OverrideMouseIconBehavior {None, ForceShow, ForceHide}; UserCFrame {Head, LeftHand, RightHand}.

Descriptors (**Security::** tiers verbatim):
- RobloxScript: "GetPlatform()"; "OverrideMouseIconBehavior" prop.
- **Security::None**: GetLastInputType/LastInputTypeChanged; read-only TouchEnabled/KeyboardEnabled/MouseEnabled/GamepadEnabled; ModalEnabled prop (SCRIPTING cap); JumpRequest event ("todo: Remove"); gestures TouchTap/TouchPinch/TouchSwipe/TouchLongPress/TouchRotate/TouchPan; lazy-signal events TouchStarted/Moved/Ended + InputBegan/InputChanged/InputEnded (getOrCreate* routes to CORE variants when caller has RobloxScript permission — dual-channel design); TextBoxFocused/TextBoxFocusReleased/GetFocusedTextBox (flag-gated); WindowFocused/WindowFocusReleased; MouseIconEnabled + MouseBehavior props; GetKeysPressed/IsKeyDown; DeviceAccelerationChanged/DeviceGravityChanged/DeviceRotationChanged (+GetDeviceAcceleration/Gravity/Rotation) with local-script-only connect guards and sensor warnings; AccelerometerEnabled/GyroscopeEnabled read-only; full gamepad surface GetConnectedGamepads/GetGamepadConnected/GamepadConnected/**GamepadDisconnected bound to gamepadDisconnectedSignal and GamepadConnected bound to gamepadConnectedSignal — THE TWO EVENT NAMES ARE CROSSED relative to their signals in source** /GetGamepadState/GamepadSupports/GetSupportedGamepadKeyCodes/Get-SetNavigationGamepad(s); VR: deprecated IsVREnabled/UserHeadCFrame, VREnabled, RecenterUserHeadCFrame, GetUserCFrame(UserCFrame), UserCFrameChanged.

Input pipeline:
- Platform threads → fireInputEvent: BEGIN/END always queued; CHANGE coalesced per type (touches per-pair, mouse movement MERGES deltas+positions into a single reused mouseEventObject); every event also fireLegacyMouseEvent translating touch BEGIN/END→fake MouseBUTTON1, CHANGE→fake MOUSEMOVEMENT (sourceUserInputType=TOUCH retained).
- onRenderStep: updateInputSignal → processInputObjects (begin/change/end queues via processInputVector under InputEventsMutex; DrawTouchEvents debug squares parented into CoreGui RobloxGui) → processKeyboardEvents → processGestures (gui-inset-corrected positions; CoreGui then PlayerGui processing decides gameProcessedEvent/sunk) → processMotionEvents → processToolEvents → processCameraInternal → processTextboxInternal (synthesizes RETURN key InputObject for enter-completions) → JumpRequest flush → cleanupCurrentTouches → LockCenter cursor recentering.
- doDataModelProcessInput: DataModel::processInputObject (GUI sink chain), processedMouseEvent, processedEventSignal, then signalInputEventOnService fanning to core* always and gameplay *Events only when menu closed.
- Keyboard: setKeyState queued cross-thread; newKeyState map of persistent InputObjects; CAPSLOCK toggles capsLocked; getModifiedKey implements shift/caps XOR casing plus full US shift-symbol table; IsUsingNewKeyboardEvents true only on UWP.

Movement/camera: moveLocalCharacter(Lua variant applies immediately vs internal deferred), jumpLocalCharacter(+JumpRequest), rotateCamera clamps pan x±100 accumulating for processCameraInternal (skipped under CUSTOM_CAMERA with local player or Lua-camera flag; FlyCamOnRenderStep adds nav-key fly for characterless/cloud-edit sessions).

Mouse: MouseBehavior setters drive wrap mode + centering; canUseMouseLockCenter requires workspace without modal guis and !Profiler capturing; icon STACK (push/pop/erase-specific) with getCurrentMouseIcon top-of-stack; getDefaultMouseCursor picks Arrow vs Gamepad Pointer by lastInputType.

Gamepads: connectedGamepadsMap TYPE_GAMEPAD1..8; setConnectedGamepad auto-flips gamepadEnabled when any connected; safeFire* submit DataModel Write tasks; getSupportedGamepadKeyCodes uses request/response SIGNAL with SDLGameController (synchronous signal round-trip pattern).

Statics: isStudioEmulatingMobile (getTouchEnabled ORs it); DrawTouchEvents debug.

## Usage / reflection touchpoints

The primary script input API. Consumers everywhere: TextBox.md, ScrollingFrame.md, PlayerGui.md, ToolMouseCommand.md, TouchInputService.md, GamepadService.md in this folder; [Base/rbx/Profiler.cpp.md](../../Base/rbx/Profiler.cpp.md) mouse-capture check.

## Gotchas

- GamepadConnected/GamepadDisconnected descriptors are wired CROSSWISE to their signals (event_GamepadConnected ↔ gamepadDisconnectedSignal variable and vice versa at lines 248-249) — the Lua names end up correct only because both directions are swapped consistently; touching one breaks both.
- getInputBeganEvent etc. choose signal by CALLER SECURITY at connect time — a plugin's connections land on the core channel and keep receiving during menus while gameplay scripts starve.
- currentMousePosition starts at (−10000,−10000) until first real movement.
- The changed-event mouse merge mutates a SHARED InputObject across frames — handlers retaining references see later frames' data.
- GetFocusedTextBox errors-and-returns-null unless its DFFlag is enabled (same crippling pattern as TextBox:IsFocused).
- UNKNOWN: processedMouseEvent native half; Profiler::isCapturingMouseInput semantics.
