# RCCServiceSoapServiceImpl.cpp

Source: `roblox-sandbox/RCCService/RCCServiceSoapServiceImpl.cpp` (1841 lines)

## Purpose

The heart of RCCService: implements every SOAP operation of the `RCCServiceSoapService` binding (HelloWorld, Diag/DiagEx, GetVersion, GetStatus, OpenJob/OpenJobEx, Execute/ExecuteEx, CloseJob, RenewLease, BatchJob/BatchJobEx, GetExpiration, GetAllJobs(/Ex), CloseExpiredJobs, CloseAllJobs) on top of the internal `CWebService` job manager. Also owns:

- Process-wide service bootstrap (`start_CWebService` / `stop_CWebService`) — engine subsystem init, settings fetching, background threads.
- The **job table**: one `RBX::DataModel` per job, lease/expiry management, script execution, teardown serialization.
- Remote-config plumbing: golden-hash MD5 updates, security-key versions, memory-hash configs, dynamic client-settings hot-reload, Google Analytics/InfluxDB init.
- Operational-security hook-ups (`initAntiMemDump`, `initLuaReadOnly`, `initHwbpVeh`, DEP opt-in).

The thirteen op counters referenced by `RCCService.cpp` are *defined* here (lines 82–94).

## API

### File-level definitions

- Op counters (lines 82–94): `diagCount, batchJobCount, openJobCount, closeJobCount, helloWorldCount, getVersionCount, renewLeaseCount, executeCount, getExpirationCount, getStatusCount, getAllJobsCount, closeExpiredJobsCount, closeAllJobsCount`.
- Log channels: `LOGVARIABLE(RCCServiceInit|RCCServiceJobs|RCCDataModelInit, 1)` (line 110–112).
- Flags: `DFI TaskSchedulerThreadCountEnum` (=1), `DFFlag DebugCrashOnFailToLoadClientSettings`(false), `DFFlag UseNewSecurityKeyApi`(false), `DFFlag UseNewMemHashApi`(false), `DFString MemHashConfig`(""), `FInt RCCServiceThreadCount` (default `TaskScheduler::Threads1`), `DFFlag US30476`(false), `FFlag UseDataDomain`(true), `FFlag Dep`(true) (lines 114–125).
- `static boost::scoped_ptr<MainLogManager> mainLogManager(new MainLogManager("Roblox Web Service", ".dmp", ".crashevent"))` (line 377) — dump/crash-event writer; hang-report feed comes from job heartbeats (`notifyAlive`).
- `#pragma comment(lib, "opengl32.lib"/"glu32.lib")` (16–17).
- `RBX_REGISTER_CLASS(ThumbnailGenerator)` (line 1238) — reflection registration so jobs can instantiate it.

### `class CrashAfterTimeout` (146–174)

Watches a condition variable with timeout; `RBXCRASH()` if not notified in time. **Defined but unused** — the intended use in `closeDataModel` is commented out (line 1100).

### `class RCCServiceSettings : RBX::FastLogJSON` (176–191)

Client-settings schema fetched from web config; defaults (lines 364–375):

| Key | Default |
| --- | --- |
| `WindowsMD5` / `MacMD5` / `WindowsPlayerBetaMD5` | `""` |
| `SecurityDataTimer` | 300 s |
| `ClientSettingsTimer` | 120 s |
| `GoogleAnalyticsAccountPropertyID` | `"UA-43420590-13"` (test account) |
| `GoogleAnalyticsThreadPoolMaxScheduleSize` | 500 |
| `GoogleAnalyticsLoad` | 10 (% probability) |
| `GoogleAnalyticsInitFix` | true |
| `HttpUseCurlPercentageRCC` | 0 |

### Updater hierarchy (193–331)

`SecurityDataUpdater` (abstract): periodic `run()` = `fetchData()` (HTTP GET, change-detect against cached string) → `RBX::WebParser::parseJSONTable` → take `"data"` array → `processDataArray`.

