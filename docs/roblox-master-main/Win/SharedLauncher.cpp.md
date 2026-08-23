# SharedLauncher.cpp

Source: `roblox-sandbox/Win/SharedLauncher.cpp` (631 lines)

## Purpose

Implements the browser-plugin launch pipeline: registry-based install discovery (`GetKey`/`loadRobloxPath` over `HKCU|HKLM\Software\RobloxReg` ("RobloxReg" — deliberately not "Roblox", which belongs to the legacy installer — or "StudioQTRobloxReg" for Studio), ticket re-negotiation via WinINet (`authenticate`, user agent `"RobloxProxy"`, `RBXAuthenticationNegotiation:` header, Vista+ only), process spawning (`launchRoblox` via CreateProcess + CProcessInformation), Studio/player command-line assembly, and the up-to-date/version/update COM surface.

## API

```cpp
static void CheckResult(HRESULT);                       // AtlThrow on failure
CRegKey GetKey(CString& out_operation, bool isStudioKey, bool is64bits = false);
    // KEY_READ | KEY_WOW64_32/64; HKCU first only when (!IsVistaPlus() || !IsElevated()), then HKLM fallback (AtlThrow on fail)
class CHINTERNET { ... };                               // RAII HINTERNET closer (assignment closes previous)
static bool IsRunningVistaIE();                         // GetVersionEx major >= 6
static CString authenticate(BSTR authenticationUrl);    // GET w/ RBXAuthenticationNegotiation header; 200 + non-empty body → ticket; else ""
static ATL::CPath loadRobloxPath(CString&, bool isStudio);   // default (NULL) registry value = install path
static void launchRoblox(TCHAR cmd[2048]);              // CreateProcess NORMAL_PRIORITY_CLASS
template<class CHARTYPE> HRESULT StartGame(...);        // full launch: authenticate-if-empty-ticket → resolve path
    // → studio-missing fallback to player+Play mode → force Edit/Build→Build → build cmd → launchRoblox; AtlReportError on failure
HRESULT StartGame(narrow / wide logger overloads);      // forward to the template
HRESULT PreStartGame(const CLSID&);                     // UNICODE: "<path>" -prePlay ; ANSI: "<path>" -install
HRESULT get_InstallHost(BSTR*, const CLSID&);           // reg value "install host"
HRESULT get_Version(BSTR*, const CLSID&);               // reg value "Plug-in version"; "-1" when empty/error; always S_OK
HRESULT Update(const CLSID&);                           // spawn "<path>" -install
HRESULT get_IsUpToDate(simple_logger<wchar_t>&, VARIANT_BOOL*, CProcessInformation&, const CLSID&);
    // spawn "<path>" -failIfNotUpToDate unless handle already InUse; 1000 ms wait; exit code 0 ⇒ VARIANT_TRUE
std::wstring generateEditCommandLine(const EditArgs&);  // space-joined "-flag value" pairs (platform-independent)
bool parseEditCommandArg(wchar_t**, int&, int, EditArgs&); // mirror parser for the client side
```

## Usage

The COM-facing entry points are consumed by the out-of-tree browser plugin host (StartGame is `__declspec(dllexport)`); inside this tree only `LaunchMode` and the argument constants are used (WindowsClient, Network/GameConfigurer). `generateEditCommandLine`/`parseEditCommandArg` form a writer/parser pair spanning launcher and client processes.

## Gotchas

- `authenticate` reads the ticket into `TCHAR ticket[2048]` then writes `ticket[bytesRead] = 0` with bytesRead up to 2048 — a 1-byte stack overflow when the response fills the buffer exactly.
- After `launchMode = Build` is forced (~line 237), the very next conditionals `editArgs.launchMode = launchMode == Build ? BuildArgument : IDEArgument` and the avatar-mode ternary are dead — always BuildArgument / AvatarModeArgument.
- Play-mode command line interpolates raw BSTRs (script/url/ticket) without quoting or escaping — spaces in any of them corrupt the argument list.
- `PreStartGame` launches `-prePlay` under UNICODE but `-install` under ANSI — an inconsistency between character-set builds.
- `generateEditCommandLine` can emit `-browserTrackerId`, but `parseEditCommandArg` has no branch for it (nor `-testMode`), so the round trip silently fails to parse that argument.
- `get_IsUpToDate` treats any non-zero exit code as "not up to date", including crash exit codes.
