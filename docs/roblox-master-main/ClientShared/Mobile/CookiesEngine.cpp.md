# CookiesEngine.cpp (Mobile variant)

Source: `roblox-sandbox/ClientShared/Mobile/CookiesEngine.cpp` (47 lines)

## Purpose

Stub implementation of `CookiesEngine` for mobile platforms: every operation fails or returns empty. Exists so mobile targets link without carrying the desktop cookie-file machinery.

## API

```cpp
bool reportValue(...)            -> false
std::wstring getCookiesFilePath() -> L""
void setCookiesFilePath(...)      -> no-op
CookiesEngine(std::wstring)       -> no-op
ParseFileContent / FlushContent   -> no-op
int SetValue(...)                 -> -1
std::string GetValue(...)         -> "" (note: does not touch *errorCode/*exists)
int DeleteValue(...)              -> -1
```

## Usage

Selected by mobile-class targets via `Base/Base.vcxproj` (`ExcludedFromBuild` conditions make this the Durango-only variant; the Win32 configs exclude it and use `Win/CookiesEngine.cpp`). ClientShared/CMakeLists.txt merely lists all three variants without building any.

## Gotchas

- `GetValue` ignores its out-params entirely — callers checking `*exists`/`*errorCode` read uninitialized values unless pre-initialized. This is a contract violation relative to the Win/Mac variants.
