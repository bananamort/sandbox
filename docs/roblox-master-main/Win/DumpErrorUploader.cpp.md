# DumpErrorUploader.cpp

Source: `roblox-sandbox/Win/DumpErrorUploader.cpp` (234 lines)

## Purpose

Crash-artifact upload pump. `Upload(url)` takes a named interprocess mutex ("RobloxCrashDumpUploaderMutex") so only one client instance uploads at a time, gathers `*.dmp` + associated logs via `MainLogManager::gatherCrashLogs()`, then — on the worker thread or inline — POSTs each file to `url?filename=<encoded>` via RBX::Http, moving each to `archive\` afterwards, and reports EphemeralCounter/Influx telemetry. `UploadCrashEventFile` posts the pre-built crash-event request and emits Influx points (session id, game state, exception code/address/parameters under DFFlag ExtendedCrashInfluxReporting).

## API

```cpp
DumpErrorUploader::DumpErrorUploader(bool backgroundUpload, const std::string& crashCounterNamePrefix);
void DumpErrorUploader::InitCrashEvent(const std::string& url, const std::string& crashEventFileName);
    // crashEventRequest = new Http(url + "?filename=" + urlEncode(name)); response.reserve(MAX_PATH); once-only
void DumpErrorUploader::Upload(const std::string& url);
    // CreateMutex(TRUE, "RobloxCrashDumpUploaderMutex"); ERROR_ALREADY_EXISTS → skip silently
    // gatherCrashLogs() → _data->files; wake thread else while(run(_data)!=done){}
int LogFilter(unsigned int code, _EXCEPTION_POINTERS*);   // non-static free function; EXCEPTION_EXECUTE_HANDLER stub
static void DumpErrorUploader::UploadCrashEventFile(_EXCEPTION_POINTERS* excInfo = NULL);
    // if(crashEventRequest): post(crashEventData,...) + counter + Influx points
RBX::worker_thread::work_result DumpErrorUploader::run(shared_ptr<data> _data);
    // pop front → POST → MoveRelative(file,"archive\\") → more | done (releases mutex, reports Crash counter)
```

Dynamic flags: `DFInt RCCInfluxHundredthsPercentage` (default 1000), `DFFlag ExtendedCrashInfluxReporting` (false).

## Usage

Wired by WindowsClient/Application.cpp (constructed both foreground at line ~1008 and background at ~1129 with counter prefix "WindowsClient"; InitCrashEvent(GetDmpUrl(...), logManager.getCrashEventName())) and by RCCService/RCCServiceSoapServiceImpl.cpp (prefix "RCCService"). Win/LogManager.cpp's RobloxCrashReporter::ProcessException calls UploadCrashEventFile. Depends on util/http.h (RBX::Http), v8datamodel/Stats.h (Analytics counters/Influx), rbx/rbxTime.h, util/MemoryStats.h.

## Gotchas

- After >3 dmp files in one run, subsequent dumps are NOT uploaded; instead the literal body "Too many dmp files" is posted under the file's URL.
- Empty files are posted with body "Empty!!!" deliberately ("so that we can report it").
- Files whose name contains ".Full." are skipped entirely (never uploaded) but still archived.
- In-source caveat at the archive step: if the process dies right after uploading the .dmp, associated logs are never uploaded — accepted trade-off.
- Upload failure of one file is swallowed (catch → MESSAGE_ERROR); the file IS popped from the queue either way, but its `MoveRelative(..., "archive\\")` is skipped when the exception fires first — so a failed file is neither retried nor archived.
- The `ERROR_ALREADY_EXISTS` early return leaves the just-created/opened `hMutex` open forever (never `CloseHandle`d, never stored into `_data`) — a handle leak, though holding the abandoned-owned mutex until process exit is arguably the intent (it blocks other uploaders for that session). In the normal path the handle is stored and closed by `run()` once the queue drains.
- `crashEventData` is a static istringstream consumed by post(). Verified at the shared layer: `Http::post(std::istream&...)` never rewinds a non-external input stream (its only seeks are in the external-request size-limit branch), so whether a second crash-event POST in the same process carries a body depends on the platform HTTP sender reading from the current position — an exhausted stream would send an empty body.
