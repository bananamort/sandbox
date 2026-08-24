# VirtualUser.cpp

## Purpose

Implements `VirtualUser` ("VirtualUser"), the test-automation input injector: synthesizes mouse/keyboard events through a `VirtualHardwareDevice` swapped into ControllerService (replacing real hardware), optionally overriding the camera per event, and can RECORD live input into replayable Lua source using itself as the playback API.

## Key types and API

Descriptors (ALL **Security::TestLocalUser**):
- "ClickButton1(position, camera=identity)", "Button1Down", "Button1Up", "ClickButton2", "Button2Down", "Button2Up", "MoveMouse" — position is NORMALIZED (−1..1, y up), converted to a fixed 800×600 virtual screen (y flipped).
- "StartRecording()", yield "StopRecording():string", "CaptureController()".
- "TypeKey(key:string)" (Lua name) → pressKey; "SetKeyDown(key)", "SetKeyUp(key)".

VirtualHardwareDevice (internal UserInputBase): 512-entry keyDown bool array, 800×600 virtual screen, centerCursor to (400,300), no-op cursor rendering.

Mechanics:
- `captureInputDevice()`: one-time swap of ControllerService's hardware device; onServiceProvider restores NULL + drops the virtual device.
- `sendMouseEvent`: clamps normalized position, sets device cursor + forces workspace camera viewport to 800×600, optionally SETS THE CAMERA CF from the argument before processing (commented-out restore — camera override STICKS), then DataModel::processInputObject directly.
- Key conversion: "0x.." hex, exactly-3-char decimal, else single character; anything else throws "Unsupported key %s".
- Recording: StartRecording hooks DataModel::InputObjectProcessed; writes Lua preamble (GetService('VirtualUser') + CaptureController); each event emits wait(delta) then SetKeyDown/SetKeUp [SIC — typo'd function name in generated code] or Button1Down/Button1Up with normalized Vector2 + CFrame.new(pos + quat xyzw); StopRecording returns the buffer.
- setKeyDown/Up skip when state already matches (no duplicate events).

## Usage / reflection touchpoints

Test-harness surface at TestLocalUser security. Pairs with UserController.md (device injection point), UserInputService.md, Mouse.md in this folder.

## Gotchas

- Generated recording code calls `SetKeUp` which DOESN'T EXIST ("SetKeyUp") — recorded scripts fail on key release unless hand-fixed.
- Camera override persists after synthetic events (restore commented out) — automation silently repositions the camera.
- Viewport forced to 800×600 on every mouse event regardless of actual window.
- Recording captures only keyboard + left button; right button/moves unrecorded.
