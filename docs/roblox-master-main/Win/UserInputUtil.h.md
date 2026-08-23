# UserInputUtil.h

Source: `roblox-sandbox/Win/UserInputUtil.h` (73 lines)

## Purpose

Declares `UserInputUtil`, a static-only toolkit for the Windows mouse/keyboard path: DirectInput↔engine KeyCode translation tables, Win32 mouse-message → InputObject state/type mapping, modifier-key extraction from a 256-byte DirectInput key array, DIDEVICEOBJECTDATA → Vector2 deltas, and the family of "wrapMouse*" cursor-confinement strategies (none, center, fullscreen, border lock, transitions, hybrid gamepad-mouse).

## API

```cpp
#define DIRECTINPUT_VERSION 0x0800
#include <dinput.h>

class UserInputUtil {
public:
    typedef BYTE DiKeys[256];
    static const float HybridSensitivity;   // 15.0f
    static const float MouseTug;            // 20.0f

    static RBX::ModCode createModCode(const DiKeys& diKeys);
    static RBX::InputObject::UserInputState msgToEventState(UINT uMsg);
    static RBX::InputObject::UserInputType  msgToEventType(UINT uMsg);
    static DWORD keyCodeToDirectInput(RBX::KeyCode keyCode);
    static RBX::KeyCode directInputToKeyCode(DWORD diKey);
    static DWORD keyCodeToVK(RBX::KeyCode diKey);
    static G3D::Vector2 didodToVector2(const DIDEVICEOBJECTDATA& didod);
    static bool isCtrlDown(RBX::ModCode modCode);

    static void wrapMouseNone(const Vector2& delta, Vector2& wrapDelta, Vector2& wrapPos);
    static void wrapFullScreen(const Vector2& delta, Vector2&, Vector2&, const Vector2& windowSize);
    static void wrapMouseHorizontalTransition(const Vector2&, Vector2&, Vector2&, const Vector2&);
    static void wrapMouseBorderLock(const Vector2&, Vector2&, Vector2&, const Vector2&);
    static void wrapMouseBorderTransition(const Vector2&, Vector2&, Vector2&, const Vector2&);
    static void wrapMouseCenter(const Vector2&, Vector2&, Vector2&);
    static void wrapMouseHorizontalCenter(const Vector2&, Vector2&, Vector2&);
private:
    static void wrapMouseBorder(const Vector2& delta, Vector2&, Vector2&, const Vector2&,
                                const int borderWidth, const float creepFactor);
    static void wrapMousePos(const Vector2& delta, Vector2&, Vector2&, const Vector2&,
                             Vector2& posToWrapTo, bool autoMoveMouse);
};
```

## Usage

Consumed solely by WindowsClient: `WindowsClient/UserInput.h` includes it and `WindowsClient/UserInput.cpp` drives every entry point — message pump (`msgToEventType/State`), keyboard polling (`createModCode`, `directInputToKeyCode`, `keyCodeToVK`, `keyCodeToDirectInput`), mouse deltas (`didodToVector2`), and per-mode cursor wrapping selected at lines ~973–1003. Listed in WindowsClient.vcxproj as `..\Win\UserInputUtil.h`.

## Gotchas

- Sets `DIRECTINPUT_VERSION 0x0800` before including dinput.h — pulls the vendored `Win/dinput.h` copy into every includer's TU.
- The wrap* contract is in/out triads (delta, wrapMouseDelta, wrapMousePosition) with window coordinates centered at origin (half-extent clamping); callers must keep those vectors in that space or the border math misbehaves.
