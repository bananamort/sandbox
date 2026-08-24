# FastLogSettings.cpp

## Purpose

The FastLog/FastFlag variable-definition TU for the client app: ~90 LOGVARIABLE definitions across subsystems (input, render, clusters, DataModel, scripts, network, security), a few debug flags, the `ClientAppSettings` data-map singleton (web-fetched client config: video preroll, GA account IDs + sampling percentages, curl-percentage rollout), and the `FastLogJSON::DefaultHandler` prefix-dispatch that maps "FLog/FFlag/FInt/FString", "S*" (sync) and "D*" (dynamic) and AB-test variable names from JSON config onto FLog::SetValue.

## Key types and API

Descriptors: none. Flags defined here: `DebugHumanoidRendering(false)` static, `DebugDisableTimeoutDisconnect(false)` dynamic, `DebugLocalRccServerConnection(false)` static. DYNAMIC_LOGVARIABLE MaxJoinDataSizeKB(100). DYNAMIC_FASTINTVARIABLE RakNetMaxSplitPacketCount(1400).

Notable log defaults ON (≥1): COMCalls, RobloxWndInit, CrashReporterInit, HardwareMouse(2), GoldenHashes, ViewRbxBase(2), RenderStatsOnLogs(2), RenderBreakdown(+Details)(2), DataModelJobs(2), RbxMegaClustersUpdate/Init(2), GfxClusters(2), MegaClusters/MegaClusterInit, MegaClusterNetwork(2), CloseDataModel, ScriptContextClose, CoreScripts, Player, NetworkCache, JoinSendExtraItemCount, MachineIdUploader, ScriptPrint(3), ClientSettings.

ClientAppSettings IMPL_DATA entries include AllowVideoPreRoll(false)/VideoPreRollWaitTimeSeconds(30), StartPageUrl/PublishedProjectsPageUrl+dimensions, counter-capture toggles/intervals, AxisAdornmentGrabSize(5), PrizeAwarderURL/PrizeAssetIDs/MinNumberScriptExecutionsToGetPrize(500), MinPartsForOptDragging(200), GoogleAnalyticsAccountPropertyID "UA-43420590-2" (+Player variant "-13"), GoogleAnalyticsThreadPoolMaxScheduleSize(500), GA LoadPlayer 1% vs LoadStudio 100%, four HttpUseCurlPercentage* knobs (all 0). Initialize() fetches via FetchClientSettingsData(CLIENT_APP_SETTINGS_STRING, CLIENT_SETTINGS_API_KEY, …).

FastLogJSON::DefaultHandler dispatch table — first char routes to DYNAMIC ('D'), SYNC ('S'), else STATIC; AB-test patterns (ABNewUsers/ABNewStudioUsers/ABAllUsers) map to their own var types; matched names are STRIPPED of prefix before FLog::SetValue.

Static `BaseLogInitter initter` runs initBaseLog() at static-init time.

## Usage / reflection touchpoints

Feeds every FASTLOG/DFFlag referenced across these docs ([DataModel](DataModel.md)'s CloseDataModel/LegacyLock logs live here); ClientAppSettings consumed by shell/GUI code.

## Gotchas

- The prefix dispatcher checks 'D'/'S' FIRST CHAR ONLY — a hypothetical variable named "DebugFoo" would route into the dynamic branch and fail all compares (falls through unprocessed).
- AB-test handling runs INSIDE the else (static) branch only — dynamic/sync-prefixed AB names are never processed.
- GA sampling is 1% for players but 100% for Studio — telemetry asymmetry by design.
