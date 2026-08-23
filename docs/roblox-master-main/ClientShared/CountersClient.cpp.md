# CountersClient.cpp

Source: `roblox-sandbox/ClientShared/CountersClient.cpp` (129 lines)

## Purpose

Implements the ephemeral-counters telemetry client: batches counter names into a `counterNamesCsv=` form POST against the `ephemeralcounters` service URL produced by `RobloxServicesTools::GetCountersMultiIncrementUrl`, using raw WinINet.

## API

```cpp
CountersClient::CountersClient(std::string baseUrl, std::string key, simple_logger<wchar_t>* logger);
void CountersClient::registerEvent(std::wstring eventName, bool fireImmediately = true);
void CountersClient::reportEvents();
private: void reportEvents(std::set<std::wstring> &events);
```

## Usage

- Constructor resolves the POST URL once via `GetCountersMultiIncrementUrl(baseUrl, key)` and logs it through the optional injected `simple_logger`.
- `registerEvent(name, true)` fires a one-shot POST immediately; with false it accumulates into a process-wide static set flushed by `reportEvents()` (typically at shutdown).
- Consumers in this tree: `RCCService/RCCServiceSoapServiceImpl.cpp` only (verified by tree-wide grep — WindowsClient does not reference CountersClient anywhere).

## Gotchas

- `_events` is a function-scope **static** shared by ALL CountersClient instances — cross-instance bleed-through by design.
- WinINet session/user-agent is `"Roblox/WinInet"`; connect/receive/send timeouts forced to 5 s each via `InternetSetOption`.
- The error path is a fall-through label: after any `goto Error`, handles are closed and the failure is silent — no status code check, no retry, response body never read.
- Events are cleared BEFORE the send attempt (`events.clear()` right after building postData), so a failed network call loses the batch permanently.
- Uses ATL `CUrl::CrackUrl` and `CString` — pulls atlutil/atlbase headers; UNICODE/non-UNICODE branches handled manually.
- Only consumer in this tree is `RCCService/RCCServiceSoapServiceImpl.cpp` (constructs one with a hardcoded counter key and NULL logger); no WindowsClient usage exists despite the client-side API surface.
