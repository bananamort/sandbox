# util/Statistics.h

## Purpose
Global-scope (no namespace) client-statistics and settings-fetch utilities: report counters/events to a stats endpoint, upload log files, and fetch/load client settings + A/B test data as `SimpleJSON` or via async HttpFuture.

## Declared API
```cpp
class SimpleJSON;   // fwd decl

#ifdef RBX_TEST_BUILD
void SetDefaultFilePath(const std::string& path);
const std::string& GetDefaultFilePath();
#endif

void SetBaseURL(const std::string& baseUrl);
const std::string& GetBaseURL();

void ReportStatisticWithMessage(const std::string& baseUrl, const std::string& id,
    const std::string& simpleMessage,
    const char* secondaryFilterName = NULL, const char* secondaryFilterValue = NULL);

void ReportStatistic(const std::string& baseUrl, const std::string& id,
    const std::string& primaryFilterName, const std::string& primaryFilterValue,
    const std::string& secondaryFilterName, const std::string& secondaryFilterValue);

void ReportStatisticPost(const std::string& baseUrl, const std::string& id,
    const std::string& postData, const char* secondaryFilterName, const char* secondaryFilterValue);

std::string UploadLogFile(const std::string& baseUrl, const std::string& data);

bool  FetchLocalClientSettingsData(const char* group, SimpleJSON* dest);
void  LoadClientSettingsFromString(const char* group, const std::string& settingsData, SimpleJSON* dest);
bool  FetchClientSettingsData(const char* group, const char* apiKey, SimpleJSON* dest);
void  FetchClientSettingsData(const char* group, const char* apiKey, std::string* dest); // raw overload
RBX::HttpFuture FetchClientSettingsDataAsync(const char* group, const char* apiKey);
RBX::HttpFuture FetchABTestDataAsync(const std::string& url);
std::string LoadABTestFromString(const std::string& responseData);
```

## Gotchas
- Everything is in the **global namespace** — pollutes unqualified lookup; names are generic (`SetBaseURL`, `ReportStatistic`).
- `SetBaseURL` mutates global state used presumably as default when callers pass it explicitly anyway.
- Settings fetch has sync (blocking), local-cache, parse-from-string, and async flavors; the two `FetchClientSettingsData` overloads differ by out-param type (SimpleJSON* vs std::string*) — overload resolution is exact-pointer-type based.
- Report functions are fire-off network calls; failure handling unspecified here.

## UNKNOWN
- Wire format of statistic posts and settings groups (.cpp side).