- `MD5Updater`: builds `std::set<std::string>` of hashes, force-inserts `"ios,ios"`, calls `RBX::Network::Players::setGoldenHashes2`.
- `SecurityKeyUpdater`: version = `RBX::sha1(value + "askljfLUZF")` (hardcoded salt, line 279) → `RBX::Network::setSecurityVersions`.
- `MemHashUpdater`: `populateMemHashConfigs(MemHashConfigs&, cfgStr)` parses `idx,value,failMask` tuples separated by `;`/`,` (public static; reused when `DFString::MemHashConfig` is set) → `Players::setGoldMemHashes`.

### `class RCCServiceDynamicSettings : RBX::FastLogJSON` (334–361)

Collects `ProcessVariable(name,data,dynamic)` entries; `DefaultHandler` accepts only names starting with `'D'` (dynamic flags/logs); `UpdateSettings()` replays them via `FLog::SetValue(..., FASTVARTYPE_DYNAMIC, false)` and clears.

### `class CWebService` (383–1211)

State: `JobMap jobs` (`std::map<std::string, shared_ptr<JobItem>>`), `sync` mutex, `currentlyClosingMutex`, `dataModelCount`, settings caches, `isThumbnailer` flag, two settings-fetch threads + one perf-data thread, `ATL::CEvent doneEvent` (auto-reset, initially set — the constructor passes `doneEvent(TRUE, FALSE)`, so each waiting loop consumes the initial signal once), static `singleton` (scoped_ptr).

`struct JobItem` (407–425): `{const std::string id; shared_ptr<DataModel> dataModel; RBX::Time expirationTime; int category; double cores; ATL::CEvent jobCheckLeaseEvent; connection notifyAliveConnection; JobItemRunStatus status; std::string errorMessage}` with statuses `RUNNING_JOB/JOB_DONE/JOB_ERROR`; `touch(double)` sets `expirationTime = now<Fast>() + Interval(seconds)`; `secondsToTimeout()` returns remaining seconds.

Core operations:

- **`createJob(const ns1__Job&, bool startHeartbeat, shared_ptr<DataModel>&)`** — **line 903**, the DataModel-per-job factory:
  1. `srand(RBX::randomSeed())` (per-thread RNG seeding).
  2. `dataModel = RBX::DataModel::createDataModel(startHeartbeat, new RBX::NullVerb(NULL,""), false)` — **one DataModel per job**.
  3. `setupServerConnections(dm)`: wires `AdService::sendServerVideoAdVerification → checkCanPlayVideoAd` and `sendServerRecordImpression → sendAdImpression`.
  4. If `Players` present: reload client settings (`LoadClientSettings(rccSettings)`, `RBXCRASH` on error); curl-vs-WinHttp lottery (`rand()%100 < HttpUseCurlPercentageRCC`) + `SetUseStatistics(true)`; push Windows/Mac/Beta MD5 golden hashes; Google Analytics init (`GoogleAnalyticsInitFix` path or `< GoogleAnalyticsLoad` lottery).
  5. Under `LegacyLock(Write)`: `dataModel->create<RBX::Network::WebChatFilter>()`.
  6. Connect `workspaceLoadedSignal → contentDataLoaded` (CSG dictionary reparent).
  7. `dataModel->jobId = id`; build `JobItem`, apply `category/cores`, `touch(expirationInSeconds)`.
  8. Under `sync`: duplicate id ⇒ `runtime_error("JobItem %s already exists")`; insert into `jobs`.
