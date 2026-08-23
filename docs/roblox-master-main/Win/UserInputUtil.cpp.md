# UserInputUtil.cpp

Source: `roblox-sandbox/Win/UserInputUtil.cpp` (622 lines)

## Purpose

Implements UserInputUtil: three lazily-initialized 256/`SDLK_LAST`-slot lookup tables (DIK→KeyCode, KeyCode→DIK, KeyCode→VK), Win32 WM_ message mapping, modifier extraction (shifts/ctrls/alts via DI key array + caps-lock via `GetKeyState(VK_CAPITAL)`), DirectInput mouse-object decoding, and the cursor-wrap strategies that keep a hidden OS pointer logically inside game coordinates — border ratchet with "creep", fullscreen clamp, center-accumulate, and the hybrid gamepad-right-stick emulation with sensitivity/tug tuning constants.

## API

```cpp
const float UserInputUtil::HybridSensitivity = 15.0f;
const float UserInputUtil::MouseTug = 20.0f;

bool UserInputUtil::isCtrlDown(RBX::ModCode modCode);
void UserInputUtil::wrapFullScreen(delta, wrapDelta, wrapPos, windowSize);   // Y pegged, X clamped
void UserInputUtil::wrapMouseHorizontalTransition(...);   // borderTransition then zero Y delta
static void UserInputUtil::wrapMouseBorder(delta, wrapDelta, wrapPos, windowSize, borderWidth, creepFactor);
    // Rect(-halfSize,halfSize).inset(border) union old pos → ratchet; delta overflow * creepFactor added to pos
void UserInputUtil::wrapMouseBorderLock(...);      // borderWidth 6, creep 0.0f
void UserInputUtil::wrapMouseBorderTransition(...);// borderWidth 20, creep 0.05f
void UserInputUtil::wrapMouseNone(delta, wrapDelta, wrapPos);      // pos += delta; delta = 0
void UserInputUtil::wrapMouseCenter(delta, wrapDelta, wrapPos);    // wrapDelta += delta only
static void UserInputUtil::wrapMousePos(delta, wrapDelta, wrapPos, windowSize, posToWrapTo, autoMoveMouse);
    // hybrid stick: windowDelta*HybridSensitivity; posToWrapTo decays by *0.266f; MouseTug pulls toward axis
void UserInputUtil::wrapMouseHorizontalCenter(delta, wrapDelta, wrapPos);  // x-only accumulate

G3D::Vector2 UserInputUtil::didodToVector2(const DIDEVICEOBJECTDATA& didod); // DIMOFS_X→x else y
RBX::KeyCode UserInputUtil::directInputToKeyCode(DWORD diKey);  // static table, unknown → SDLK_UNKNOWN
DWORD UserInputUtil::keyCodeToDirectInput(RBX::KeyCode keyCode);
DWORD UserInputUtil::keyCodeToVK(RBX::KeyCode keyCode);
RBX::InputObject::UserInputState UserInputUtil::msgToEventState(UINT uMsg);  // MOVE/BEGIN/END/NONE
RBX::InputObject::UserInputType UserInputUtil::msgToEventType(UINT uMsg);    // MOUSEMOVEMENT/BUTTON1/BUTTON2/NONE
RBX::ModCode UserInputUtil::createModCode(const DiKeys& diKeys);             // KMOD_* bitmask
```

## Usage

All call sites are in WindowsClient/UserInput.cpp: keyboard path polls `diKeys[]`, builds mod codes and KeyCodes (`createModCode`, `directInputToKeyCode`, line ~494–495), synthesizes VK for OS calls (~504); mouse path converts DIDEVICEOBJECTDATA deltas (~675) and selects wrap strategy per input mode (~973–1003: Center / Pos(hybrid) / BorderLock(dragging) / FullScreen / None). `isCtrlDown` used with returned mod codes.

## Gotchas

- `createModCode` checks `DIK_LMENU` TWICE — the second branch ORs `KMOD_RALT` when LEFT alt is down (lines 607–610 duplicate line 603–606's condition). Right-alt is never detected.
- Reverse map quirk: `keymap[SDLK_BACKSLASH]` is assigned twice (DIK_BACKSLASH then DIK_OEM_102 overwrites, lines 398–399) so backslash always maps to OEM_102 in the reverse direction while forward maps both DIK codes to SDLK_BACKSLASH.
- `directInputToKeyCode` maps DIK_KANJI→BACKQUOTE ("weird key mapping...." per in-source comment) and DIK_PREVTRACK→EQUALS.
- All three tables are function-local `static` guarded by an explicit `static bool initialized` flag (not C++11 magic statics) — first-use initialization is not thread-safe; benign because the input path initializes them from a single thread early.
- `keyCodeToVK` maps both SDL KP_ENTER and RETURN to VK_RETURN; PRINT→VK_PRINT is non-standard (VK_PRINT isn't a real VK constant in winuser.h unless defined by the project).
