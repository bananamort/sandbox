# SharedLauncher.h

Source: `roblox-sandbox/Win/SharedLauncher.h` (69 lines)

## Purpose

Declares the shared browser-plugin/client launch contract: the canonical command-line argument names (`-fileLocation`, `-script`, `-url`, `-ticket`, `-startEvent`, `-readyEvent`, `-showEvent`, `-testMode`, `-ide`, `-build`, `-debugger`, `-avatar`, `-rbxdev`, `-browserTrackerId`), the `LaunchMode` enum (`Play`, `Play_Protocol`, `Build`, `Edit`), the registry-driven spawn/update/version APIs used by the out-of-tree browser COM host, and the `EditArgs` struct + helpers for marshaling a Studio edit-mode command line. The launcher-started event name constant `rbxLauncherStarted` is defined here too.

## API

```cpp
#define LAUNCHER_STARTED_EVENT_NAME _T("rbxLauncherStarted")

namespace SharedLauncher {
    static const char* FileLocationArgument / ScriptArgument / AuthUrlArgument / AuthTicketArgument /
        StartEventArgument / ReadyEventArgument / ShowEventArgument / TestModeArgument / IDEArgument /
        BuildArgument / DebuggerArgument / AvatarModeArgument / RbxDevArgument / BrowserTrackerId;

    enum LaunchMode { Play, Play_Protocol, Build, Edit };

#if defined(_WIN32) && !defined(RBX_PLATFORM_DURANGO)
    CRegKey GetKey(CString& out_operation, bool isStudioKey, bool is64bits = false);
    HRESULT PreStartGame(const CLSID& clsid);
    __declspec(dllexport) HRESULT StartGame(simple_logger<wchar_t>&, BSTR authenTicket, BSTR authenticationUrl,
        BSTR script, const CLSID&, bool silentMode, TCHAR* guidName, bool startInHiddenMode,
        TCHAR* unhideEventName, LaunchMode);
    HRESULT StartGame(simple_logger<char>&, ...);            // narrow-logger overload
    HRESULT get_InstallHost(BSTR* pVal, const CLSID& clsid);
    HRESULT get_Version(BSTR* pVal, const CLSID& clsid);
    HRESULT get_IsUpToDate(simple_logger<wchar_t>&, VARIANT_BOOL*, CProcessInformation&, const CLSID&);
    HRESULT Update(const CLSID& clsid);
#endif

    struct EditArgs { fileName; authUrl; authTicket; script; readyEvent; showEventName; launchMode; avatarMode; browserTrackerId; };
    std::wstring generateEditCommandLine(const EditArgs&);
    bool parseEditCommandArg(wchar_t** args, int& index, int count, EditArgs&);
}
```

## Usage

In-tree consumers use ONLY the constants and `LaunchMode` enum: WindowsClient/Application.{h,cpp} and Document.{h,cpp} carry a `SharedLauncher::LaunchMode`, Network/GameConfigurer.cpp branches on `Play` vs `Play_Protocol`. The COM-facing functions (`StartGame` — explicitly `dllexport`ed — plus `PreStartGame`/`Update`/`get_*`) have no callers inside this tree; they are the entry points for the browser plugin host that ships separately.

## Gotchas

- Everything except `LaunchMode`/constants/`EditArgs` helpers is compiled only for Win32-non-Durango.
- The header drags ATL (`atlutil.h`) and ProcessInformation.h into every includer on that platform.
