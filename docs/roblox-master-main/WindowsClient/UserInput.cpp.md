# WindowsClient/UserInput.cpp

## Purpose

DirectInput8 input pipeline. Two event sources merge here: (1) Win32 messages relayed from WndProc → View::HandleWindowsMessage → `postUserInputMessage` (unacquired-mode mouse moves/wheel, focus events); (2) buffered DirectInput data pumped every frame by `processInput()` — connected to `RunService::earlyRenderSignal` — producing InputObject events for UserInputService. Also owns the accelerator whitelist ("brute-force attempt to prevent back-doors": only F1/F8/F11/PrtScn plus Alt+F4 pass; everything else is suppressed before WM_COMMAND translation), mouse-wrap/camera-pan policy, and the invisible-cursor swap via the bundled `InvisibleCursor.cur` (IDR_INVISIBLECURSOR).

## API

Real signatures:

- `UserInput(HWND wnd, shared_ptr<Game> game, View* view)` — inits flags; debug builds use IDC_CROSS for both cursors, release loads `hArrow = LoadCursor(NULL, IDC_ARROW)` and `hInvisibleCursor = LoadCursor(GetModuleHandle(NULL), MAKEINTRESOURCE(IDR_INVISIBLECURSOR))`; `setGame(game)`; `DirectInput8Create(...)` with MessageBoxA failure "ROBLOX could not initialize input. Please make sure you have a mouse and keyboard plugged in."; reads `HKCU\Control Panel\Mouse` value `SwapMouseButtons` into mouseButtonSwap (comment: "ERROR_SUCCESS? Really, Microsoft?"); createMouse/createKeyboard/createAccelerators; `layout = GetKeyboardLayout(0)`.
- `void setGame(shared_ptr<Game>)` — creates RunService provider, `new SDLGameController(dataModel)`, connects `runService->earlyRenderSignal` → processInput.
- `~UserInput()` — resets controller, Unacquires and releases DI devices.
- `void createMouse()/createKeyboard()` — `CreateDevice(GUID_SysMouse|GUID_SysKeyboard)`, data format c_dfDIMouse2 / c_dfDIKeyboard, buffer size DIPROP_BUFFERSIZE = RBX_DI_BUFFER_SIZE (**2048**, free function `getDiProp(DIPROPDWORD&)`); each failure its own MessageBoxA.
- `void createAccelerators()` — `LoadAccelerators(IDR_GAME_ACCELERATOR)` + `CopyAcceleratorTable` snapshot into `accelerators`.
- `void processInput()` — under RobloxCritSecLoc: updateKeyboard(); if mouse acquired readBufferedMouseData(); `diKeyboardPtr->GetDeviceState(256, diKeys)`; if keyboard acquired readBufferedKeyboardData().
- `bool readBufferedData(LPDIDEVICEOBJECTDATA didod, DWORD& dwElements, IDirectInputDevice8* device)` — GetDeviceData wrapper; DI_BUFFEROVERFLOW logs "Keyboard/Mouse DI_BUFFEROVERFLOW!" but returns true; loss returns false ⇒ caller drops acquisition flag.
- `void readBufferedKeyboardData()` — per event: dwOfs→DI code, `(dwData & 0x80)` = down; modCode via `UserInputUtil::createModCode(diKeys)`; vKey = MapVirtualKeyEx(diKey,1,layout) fallback keyCodeToVK. **Whitelist**: VK_F4+Alt → `PostMessage(wnd, WM_CLOSE, 0, 0)` + continue (in-game Alt-F4 exit); VK_F1/VK_F8/VK_F11/VK_SNAPSHOT allowed; default suppress=true. Non-suppressed keys match the ACCEL table (FVIRTKEY vs char) and re-post as `WM_COMMAND (0x10000 | cmd)` (IDs 33042/40002 land in main.cpp WndProc). Every key then: GetKeyboardState + ToAsciiEx layout resolution, `UserInputService::getModifiedKey`, `userInputService->setKeyState(...)`, and an InputObject TYPE_KEYBOARD BEGIN/END through sendEvent.
- `void processMouseButtonEvent(DIDEVICEOBJECTDATA, MouseButtonType, bool& leftMouseUp)` — swaps L/R when mouseButtonSwap; every button posts `WM_CALL_SETFOCUS` (`WM_USER+187`) to wnd; dwData==0x80 means pressed; tracks leftMouseButtonDown/rightMouseDown/autoMouseMove.
- `void readBufferedMouseData()` — DIMOFS_BUTTON0/1/2 → buttons; DIMOFS_X/Y → delta × GameBasicSettings mouse sensitivity accumulated fractionally in previousCursorPosFraction (integer part consumed, remainder kept), doWrapMouse; DIMOFS_Z → wheel delta/WHEEL_DELTA as TYPE_MOUSEWHEEL. Ends with postProcessUserInput(cursorMoved, leftMouseUp, wrapMouseDelta, mouseDelta).
- `void postProcessUserInput(bool cursorMoved, bool leftMouseUp, Vector2 wrapMouseDelta, Vector2 mouseDelta)` — WRAP_HYBRID && !mouseOverGui → doWrapHybrid (EMPTY BODY — vestigial); mousepan mode toggles WRAP_CENTER/WRAP_AUTO by buttons; non-zero wrapMouseDelta drives `workspace->onWrapMouse(wrapMouseDelta)` unless `FFlag::UserAllCamerasInLua && camera->hasClientPlayer()` or CUSTOM_CAMERA, then fires TYPE_MOUSEDELTA + TYPE_MOUSEMOVEMENT; else-if cursorMoved fires MOUSEMOVEMENT per MouseDeltaWhenNotMouseLocked branch.
- `void doWrapMouse(const G3D::Vector2& delta, G3D::Vector2& wrapMouseDelta)` — switch on `UserInputService::getMouseWrapMode()`: WRAP_NONEANDCENTER intentionally falls through centerCursor() into NONE/CENTER → wrapMouseCenter; WRAP_HYBRID → wrapMousePos; WRAP_AUTO → borderLock while movement keys held or dragging, wrapFullScreen in fullscreen, else wrapMouseNone ("We no longer want mouse wrap and camera auto-pan at the horizontal window extents"). Then teleports the real cursor with SetCursorPos to the wrapped game position (ClientToScreen).
- Acquisition family: `updateMouse()` acquires iff isMouseInside; `acquireMouseInternalBase(const Vector2&)` — Unacquire "for good measure", `SetCooperativeLevel(DISCL_FOREGROUND|DISCL_NONEXCLUSIVE)`, Acquire, seed wrapMousePosition with `Math::expandVector2(pos - center, -10)` chatter filter, `SetClassLong(wnd, GCL_HCURSOR, hInvisibleCursor)`; `unAcquireMouse()` restores cursor position (expanded 10× to fight hysteresis) + hArrow. Keyboard mirror: setKeyboardDesired(set) → acquire/unAcquireKeyboard.
- Message path: `postUserInputMessage` samples `dataModel->mouseStats.osMouseMove` on WM_MOUSEMOVE then locks into `processUserInputMessage`: WM_MOUSEMOVE → onMouseInside (+ unacquired-position event + updateMouse retry); WM_MOUSELEAVE → onMouseLeave; WM_MOUSEWHEEL (unacquired) → wheel event; WM_SETFOCUS/WM_KILLFOCUS → setKeyboardDesiredInternal + TYPE_FOCUS BEGIN/END events.
- Small members: `getCursorPosition()` (locked; acquired ⇒ game cursor = windowRect.center()+wrapMousePosition, else GetCursorPos/ScreenToClient); `keyDown(KeyCode)` checks externallyForcedKeyDown then diKeys[keyCodeToDirectInput] & 0x80; `setKeyState` sets externallyForcedKeyDown (GUI-driven fake keys); `reacquireKeyboard()`; `getWindowRect()` honors `DFFlag::UserInputViewportSizeFixWindows` (camera viewport instead of GetClientRect); `getGameCursor` returns null texture when unacquired (OS cursor visible).
- Debug helper `class RobloxCritSecLoc` — ATL CCritSecLock + caller-tracking asserts ("Show THESE ASSERTS TO David/Erik - they imply multiple entry points"), compiled out unless __RBX_NOT_RELEASE.

