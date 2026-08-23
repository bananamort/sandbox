# Statistics.cpp

**Source**: `App/util/Statistics.cpp` (381 lines) — client-settings fetch/AB-test plumbing, the global BaseURL store, `RBX::Http::urlEncode/urlDecode` implementations, and legacy `/Analytics/Measurement.ashx` reporting.

## Purpose
Bootstraps remote configuration: fetches FFlag/FVariable/AB-test JSON groups from the web (`GetSettingsUrl(baseUrl, group, apiKey)`), merges local override JSON from `<userDir>/ClientSettings/<group>.json`, applies AB-test variations into fast variables, and posts log-file/measurement analytics.

## API
```cpp
void SetBaseURL(const std::string& baseUrl);        // process-global; must precede settings fetch
const std::string& GetBaseURL();                    // used across HTTP layer (counters URLs etc.)
std::string RBX::Http::urlEncode(const std::string& url);    // defined HERE despite Http class
std::string RBX::Http::urlDecode(const std::string& fragment);

std::string UploadLogFile(const std::string& baseUrl, const std::string& data);  // POST <base>/Analytics/LogFile.ashx
bool FetchLocalClientSettingsData(const char* group, SimpleJSON* dest);
void LoadClientSettingsFromString(const char* group, const std::string& settingsData, SimpleJSON* dest);
bool FetchClientSettingsData(const char* group, const char* apiKey, SimpleJSON* dest);
void FetchClientSettingsData(const char* group, const char* apiKey, std::string* dest);   // raw GET
RBX::HttpFuture FetchClientSettingsDataAsync(const char* group, const char* apiKey);
RBX::HttpFuture FetchABTestDataAsync(const std::string& url);
std::string LoadABTestFromString(const std::string& responseData);
void ReportStatisticWithMessage(...); void ReportStatistic(...);
void ReportStatisticPost(baseUrl, id, postData[, primaryFilterName, primaryFilterValue], secondaryFilterName, secondaryFilterValue);
// test-only: SetDefaultFilePath / GetDefaultFilePath (RBX_TEST_BUILD)
```

## Usage
- Settings URL built by `GetSettingsUrl(baseUrl, group, apiKey)` (RobloxServicesTools.h); fetched with plain blocking `RBX::Http::get`, swallowing exceptions; empty BaseURL triggers `RBXCRASH()`.
- AB tests: `FetchABTestDataAsync` collects registered experiment variables via `FLog::ForEachVariable` (categories NewUsers/NewStudioUsers/AllUsers), serializes with `WebParser::writeJSON`, POSTs as application/json; `LoadABTestFromString` maps response variations into `FLog::SetValue` (values ≤2 are control → 0) and registers GA experiment variation + returns `BrowserTrackerId`.
- `ReportStatisticPost` GETs/POSTs `<baseUrl>/Analytics/Measurement.ashx?Type=ROBLOXAPP%20<id>` with optional `FilterName/FilterValue` (NULL name ⇒ `IpFilter=primary`) and secondary filters; responses discarded via `DontCareResponse`.
- `UploadLogFile` appends a NUL byte after URL and payload and gzips (`compress=true`) to `<base>/Analytics/LogFile.ashx`.

## Gotchas
- **URLs contain embedded NUL terminators** (`<< char(0)`): the request string sent to RBX::Http includes a trailing `\0`; downstream code that uses c_str()-length semantics will truncate it — an intentional quirk of the legacy protocol.
- `urlEncode` escapes everything outside alphanumerics and `-._~`-ish ranges by ASCII table ranges only; space becomes `%20`, but `/` and `:` are also escaped.
- `urlDecode` asserts `(i+3)<=strLen` — a trailing `%` or `%X` trips RBXASSERT in debug and reads out-of-range bytes in release.
- `ReportStatisticWithMessage` replaces newlines/tabs with literal `"%20"` (not real encoding) before sending.
- Local ClientSettings JSON silently overrides server values (loaded after web data into same SimpleJSON).
