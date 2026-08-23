# CookiesEngine.cpp (Win variant)

Source: `roblox-sandbox/ClientShared/Win/CookiesEngine.cpp` (291 lines)

## Purpose

Windows implementation of `CookiesEngine`: a mutex-protected, file-backed key=value cookie jar whose location comes from the registry value `HKCU\Software\ROBLOX Corporation\Roblox\CPath`. Format is `key=value&key=value&...` (`=` separates pair, `&` separates pairs).

## API

Overrides of CookiesEngine.h:

```cpp
bool   CookiesEngine::reportValue(CookiesEngine&, std::string key, std::string value); // retry SetValue 11x w/ 50ms sleeps
std::wstring CookiesEngine::getCookiesFilePath();     // reads CPath registry value
void   CookiesEngine::setCookiesFilePath(std::wstring&); // writes CPath registry value
int    CookiesEngine::SetValue(std::string key, std::string value);   // 0 = ok, -1 = fail
std::string CookiesEngine::GetValue(std::string key, int *errorCode, bool *exists);
int    CookiesEngine::DeleteValue(std::string key);
```

Private helpers ParseFileContent/FlushContent implement the on-disk format; ctor creates the file if absent (`fopen(..., "a")`).

## Usage

Per-target platform selection lives in `Base/Base.vcxproj`: this Win variant is built for Win32 configurations and excluded on Durango, while `Mobile/CookiesEngine.cpp` is the reverse (Durango-only); the Mac variant is wired in `Base/Base.xcodeproj`. ClientShared/CMakeLists.txt merely lists all variants for IDE visibility and builds none of them. Consumed by App/v8datamodel/CookiesEngineService.cpp which exposes cookie read/write to scripts. Cross-process sync uses named mutex `RobloxCookieEngineMutex` (ATL CMutex).

## Gotchas

- GetValue takes a **try-lock with 1 ms timeout** (`WaitForSingleObject(m, 1)`): under contention it returns empty string WITHOUT setting an error or exists flag — callers can't distinguish "cookie absent" from "mutex busy".
- SetValue/DeleteValue use blocking `CMutexLock`; reportValue wraps SetValue in an 11-attempt retry loop precisely because of that contention.
- FlushContent overwrites the file length with spaces first then rewrites from position 0 — a crash mid-flush leaves a padded/corrupt file; there is no atomic replace.
- Duplicate keys collapse silently via map insert semantics; values containing `&` or `=` corrupt the format (no escaping exists).
- `#pragma warning(disable:4996)` suppresses CRT deprecation for fopen; `chars[]` is declared `static` (internal linkage, TU-local) so despite its generic name it is not shared across TUs — it encodes `&` = chars[0], `=` = chars[1].
- Registry lookup failure yields an empty path string; engine methods then return -1 without touching disk.