## Usage

Per-frame flow: TaskScheduler → RenderJob/renderStep side-band earlyRenderSignal → processInput → buffered events → UserInputService.fireInputEvent → Lua/controls. Window-message flow: main WndProc forwards KEYDOWN/MOUSEMOVE/etc. via Application::HandleWindowsMessage → View::HandleWindowsMessage → postUserInputMessage.

## Gotchas

- The accelerator whitelist is a security boundary: arbitrary key combos never reach WM_COMMAND, so verbs are reachable ONLY via whitelisted keys (F1/F8/F11/SNAPSHOT) or Lua GUI paths.
- Alt+F4 inside the game posts WM_CLOSE directly — bypasses any quit confirmation.
- `doWrapHybrid` and `doDiagnostics` are dead (empty body / no callers in this file; doDiagnostics is private).
- WM_CALL_SETFOCUS (WM_USER+187) is posted constantly on mouse clicks; UNKNOWN where it is consumed in this module (not handled in View.cpp/main.cpp dispatch shown) — likely Document or legacy.
- RBX_DI_BUFFER_SIZE=2048 stack arrays of DIDEVICEOBJECTDATA (5 DWORD-sized members = 20 bytes on x86) per call ≈ 41 KB stack per device per frame.
- Sensitivity uses fractional accumulation; changing getMouseSensitivity mid-session leaves residue in previousCursorPosFraction.
