# WindowsClient/UserInput.h

## Purpose

Declares `RBX::UserInput` — the DirectInput8-based keyboard/mouse frontend that translates Win32 messages and DI buffered data into engine `InputObject` events fired through `UserInputService`. Owns device acquisition policy (foreground/non-exclusive, acquire-on-hover, invisible-cursor capture), the accelerator whitelist, and an SDL game-controller bridge. Implements `UserInputBase`.

## API

Key declarations:

```cpp
class RobloxCriticalSection { int callers; std::string recentCaller, olderCaller;
                              ATL::CCriticalSection diSection; };

class UserInput : public UserInputBase {
    enum MouseButtonType { MBUTTON_LEFT=0, MBUTTON_RIGHT=1, MBUTTON_MIDDLE=2 };
    rbx::signals::scoped_connection steppedConnection;   // RunService::earlyRenderSignal
    // state: isMouseCaptured, wrapMousePosition, wrapping, rightMouseDown,
    //        autoMouseMove, mouseButtonSwap, BYTE diKeys[256],
    //        externallyForcedKeyDown, HKL layout, BYTE keyboardState[256],
    //        std::vector<ACCEL> accelerators, CComPtr<IDirectInput8> diPtr,
    //        CComPtr<IDirectInputDevice8> diMousePtr/diKeyboardPtr,
    //        boost::unordered_map<UserInputType, shared_ptr<InputObject>> inputObjectMap,
    //        shared_ptr<SDLGameController> sdlGameController,
    //        shared_ptr<RunService> runService, View* parentView, ...
public:
    shared_ptr<RBX::Game> game;
    const static int WM_CALL_SETFOCUS = WM_USER + 187;
    HCURSOR hInvisibleCursor;
    /*implement*/ Vector2 getCursorPosition();
    /*implement*/ bool keyDown(KeyCode code) const;
    /*implement*/ void setKeyState(KeyCode, ModCode, char modifiedKey, bool isDown);
    /*implement*/ void centerCursor();
    /*override*/ TextureProxyBaseRef getGameCursor(Adorn* adorn);
    void postUserInputMessage(UINT uMsg, WPARAM wParam, LPARAM lParam);
    void processUserInputMessage(UINT uMsg, WPARAM wParam, LPARAM lParam); // needs DataModel lock
    UserInput(HWND wnd, shared_ptr<RBX::Game> game, View* view);
    ~UserInput();
    void setGame(shared_ptr<RBX::Game> game);
    void setKeyboardDesired(bool set);
    void onMouseInside(); void onMouseLeave();
    bool getIsKeyboardAcquired() const; bool getIsMouseAcquired() const;
    void reacquireKeyboard(); void processInput();
};
```

Private machinery: createMouse/createKeyboard/createAccelerators, update/acquire/unacquire pairs, readBufferedData/readBufferedMouseData/readBufferedKeyboardData, doWrapMouse, doWrapHybrid ("todo: no longer used remove this"), cursor position internals, doDiagnostics.

## Usage

Constructed by `View::initializeInput()` (`new UserInput(GetHWnd(), game, this)` under a DataModel write lock, then handed to ControllerService as hardware device). See UserInput.cpp.md.

## Gotchas

- `#pragma comment(lib, ...)` for dxguid/dxerr9/dinput8 — DirectX SDK link deps live here.
- Includes "SDLGameController.h" — resolves to ClientShared/SDLGameController.h in this tree (UNKNOWN original location pre-prune).
