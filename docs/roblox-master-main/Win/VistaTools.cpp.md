# VistaTools.cpp

Source: `roblox-sandbox/Win/VistaTools.cpp` (166 lines)

## Purpose

Implements the query-only UAC/elevation helpers declared in VistaTools.h — WinAbility Software's "VistaTools.cxx v1.0" (Andrei Belogortseff, 2006) as trimmed by Erik Cassel in 2008 ("Removed most of the APIs Roblox doesn't. Query functions remain"). Per the original usage note, this .cpp is meant to be excluded from direct builds and compiled once via inclusion where `IMPLEMENT_VISTA_TOOLS` is defined, though in this tree it exists as a standalone TU.

## API

```cpp
bool IsVistaPlus();
    // GetVersionEx: VER_PLATFORM_WIN32_NT && dwMajorVersion >= 6
bool Is64BitWindows();
    // _WIN64 → true; _WIN32 → IsWow64Process(GetCurrentProcess()) sniff
void GetElevationType(__out TOKEN_ELEVATION_TYPE* ptet);
    // OpenProcessToken(TOKEN_QUERY) + GetTokenInformation(TokenElevationType)
    // throws std::runtime_error on either API failure
bool IsElevated();
    // TokenElevation → te.TokenIsElevated != 0; throws std::runtime_error on failure
bool IsUacEnabled();
    // return FAILED(CRegKey::Open(HKLM,
    //   "Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\System\\EnableLUA"))
```

## Usage

Consumed by Win/VistaTools callers verified under VistaTools.h.md: `IsVistaPlus()` in Win/LogManager.cpp (minidump richness) and Win/SharedLauncher.cpp (elevation gating before registry reads), plus the header-inline `VistaAPIs` class used by WindowsClient/Application.cpp.

## Gotchas

- `IsUacEnabled()` never reads a value: it appends `EnableLUA` to the KEY path (EnableLUA is a *value* under `...\Policies\System`, not a subkey), so the open normally fails and the function returns TRUE — i.e., it effectively answers "yes" everywhere modern.
- `GetElevationType`/`IsElevated` use `assert(IsVistaPlus())`, which vanishes in release; calling them pre-Vista reads uninitialized/garbage token data instead of failing loudly.
- Error handling contradicts the header's S_OK/E_FAIL comment block: failures are `std::runtime_error` exceptions.