- **Job-creation-to-script-execution sequence (`OpenJob` path)**:
  1. gSOAP dispatcher (thread-pool worker from `process_request`, see RCCService.cpp) calls `RCCServiceSoapService::OpenJob` (line 1600): counter++, `RBX::Security::Impersonator(WebService)`, delegate to `CWebService::openJob(*job, script, &result, this, /*startHeartbeat=*/true)`.
  2. `openJob` (1040): `RBX::Http::gameID = job.id`; `dataModelCount++`; `createJob(...)`.
  3. Spawn `"Check Expiration"` boost thread running `doCheckLease(j)` — sleeps until lease expiry then `closeJob(id)`; woken early by `RenewLease`/`CloseJob` via `jobCheckLeaseEvent.Set()`.
  4. `execute(id, script, result, soap)` (820): if the script text is an HTTP URL (`ContentProvider::isHttpUrl`), fetch the Lua source over `RBX::Http::get`; locate job under `sync`; convert `ns1__LuaValue` arguments to `Reflection::Tuple` (nil/number/bool/string/table); take `LegacyLock(Write)`; reject if `dataModel->isClosed()`; call `ScriptContext::executeInNewThread(RBX::Security::WebService, ProtectedString::fromTrustedSource(code), script->name, args)` — **trusted-source** construction means no bytecode-signature verification for this path; convert returned tuple back into `ns1__LuaValue`s allocated on the soap heap.
  5. Connect `RunService::heartbeatSignal → notifyAlive` (feeds `mainLogManager->NotifyFGThreadAlive()` so the hang detector knows the job lives).
  6. Under Write lock: `pDataModel->loadCoreScripts()`.
  7. Return through gSOAP; later calls reuse the job via `Execute`/`RenewLease`; expiry or explicit `CloseJob` triggers `closeJob` → `closeDataModel`.
- `openJobEx` variant wraps results in `ns1__ArrayOfLuaValue` (line 1612).
- **`batchJob(const ns1__Job&, script, result, soap)`** (973): `createJob(job, /*startHeartbeat=*/false, dm)`; spawns a boost thread running `asyncExecute` (execute + closeJob, errors captured as `JOB_ERROR` message); the calling SOAP thread then loops on the lease event until the async side finishes (`closeJob` sets it) or expiry (`closeJob(id)` + `runtime_error("BatchJob Timeout")`). Comment at 1715: "Batch jobs are completed synchronously" from the caller's perspective.
- `closeJob(const std::string&, const char* errorMessage=NULL)` (1109): holds `currentlyClosingMutex` for the whole close (comment: the arbiter treats SOAP `CloseJob` returning as safe-to-force-kill, so parallel closes must serialize); marks status, sets lease event, disconnects heartbeat, erases from map under `sync`; then `closeDataModel` outside the lock; last DataModel out disables hang reporting.
- `closeDataModel(shared_ptr<DataModel>)` (1097): `Impersonator(WebService)` + `RBX::DataModel::closeDataModel` (the 90-second crash-watch is disabled).
- Lease helpers: `renewLease(id, seconds)` → `touch`; `getExpiration(id, &timeout)`; `closeExpiredJobs(int*)` and `closeAllJobs(int*)` snapshot IDs under lock then close each; `getAllJobs(vector<ns1__Job*>&, soap*)` snapshots live leases; `getJob(id)` throws `runtime_error("JobItem %s not found")` when missing.
- Diagnostics: `diag(int type, shared_ptr<DataModel>)` (678) builds a documented ValueArray tuple (comment lines 682–705): DataModel count, perf counters (cores/CPU time/private bytes/working set/elapsed/virtual/pagefile/page-faults), task-scheduler stats, DataModel jobs info, machine config, instance/allocator memory counters (+`ThumbnailGenerator::totalCount`). Bit flags: `type&1` leak dump (**empty stub**, line 673), `type&2` 5×100 KB allocation probe (true/false), `type&4` `arbiterActivityDump` (per-job `(arbiterName, averageActivity)` pairs, taken under `sync`).
- `validateSecurityData()` (453): loop every `SecurityDataTimer` s — new-API (`UseNewSecurityKeyApi`/`UseNewMemHashApi`) updater runs or legacy `fetchAllowedSecurityVersions()` diff → `setSecurityVersions`; plus `md5Updater->run()` every cycle.
- `validateClientSettings()` (495): loop every `ClientSettingsTimer` s; on change, `rccDynamicSettings.ReadFromStream(client[+thumbnail])`, then submit `UpdateSettings` as a **Write task on the first job's DataModel** (explicit HACK comment: global settings assumed shared because ~one DataModel per service), or apply directly if no jobs.
- `collectPerfData()` (1240): 1-second tick `CProcessPerfCounter::CollectData()`.

