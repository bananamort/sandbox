# INDEX.md — ClientShared

Directory: `roblox-sandbox/ClientShared/` (31 files: 21 first-party + 10 vendored rapidjson headers)

ClientShared holds small client utilities shared across targets and compiled directly into App/Base, WindowsClient, and RCCService builds by include path — the directory's own `CMakeLists.txt` only registers an IDE-listing custom target (`ClientShared_unbuilt`) that is never compiled. Contents: HTTP/web-service plumbing (`CountersClient`, `InfluxDbHelper`, `RobloxServicesTools`, `format_string`), JSON parsing (`SimpleJSON` plus vendored rapidjson), DataModel save/upload variants (`DataModelSerialize`, `DataModelEmptySerialize`), string/platform conversion (`StringConv`, `CookiesEngine` with Win/Mac/Mobile variants), and the SDL2 gamepad bridge (`SDLGameController`) consumed by WindowsClient.

| File | One-liner |
|---|---|
| CMakeLists.txt | IDE-only file listing; `add_custom_target(ClientShared_unbuilt)` never compiles |
| CookiesEngine.h | Declares cookie get/set/clear helpers per platform |
| Mobile/CookiesEngine.cpp | Stub cookie backend (every op fails/empty); wired to Durango configs in Base.vcxproj |
| Mac/CookiesEngine.cpp | macOS cookie backend |
| Win/CookiesEngine.cpp | Windows registry-path + file-backed cookie jar under a named CMutex |
| CountersClient.h | Declares counter/metric upload client API |
| CountersClient.cpp | Batches counters, POSTs to counters web endpoint via GetCountersMultiIncrementUrl |
| DataModelEmptySerialize.cpp | Empty no-op stubs of the save/upload API (anti "place stealing"); linked instead of DataModelSerialize.cpp in locked-down clients |
| DataModelSerialize.cpp | Full binary place serialize + POST upload with stats and error-log upload |
| format_string.h | Declares printf-style formatting helper |
| format_string.cpp | Implementation of the format helper |
| InfluxDbHelper.h | Declares InfluxDB JSON series-telemetry builder (dead code in this tree) |
| InfluxDbHelper.cpp | Composes JSON payloads for an InfluxDB endpoint — string building only, no POSTing, no callers |
| RobloxServicesTools.h | URL-builder declarations (counters/settings/game-data/dump/security-key endpoints) |
| RobloxServicesTools.cpp | URL-builder implementations incl. top-subdomain rewriting |
| SDLGameController.h | SDL2 gamepad bridge class decl + `RBX::Gamepad` typedef |
| SDLGameController.cpp | SDL event→InputObject translation, haptic vibration effects |
| SimpleJSON.h | Declarative JSON-reader macro framework (parse-only, no writer) |
| SimpleJSON.cpp | rapidjson-based flat-object parser dispatching to macro-registered setters |
| StringConv.h | UTF-8 ↔ SysPathString conversion decls |
| StringConv.cpp | Windows implementation of the conversion pair |

**Vendored, intentionally undocumented** (third-party upstream code, excluded per campaign scope): `rapidjson/rapidjson.h`, `document.h`, `writer.h`, `prettywriter.h`, `reader.h`, `stringbuffer.h`, `filestream.h`, `internal/{stack,pow10,strfunc}.h` — Tencent RapidJSON snapshot.

Cross-directory notes: `RobloxServicesTools.h` is included by ~20 TUs spanning Network/, ClientBase/, WindowsClient/, RCCService/, App/util and App/v8datamodel. `StringConv.h` reaches Rendering, App/script, App/v8datamodel and Win/. `SDLGameController.*` are consumed only by WindowsClient/UserInput.h. `Win/LogManager.h` (see ../Win/) is a distinct logging facility from anything here.
