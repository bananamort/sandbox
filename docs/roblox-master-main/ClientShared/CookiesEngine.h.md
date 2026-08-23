# CookiesEngine.h

Source: `roblox-sandbox/ClientShared/CookiesEngine.h` (25 lines)

## Purpose

Declares `CookiesEngine`, the platform-abstracted persistent "cookie" jar used to pass state (e.g. authenticated launch tickets, bootstrap info) between Roblox processes on one machine. One implementation per platform is compiled in: `Win/`, `Mac/`, or `Mobile/CookiesEngine.cpp`.

## API

```cpp
class CookiesEngine
{
    std::wstring fileName;                       // backing file path
    std::map<std::string, std::string> values;
    void ParseFileContent(std::fstream &f);
    void FlushContent(std::fstream &f);
public:
    static std::wstring getCookiesFilePath();    // platform: registry (Win) / plist (Mac) / "" (Mobile)
    static void setCookiesFilePath(std::wstring &path);  // no-op on Mac (bootstrapper owns it)
    static bool reportValue(CookiesEngine &engine, std::string key, std::string value); // retry helper
    CookiesEngine(std::wstring path);
    int SetValue(std::string key, std::string value);                    // 0 ok / -1 fail
    std::string GetValue(std::string key, int *errorCode, bool *exists); // errorCode -1 = IO failure
    int DeleteValue(std::string key);
};
```

## Usage

Consumed by App/v8datamodel/CookiesEngineService.cpp. The static path getters let the bootstrapper and client agree on the cookie file location before either opens it.

## Gotchas

- Which .cpp implements this class depends purely on which platform variant is listed in the build (ClientShared/CMakeLists.txt lists all three for IDE visibility but each target compiles only its own).
- The interface leaks platform differences: Mobile returns failure for everything; Mac cannot setCookiesFilePath at runtime.
- No escaping exists in the wire format — keys/values must not contain `=` or `&`.