Bootstrap/teardown:

- `start_CWebService(LPCTSTR contentpath, bool crashUploaderOnly)` (1220): relative content paths resolve against the module directory (`PathIsRelative` + `GetModuleFileName(_AtlBaseModule.m_hInst)`); `ContentProvider::setAssetFolder(...)`; constructs the `CWebService` singleton.
- `stop_CWebService()` (1215): `singleton.reset()` → destructor.
- `CWebService(bool crashUploadOnly)` (1246): loads version info → `DebugSettings::robloxVersion`; analytics reporter identity `"RCCService"`; perf-counter thread; `ProfanityFilter::getInstance()`; `Http::init(WinHttp, CookieSharingSingleProcessMultipleThreads)`, requester `"Server"`; `Profiling::init(false)`; static `FactoryRegistrator` (comment: guarantees `srand` before `rand`); `InfluxDb::init()`; `RobloxCrashReporter::silent = true` + `mainLogManager->WriteCrashDump()` (uploads preexisting dumps at boot); `isThumbnailer = isServiceInstalled("Roblox.Thumbnails.Relay")` (1824, SCM query); `LoadAppSettings()` (AppSettings.xml `BaseUrl` → `SetBaseURL`); client-settings load with crash-on-error; `TaskScheduler::setThreadCount(FInt::RCCServiceThreadCount)`; forced singleton loads of GameSettings/LuaSettings/DebugSettings/PhysicsSettings; `SoundService::soundDisabled = true`; `Network::initWithServerSecurity()`; `DumpErrorUploader(!crashUploadOnly, "RCCService")` + `InitCrashEvent(GetGridUrl(GetBaseURL(), UseDataDomain), ...)` + immediate `Upload`; starts `fetchClientSettingsThread`; constructs the three updaters with app-guid `"2b4ba7fc-5843-44cf-b107-ba22d3319dcd"` and runs them once synchronously; starts `fetchSecurityDataThread`; `CountersClient(baseURL, "76E5A40C-3AE1-4028-9F10-7C62520BD94F", NULL)`; `ViewBase::InitPluginModules()`; `if (DFFlag::US30476) initAntiMemDump(); initLuaReadOnly(); initHwbpVeh();`; `FFlag::Dep` gate → `GetProcAddress(kernel32, "SetProcessDEPPolicy")(1)` (opt-in DEP).
- Destructor (1367): `doneEvent.Set()`, join the three threads, `closeAllJobs(&result)` (TODO comment admits *"this line crashes sometimes :-("*), `ViewBase::ShutdownPluginModules()`.
- `GetSettingsKey()` (1381): `RBX_TEST_BUILD` override via `-SettingsKey:`; otherwise registry `HKLM\Software\ROBLOX Corporation\Roblox\SettingsKey`, returned as `"RCCService" + key`.
- `LoadClientSettings` (1409/1420): fetch via `FetchClientSettingsData(settingsKey, "D6925E56-BFB9-4908-AAA2-A5B1EC4B2D79", ...)` plus `"RccThumbnailers"` payload when thumbnailer; empty results → GA error track event (category `GA_CATEGORY_ERROR`, computer name attached) and optional `RBXCRASH` under `DebugCrashOnFailToLoadClientSettings`.
- `fetchAllowedSecurityVersions()` (1485): empty BaseURL ⇒ `RBXCRASH()` (comment: *"y u no set BaseURL??"*, 1489); GET `GetSecurityKeyUrl(baseUrl, guid)`; unchanged payload short-circuits; JSON `data[]` hashed with the same `"askljfLUZF"` salt; any exception logged as `"LoadAllowedPlayerVersions exception"`.

### SOAP entry points (1540–1820)

All follow the same shape: `BEGIN_PRINT`/`END_PRINT` trace macros (no-op unless `DIAGNOSTICS` defined), Interlocked counter ±, most wrap `Impersonator(WebService)`, delegate to `CWebService::singleton`, return 0 (gSOAP success). Signatures (gSOAP convention `int Op(_ns1__Op*, _ns1__OpResponse*)`):

