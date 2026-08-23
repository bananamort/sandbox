# WindowsClient/main.cpp

## Purpose

Entry point of the 2016 Windows game client (`RobloxPlayerBeta.exe` / `RobloxPlayerBetaRaw.exe`). Defines `_tWinMain`, the `WndProc` for the single top-level window, and the window-class registration. Owns the outermost lifecycle: SSE2 gate → Application construction → AppSettings.xml + command line → remote ClientAppSettings fetch (before window creation) → window creation → `Application::Initialize` → message pump → VMProtect section un-protect → shutdown. This is the shell the sandbox harness drives; every join begins inside `_tWinMain`.

## API

- `int APIENTRY _tWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPTSTR lpCmdLine, int nCmdShow)` — exact startup order:
  1. `G3D::System::hasSSE2()` check; MessageBoxA + return false if missing ("This platform lacks SSE2 support."). Deliberately first because the build is compiled with `/arch:SSE2` and any float math before this can fault.
  2. `RBX::Application app;` on the stack (ctor spawns the log-cleanup thread); sets file-scope global `RBX::Application* appPtr`.
  3. `CComModule comModule;` — required for ActiveX hosting of IWebBrowser2 (RbxWebView/WebBrowserAxDialog).
  4. `app.LoadAppSettings(hInstance)` — parses sibling `AppSettings.xml`, sets BaseUrl etc.; returns FALSE (exit) on failure.
  5. `app.ParseArguments(lpCmdLine)` — boost::program_options over `split_winmain`; returns FALSE for help/version/API/dmp/magic `-w` modes.
  6. **Client settings before window**: `FetchClientSettingsData(CLIENT_APP_SETTINGS_STRING, CLIENT_SETTINGS_API_KEY, &clientSettingsString)` then `LoadClientSettingsFromString(CLIENT_APP_SETTINGS_STRING, clientSettingsString, &RBX::ClientAppSettings::singleton())`. Both functions are defined outside this module (UNKNOWN implementation location in this snapshot; likely ClientShared settings infrastructure). This is a network fetch that happens before any window exists.
  7. `LoadString(IDS_APP_TITLE / IDC_WINDOWSCLIENT)`, `RegisterWindowClass(hInstance)` (WNDCLASSEX: CS_HREDRAW|CS_VREDRAW, menu IDC_WINDOWSCLIENT, icon IDI_WINDOW_ICON).
  8. `CreateWindow(szWindowClass, szTitle, WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, 800, 600, ...)`; NULL check.
  9. `app.Initialize(hWnd, hInstance)` inside try/catch of `RBX::initialization_error`: error path does FASTLOGS(RobloxWndInit), MessageBoxA(e.what()), `app.AboutToShutdown(); app.Shutdown(); return FALSE`. Returning false from Initialize also exits.
  10. `SetTimer(hWnd, NULL, 10*1000, NULL)` — 10 s keep-alive timer for hang detection.
  11. `ShowWindow(hWnd, SW_HIDE); UpdateWindow(hWnd);` — **the window is always created hidden**; visibility is later granted by `View::ShowWindow()` from a background thread (video pre-roll / `--waitEvent` gating). nCmdShow is ignored.
  12. Standard `GetMessage/TranslateMessage/DispatchMessage` loop. `WM_TIMER` calls `MainLogManager::NotifyFGThreadAlive()` (LOGGROUP HangDetection) proving the UI thread is alive.
  13. After the pump exits (WM_DESTROY → PostQuitMessage): `VirtualProtect(RBX::Security::rbxVmpBase, RBX::Security::rbxVmpSize, PAGE_EXECUTE_READWRITE, &unused)` — re-enables write/execute on the `.vmp0/.vmp1` region that `protectVmpSections()` de-RWX'd at startup, so shutdown-time security code can still run/write.
  14. `app.Shutdown()`; returns `(int)msg.wParam`.

- `LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)` — dispatch table: WM_TIMER→hang-detect ping; WM_COMMAND `ID_UPLOADSESSIONLOGS`→`appPtr->UploadSessionLogs()`, `ID_LOADWIKI`→`appPtr->OnHelp()` (accelerators F1 / Shift+F8 land here); WM_GETMINMAXINFO→static `RBX::Application::OnGetMinMaxInfo`; WM_KEYDOWN/MOUSEMOVE/MOUSELEAVE/MOUSEWHEEL/SETFOCUS/KILLFOCUS/ACTIVATE/ACTIVATEAPP/CHAR/INPUT→`appPtr->HandleWindowsMessage(...)`; WM_DESTROY→`appPtr->AboutToShutdown(); PostQuitMessage(0)`; WM_SIZE→`appPtr->OnResize(wParam, LOWORD(lParam), HIWORD(lParam))`; default DefWindowProc.
- `ATOM RegisterWindowClass(HINSTANCE hInstance)` — registers class name loaded from IDC_WINDOWSCLIENT string resource ("WINDOWSCLIENT").
- Globals: `TCHAR szWindowClass[MAX_LOADSTRING]`, `RBX::Application* appPtr`. LOGGROUPs: `HangDetection`, `RobloxWndInit`.

## Usage

Harness interception points, in order: step 4 (command line — `--id`, auth triple, magic `-w` patcher modes), step 6 (settings fetch — stub to control all FastInt/FastFlag client settings without network), step 9 (`Initialize` — where HTTP joins happen), the named Win32 event `www.roblox.com/robloxStartedEvent` set by Initialize/waitForShowWindow (bootstrapper sync), and the hidden-until-ready window behavior.

## Gotchas

- The main window is never shown from `_tWinMain` (`SW_HIDE` unconditionally); if `Application::Initialize` fails after CreateWindow, you get an invisible process.
- `appPtr` is a raw global used by WndProc; valid for the lifetime of the stack `app` object only.
- `WM_COMMAND` arrives with accelerator IDs 33042/40002 (see WindowsClient.rc) routed through UserInput's whitelist (F1/F8/F11/SNAPSHOT only).
- The final `VirtualProtect` depends on `rbxVmpBase/rbxVmpSize` having been filled by ReleasePatcher/Security code; values are UNKNOWN when running an unpatched Raw exe.
- `hPrevInstance`, `nCmdShow` unused; `MAX_LOADSTRING`=100 caps title/class length.
