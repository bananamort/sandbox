# CountersClient.h

Source: `roblox-sandbox/ClientShared/CountersClient.h` (21 lines)

## Purpose

Declares `CountersClient`, a tiny fire-and-forget counter-reporting client against the website's ephemeralcounters API. Used for "did this code path ever run" telemetry from the client and RCC.

## API

```cpp
class CountersClient
{
    static std::set<std::wstring> _events;   // shared pending set (all instances)
    std::string _url;
    simple_logger<wchar_t>* _logger;
public:
    CountersClient(std::string baseUrl, std::string key, simple_logger<wchar_t>* logger);
    ~CountersClient() {}
    void registerEvent(std::wstring eventName, bool fireImmediately = true);
    void reportEvents();
private:
    void reportEvents(std::set<std::wstring> &events);
};
```

## Usage

Constructed with a site base URL + apiKey; event names are wide strings converted to UTF-8-ish narrow via `convert_w2s` at POST time. See CountersClient.cpp for wire format. Depends on `format_string.h` (simple_logger) and `RobloxServicesTools.h` (URL building) — both from this directory.

## Gotchas

- The static `_events` set means multiple clients (or re-entry during tests) share pending state.
- No result reporting whatsoever: registerEvent/reportEvents are best-effort by contract.