| Operation | Line | Notes |
| --- | --- | --- |
| `HelloWorld` | 1540 | returns `"Hello World"` string. |
| `Diag` / `DiagEx` | 1552 / 1564 | diagnostics ValueArray / ArrayOfLuaValue; `jobID` optional. |
| `GetVersion` | 1576 | `DebugSettings::robloxVersion`. |
| `GetStatus` | 1586 | `ns1__Status{version, environmentCount=jobCount()}`. |
| `OpenJob` | 1600 | creates job + runs script, `startHeartbeat=true`. |
| `OpenJobEx` | 1612 | ArrayOfLuaValue result. |
| `Execute` / `ExecuteEx` | 1626 / 1646 | run script on existing job. |
| `CloseJob` | 1670 | closes job/DataModel. |
| `RenewLease` | 1689 | extends lease. |
| `BatchJob` / `BatchJobEx` | 1709 / 1732 | fire-and-wait job lifecycle (async executor thread + synchronous wait). |
| `GetExpiration` | 1755 | remaining lease seconds. **No Impersonator wrapper.** |
| `GetAllJobs` / `GetAllJobsEx` | 1773 / 1785 | list jobs. |
| `CloseExpiredJobs` / `CloseAllJobs` | 1798 / 1810 | bulk close. |

## Usage

This TU is the server-side implementation the generated gSOAP dispatch calls into; nothing here is called directly by other modules except `start_CWebService`/`stop_CWebService` from `RCCService.cpp`. Client-side callers are the Roblox web tier driving game servers and thumbnail rendering through this SOAP API.

## Gotchas

- **One DataModel per job, but settings are global**: `validateClientSettings` explicitly hacks around this by writing settings only into the *first* job's DataModel (lines 517–523); with multiple concurrent jobs the others silently miss setting updates.
- **`batchJob` error-ordering TODO** (line 1013): on success path the author notes closeJob should arguably happen *before* throwing the stored error message; current order can race the arbiter's kill logic.
- **`openJob` two-phase cleanup**: inner catch erases the map entry (1078) without closing the DataModel; only the outer catch (1090) actually closes it — correct today because the outer catch always fires, but fragile under refactoring.
- **BatchJob blocks a thread-pool request slot for the job's whole lifetime** (`requestCount` guard in stepRCC sees long-lived requests).
- **Copy-paste traces**: `CloseExpiredJobs`/`CloseAllJobs` pass label `"GetAllJobs"` to BEGIN_PRINT/END_PRINT (1800, 1812).
- **`GetExpiration` lacks the `Security::Impersonator(WebService)` wrapper** every other mutating op uses.
- **Script sources can be fetched over plain HTTP** when the submitted "script" is a URL (823–827); execution still happens as trusted source under `Security::WebService`.
- **Hardcoded salts/GUIDs**: security-version salt `"askljfLUZF"`; settings/thumbnailer GUID `D6925E56-…`; grid GUID `2b4ba7fc-…`; counters GUID `76E5A40C-…`.
- `leakDump` is an intentional no-op stub despite the `type&1` wire contract reserving space for it.
- Duplicate `#include "ThumbnailGenerator.h"` (36, 40) and `RobloxServicesTools.h` (34, 59) — harmless noise.
- `catch (std::exception ex)` by value in `fetchAllowedSecurityVersions` (1521) slices/polices nothing — style wart.
- Front-loads heavy engine deps (workspace, players, v8xml, GfxBase…) — this TU cannot compile standalone; it anchors the whole engine into RCCService.exe.

UNKNOWN: remote endpoint formats behind `FetchClientSettingsData`, `GetGridUrl`, `GetSecurityKeyUrl(2)`, `GetMD5HashUrl`, `GetMemHashUrl` (declared in engine headers outside this folder); behavior of `RBX::DataModel::createDataModel(startHeartbeat, NullVerb, false)`'s third argument (engine-side).
