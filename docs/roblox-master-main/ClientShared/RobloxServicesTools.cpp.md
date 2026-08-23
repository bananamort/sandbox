# RobloxServicesTools.cpp

Source: `roblox-sandbox/ClientShared/RobloxServicesTools.cpp` (209 lines)

## Purpose

Central URL-construction utility for Roblox web services: builds api.roblox.com service URLs with apiKey query params, error-upload endpoints on the data subdomain, and gamepersistence/assetgame generic URLs. Nearly every network-touching subsystem includes this header.

## API

```cpp
std::string trim_trailing_slashes(const std::string &path);
std::string GetCountersUrl(baseUrl, key);                 // ephemeralcounters v1.1/Counters/Increment
std::string GetCountersMultiIncrementUrl(baseUrl, key);   // ephemeralcounters v1.0/MultiIncrement
std::string GetSettingsUrl(baseUrl, group, key);          // clientsettings Setting/QuietGet/<group>
std::string GetClientVersionUploadUrl(baseUrl, key);      // versioncompatibility GetCurrentClientVersionUpload
std::string GetPlayerGameDataUrl(baseurl, userId, key="");// <api>/game/players/<id>
std::string GetWebChatFilterURL(baseUrl, key="");         // <api>/moderation/filtertext
std::string GetGridUrl(anyUrl, changeToDataDomain=true);  // data.<...>/Error/Grid.ashx
std::string GetDmpUrl(...);                               // .../Error/Dmp.ashx
std::string GetBreakpadUrl(...);                          // .../Error/Breakpad.ashx
std::string ReplaceTopSubdomain(url, newTopSubDomain);    // www.->X. or m.->X.
std::string BuildGenericPersistenceUrl(baseUrl, servicePath); // www->gamepersistence host
std::string BuildGenericGameUrl(baseUrl, servicePath);        // www->assetgame host
// RCC-only:
std::string GetSecurityKeyUrl(baseUrl, key);              // versioncompatibility GetAllowedSecurityVersions
std::string GetSecurityKeyUrl2(baseUrl, key);             // versioncompatibility GetAllowedSecurityKeys
std::string GetMD5HashUrl(baseUrl, key);                  // versioncompatibility GetAllowedMD5Hashes
std::string GetMemHashUrl(baseUrl, key);                  // versioncompatibility GetAllowedMemHashes
```

Internal: `BuildGenericApiUrl(baseUrl, serviceName, path, key, scheme)`.

## Usage

Consumed by WindowsClient/Application.cpp, ClientBase/MachineConfiguration.cpp, Network (GameConfigurer, ServerReplicator, WebChatFilter, Player), App/script/ScriptContext.cpp, App/v8datamodel (DataStore, InsertService, Stats, TeleportService, LogService), App/util (Http, ContentProvider, Analytics, Statistics, MachineIdUploader, LuaWebService), RCCServiceSoapServiceImpl.cpp.

## Gotchas

- `BuildGenericApiUrl` has a hardwired `const bool kSkipBuildApiUrl = true;` branch: it slices 11 chars off baseUrl when it doesn't start with "https", 12 when it does — i.e. it assumes `<scheme>://www.` exactly ("http://" + "www." = 11, "https://" + "www." = 12) and then formats `<sub>.api.<host>/<path>/?apiKey=<key>`. A base URL without a literal `www.` first subdomain gets mangled. The elaborate legacy prod/sitetest3 logic below the `if` is dead code kept for reference.
- Scheme selection has TWO layers: `DEFAULT_URL_SCHEMA` (`https` under RBX_PLATFORM_DURANGO, else `http`) is passed explicitly by `GetCountersUrl`, `GetCountersMultiIncrementUrl`, and `GetSettingsUrl` only. The other wrappers (`GetSecurityKeyUrl*`, `GetClientVersionUploadUrl`, `GetPlayerGameDataUrl`, `GetWebChatFilterURL`, `GetMD5HashUrl`, `GetMemHashUrl`) omit the argument and therefore always use the C++ default parameter `"https"`.
- `ReplaceTopSubdomain("www.", X)` replaces only **3** chars after the found position (`result.replace(foundPos, 3, ...)`) — correct because foundPos points at 'w'; same trick for "m." replacing 1 char. A URL containing "www." mid-path would also be rewritten (finds first occurrence anywhere).
- `trim_trailing_slashes("")` returns "" safely; on all-slashes input returns "".
- apiKey travels as a plaintext query parameter on every generated URL.
