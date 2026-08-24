# App/include/v8datamodel/FastLogSettings.h

## Purpose

FastLog/settings integration: `FastLogJSON` parses JSON into fast variables, `ClientAppSettings` is the singleton `ClientAppSettings` JSON config (the classic FFlags-by-file mechanism) declaring its data-map entries via macros. Also defines the settings string/API-key constants and exposes the FastLog settings item accessor.

## Declared API

Macros: `CLIENT_APP_SETTINGS_STRING "ClientAppSettings"`, `CLIENT_SETTINGS_API_KEY "D6925E56-BFB9-4908-AAA2-A5B1EC4B2D79"`.

- `GlobalAdvancedSettings::Item& FastLogSettingsInstance();`
- `class FastLogJSON : public SimpleJSON` — virtuals `void ProcessVariable(const std::string& valueName, const std::string& valueData, FastVarType fastVarType);` `bool DefaultHandler(valueName, valueData);`
- `class ClientAppSettings : public RBX::FastLogJSON` — static singleton (`static ClientAppSettings m_ClientAppSettings;`), `static void Initialize(); static ClientAppSettings& singleton();` data map declared with `START_DATA_MAP/END_DATA_MAP` containing: bools `AllowVideoPreRoll`, `CaptureQTStudioCountersEnabled`, `CaptureMFCStudioCountersEnabled`, `WebDocAddressBarEnabled`, `GoogleAnalyticsInitFix`; ints `VideoPreRollWaitTimeSeconds`, `CaptureCountersIntervalInMinutes`, `CaptureSlowCountersIntervalInSeconds`, `PublishedProjectsPageWidth/Height`, `AxisAdornmentGrabSize`, `MinNumberScriptExecutionsToGetPrize`, `MinPartsForOptDragging`, `GoogleAnalyticsThreadPoolMaxScheduleSize`, `GoogleAnalyticsLoadPlayer`, `GoogleAnalyticsLoadStudio`, four `HttpUseCurlPercentage*` (Mac/Win × Client/Studio); strings `StartPageUrl`, `PublishedProjectsPageUrl`, `PrizeAwarderURL`, `PrizeAssetIDs`, `GoogleAnalyticsAccountPropertyID(+Player)`.

## Gotchas

- A hard-coded API key ships in the header.
- These are file-driven settings (ClientAppSettings JSON), distinct from the FFlag/FastVar registry in Base FastLog — ProcessVariable is the bridge.
- Prize/GoogleAnalytics entries reveal telemetry + promo plumbing of the era.

## UNKNOWN

- Where Initialize() loads the JSON from disk/url (.cpp — see [FastLogSettings.md](../../v8datamodel/FastLogSettings.md)).

## Cross-links

- Implementation: [App/v8datamodel/FastLogSettings.md](../../v8datamodel/FastLogSettings.md).
- Settings base: [GlobalSettings.md](GlobalSettings.md); flag system facts in session checkpoint (FastLog macro taxonomy).
