# VistaTools.h

Source: `roblox-sandbox/Win/VistaTools.h` (138 lines)

## Purpose

OS-version/UAC interrogation helpers plus a late-bound `VistaAPIs` shim: `IsVistaPlus/Is64BitWindows/GetElevationType/IsElevated/IsUacEnabled` (WinAbility Software's VistaTools v1.0, trimmed by Erik Cassel in 2008 to query-only), and class `VistaAPIs` which LoadLibrary's Shell32 to resolve `SHGetKnownFolderPath` at runtime for XP compatibility, also defining `FOLDERID_*` known-folder GUIDs and `KF_FLAG_CREATE` when the SDK lacks them.

## API

```cpp
bool IsVistaPlus();                                  // GetVersionEx: NT && dwMajorVersion >= 6
bool Is64BitWindows();                               // _WIN64 → true; else IsWow64Process sniff
void GetElevationType(__out TOKEN_ELEVATION_TYPE*);  // throws std::runtime_error on failure (Vista+ only)
bool IsElevated();                                   // TokenElevation query; throws on failure
bool IsUacEnabled();                                 // CRegKey open of HKLM\...\System\EnableLUA

class VistaAPIs {   // header-inline implementation
    VistaAPIs();     // LoadLibrary("Shell32.dll") + GetProcAddress("SHGetKnownFolderPath")
    ~VistaAPIs();    // FreeLibrary
    HRESULT SHGetKnownFolderPath(const GUID& rfid, DWORD dwFlags, HANDLE hToken, PWSTR* ppszPath);
    bool isVistaOrBetter();                          // duplicate of IsVistaPlus via GetVersionEx
};
// conditional DEFINE_KNOWN_FOLDER for FOLDERID_{LocalAppDataLow, LocalAppData, Programs, ProgramData}
// conditional #define KF_FLAG_CREATE 0x00008000
```

## Usage

`IsVistaPlus()` gates minidump richness in RobloxCrashReporter (Win/LogManager.cpp:200) and gates the elevation check in the bootstrapper (Win/SharedLauncher.cpp:37: `if (!IsVistaPlus() || !IsElevated())`); `VistaAPIs::isVistaOrBetter + SHGetKnownFolderPath` backs WindowsClient/Application.cpp's `logsCleanUpHelper` (line ~119), which resolves `FOLDERID_LocalAppDataLow\RbxLogs` for log cleanup (treating `E_NOTIMPL` as "not available"). Includes shlobj.h; the whole header is safe to include from any TU.

## Gotchas

- **Manifest lie under modern Windows**: `GetVersionEx` returns 6.2 regardless of actual OS once app manifests declare Win8.1/10 compatibility — IsVistaPlus/isVistaOrBetter can never distinguish Vista→10; fine for ">= Vista" gating, useless beyond it.
- `IsUacEnabled()` logic is inverted-looking but intentional: it reports TRUE when the EnableLUA key FAILS TO OPEN (FAILED(Open)), i.e., treats "key missing" as UAC enabled — it never reads the value.
- `GetElevationType/IsElevated` throw std::runtime_error instead of returning error codes (header comment block claims S_OK/E_FAIL semantics that the implementation doesn't follow).
- Asserts (`assert(IsVistaPlus())`) vanish in release — calling elevation queries on XP in release reads garbage instead of failing loudly.
