# App/include/v8datamodel/CookiesEngineService.h

## Purpose

`CookiesService` (non-creatable service; descriptor string is "CookiesService" despite the file being named CookiesEngineService) — key/value cookie store for engine-side persistence of small strings.

## Declared API

`class CookiesService : public DescribedNonCreatable<CookiesService, Instance, sCookiesService>, public Service`

- `CookiesService();`
- `void SetValue(std::string key, std::string value);`
- `std::string GetValue(std::string key);`
- `void DeleteValue(std::string key);`
- Private: `std::string path;` (cookie file location).

## Gotchas

- Filename/class mismatch: header is `CookiesEngineService.h`, class is `CookiesService`.
- Synchronous string API — no error channel for missing keys (GetValue returns "" presumably).

## UNKNOWN

- Backing-file format and thread-safety (.cpp — no implementation doc exists at time of writing).

## Cross-links

- Kin web-cookie services live outside v8datamodel; related local services: [DebugSettings.md](DebugSettings.md), [GlobalSettings.md](GlobalSettings.md).
