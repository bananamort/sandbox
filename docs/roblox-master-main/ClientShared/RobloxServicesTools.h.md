# RobloxServicesTools.h

Source: `roblox-sandbox/ClientShared/RobloxServicesTools.h` (23 lines)

## Purpose

Declares the free-function URL builders every client/server component uses to turn a base URL plus an API key into concrete web-service endpoints (counters, settings, game data, chat filter, crash dumps, persistence). Pure string assembly — no I/O, no state, no namespace.

## API

```cpp
std::string trim_trailing_slashes(const std::string &path);
std::string GetCountersUrl(const std::string &baseUrl, const std::string &key);
std::string GetCountersMultiIncrementUrl(const std::string &baseUrl, const std::string &key);
std::string GetSettingsUrl(const std::string &baseUrl, const std::string &group, const std::string &key);
std::string GetClientVersionUploadUrl(const std::string &baseUrl, const std::string &key);
std::string GetPlayerGameDataUrl(const std::string &baseurl, int userId, const std::string &key = "");
std::string GetWebChatFilterURL(const std::string& baseUrl, const std::string& key = "");
std::string GetGridUrl(const std::string &, bool changeToDataDomain = true);
std::string GetDmpUrl(const std::string &, bool changeToDataDomain = true);
std::string GetBreakpadUrl(const std::string &, bool changeToDataDomain = true);
std::string ReplaceTopSubdomain(const std::string& url, const char* newTopSubDoman);

std::string BuildGenericPersistenceUrl(const std::string& baseUrl, const std::string &servicePath);
std::string BuildGenericGameUrl(const std::string &baseUrl, const std::string &servicePath);

// these should only be used on RCC.
std::string GetSecurityKeyUrl(const std::string &baseUrl, const std::string &key);
std::string GetSecurityKeyUrl2(const std::string &baseUrl, const std::string &key);
std::string GetMD5HashUrl(const std::string &baseUrl, const std::string &key);
std::string GetMemHashUrl(const std::string &baseUrl, const std::string &key);
```

## Usage

Included by ~20 TUs across the tree: ClientShared/CountersClient.cpp and RobloxServicesTools.cpp (implementation), ClientBase/MachineConfiguration.cpp, WindowsClient/Application.cpp, Network/{GameConfigurer, ServerReplicator, WebChatFilter, Player}.cpp, RCCService/RCCServiceSoapServiceImpl.cpp, App/script/ScriptContext.cpp, App/v8datamodel/{DataStore, InsertService, Stats, TeleportService, LogService}.cpp, App/util/{ContentProvider, MachineIdUploader, LuaWebService, Analytics, Statistics}.cpp, App/util/Shared/Http.cpp. Listed as a header in App.vcxproj and the App Xcode project.

## Gotchas

- The four `GetSecurityKeyUrl*/GetMD5HashUrl/GetMemHashUrl` builders carry an in-source comment: "these should only be used on RCC." Calling them elsewhere builds fine but violates the intended deployment contract.
- `ReplaceTopSubdomain`'s parameter is misspelled `newTopSubDoman` in the real signature.
- The `GetGridUrl/GetDmpUrl/GetBreakpadUrl` trio defaults `changeToDataDomain = true`, silently rewriting the host to the data domain unless the caller opts out.
- All implementations live in the sibling `RobloxServicesTools.cpp` (documented separately); the header alone has no behavior.
