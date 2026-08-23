# RCCService.cpp

Source: `roblox-sandbox/RCCService/RCCService.cpp` (785 lines)

## Purpose

Process entry point (`_tmain`) for **RCCService** ("Roblox Compute Cloud Service") — the headless Windows service that hosts the gSOAP-based remote job API. This file owns:

1. Command-line dispatch (service control, install/uninstall, console mode, crash-reporter mode).
2. The Windows SCM (Service Control Manager) lifecycle: `ServiceMain`, control handler, install/uninstall/start/stop helpers.
3. The SOAP server accept loop (`startupRCC` / `stepRCC` / `shutdownRCC`) that farms each accepted connection to the thread pool.
4. Process-wide wiring done once at startup: access-key registry read, LFH heap opt-in, console log coloring, CRT leak-check flags.

The whole translation unit is compiled with `#pragma optimize("", off)` (line 26, restored `on` at line 785) — debugging posture over speed for the entry-point file itself.

## API

### `_tmain(int argc, _TCHAR* argv[])` (line 632)

Flags are case-insensitive; leading `/` is normalized to `-`. Multiple flags may be combined on one command line:

| Flag | Effect |
| --- | --- |
| `-Install` | `EventLogInstall()` + `SvcInstall()`; does not run the service. |
| `-Uninstall` | `SvcUninstall("RCCService")` + `EventLongUninstall()` (sic — typo'd name, line 670/453). |
| `-Start` | `SvcStart("RCCService")` — asks SCM to start the installed service. |
| `-Stop` | `SvcStop("RCCService")` — sends `SERVICE_CONTROL_STOP`. |
| `-Console` | Foreground run: bind + serve loop on the console thread. |
| `-CrashReporter` | Same as `-Console` but `crashUploaderOnly=true` is passed down to `start_CWebService`; the accept-pump loop is skipped entirely (lines 747–758). |
| `-AQTime` | Sets `RBX::nameThreads = false` (profiler compatibility). |
| `-Break` | Parsed by `parseBreakRequest`; after startup, one `::DebugBreak()` fires inside the main loop (lines 354–362). |
| `<number>` (positional) | Listen port via `parsePort` (line 221). **Default: 64989**. |
| `-Content:<dir>` | Content directory passed to `start_CWebService` (line 248). **Default `"Content\"`. |
| `-PlaceId:<id>` | Console mode only: auto-open a job that runs `start(<placeId>, 53640, '<baseURL>')` (lines 713–745). Script body is prefixed with whatever exists in `./gameserver.txt`, if present. |
| `-Md5:<hash>`, `-SettingsKey:<key>` | `RBX_TEST_BUILD` only (lines 293–305): set `RBX::DataModel::hash` and `RCCServiceSettingsKeyOverwrite`. |

With no recognized action flag, `isServiceCall` stays true and the process becomes a real Windows service via `StartServiceCtrlDispatcher` (line 771) with table `{SVCNAME, ServiceMain}`.

### Service lifecycle

- `ServiceMain` (line 326): creates manual-reset event `stopped` ("Stopped"), `RegisterServiceCtrlHandler("RCCService", Handler)`, reports `SERVICE_START_PENDING`, runs `startupRCC(parsePort, parseContent, false)`, reports `SERVICE_RUNNING`, then loops `stepRCC()` until state leaves RUNNING. On exit signals `stopped`.
- `Handler(DWORD)` (line 307): reports `SERVICE_STOP_PENDING`, calls `shutdownRCC()` (which calls `stop_CWebService()`), waits INFINITE on `stopped`, then reports `SERVICE_STOPPED`.
- `SvcInstall` (line 475): `CreateService(..., "RCCService", "Roblox Compute Cloud Service", SERVICE_ALL_ACCESS, SERVICE_WIN32_OWN_PROCESS, SERVICE_AUTO_START, SERVICE_ERROR_NORMAL, <own exe path>, LocalSystem)`. Tolerates `ERROR_SERVICE_EXISTS`. Then `ChangeServiceConfig2` failure actions: reset period 100 s, three `SC_ACTION_RESTART` entries delayed 5000 ms / 55000 ms / 60000 ms (lines 521–533).
- `EventLogInstall` (line 460): creates `HKLM\SYSTEM\CurrentControlSet\Services\Eventlog\Application\RCCService`, sets `EventMessageFile` = own image path (`REG_EXPAND_SZ`) and `TypesSupported = 0x1f`. `EventLongUninstall` deletes the subkey.
- `SvcReportEvent(WORD type, LPCTSTR)` (line 123): `RegisterEventSource(NULL, "RCCService")` + `ReportEvent` with message id `0x20000001L` (`GENERIC_MESSAGE`, defined by `Message.mc`), one string substitution.

### SOAP accept loop

- Globals: one process-wide `ExceptionAwareSoap<RCCServiceSoapService> service;` (line 104) and `static long requestCount` (line 28).
- `startupRCC(int port, LPCTSTR contentpath, bool crashUploaderOnly)` (line 148): calls `start_CWebService(contentpath, crashUploaderOnly)` (defined elsewhere — engine web layer), sets `service.accept_timeout = 1` (poll-style accept; commented-out send/recv timeouts remain visible), binds `service.bind(NULL, port, 100)`, logs "Service Started on port %d" both to stdout/StandardOut (`MESSAGE_SENSITIVE`) and the event log. Throws `std::runtime_error(*soap_faultstring(...))` on bind failure.
- `stepRCC()` (line 174):
  1. Backpressure guard: if `requestCount > 100`, throws `std::runtime_error` embedding `requestCount` itself plus all thirteen extern op counters defined in `RCCServiceSoapServiceImpl.cpp` (`diagCount`, `batchJobCount`, `openJobCount`, `closeJobCount`, `helloWorldCount`, `getVersionCount`, `renewLeaseCount`, `executeCount`, `getExpirationCount`, `getStatusCount`, `getAllJobsCount`, `closeExpiredJobsCount`, `closeAllJobsCount`) — fourteen values total in the message.
  2. `service.accept()` (returns early on timeout without error).
  3. `service.copy()` — the template's override clones the soap context (`soap_copy_context`), giving each connection its own serializer state.
  4. `QueueUserWorkItem(&process_request_func, copy, WT_EXECUTELONGFUNCTION)` — NT thread pool handles the request; failure crashes via `RBXCRASH()`.
- `process_request(RCCServiceSoapService*)` (line 47): increments `requestCount` (Interlocked), `service->serve()` then `delete service`; any escaping exception hits `RBXCRASH()`.
- `ExceptionAwareSoap<Soap>::dispatch()` (line 73): wraps base dispatch; `std::exception` → `soap_receiver_fault(e.what())`; `std::string` → `StringCrash()` which deliberately `RBXCRASH()`s **before** returning the fault (a string-typed exception is treated as fatal, not just a fault); anything else → `RBXCRASH()` then receiver fault.

### Startup helpers

- `ReadAccessKey()` (line 572): double-checked lazy load of `HKLM\Software\ROBLOX Corporation\Roblox\` value `AccessKey` into `RBX::Http::accessKey` under `keyLockMutex`; logs the key at `MESSAGE_SENSITIVE`.
- `PrintfLogger` (line 596): subscribes to `RBX::StandardOut::singleton()->messageOut`, recolors console text per severity (`MESSAGE_OUTPUT` blue, INFO white, WARNING yellow, ERROR bright red) and `printf`s each message.
- `_tmain` also enables CRT leak detection (`_CrtSetDbgFlag(_CRTDBG_ALLOC_MEM_DF | _CRTDBG_LEAK_CHECK_DF)`) and opts the process into the low-fragmentation heap via `RBX::UTIL::setWindowsNoFragHeap()` (line 640). Ends with `RBX::clearLuaReadOnly()` (line 782) — pairs with `OperationalSecurity.h`.

## Usage

Typical deployments (inferred from flags):

```
RCCService.exe -Install                 # one-time: register service + event log source
RCCService.exe                          # run as SCM service on default port 64989
RCCService.exe -Console 64989           # foreground debug instance
RCCService.exe -Console -PlaceId:1818 gameserver.txt present -> auto OpenJob test server
RCCService.exe -CrashReporter           # only the crash uploader subsystem starts
RCCService.exe -Start / -Stop / -Uninstall
```

## Gotchas

- **`requestCount` guard is a tripwire, not throttling**: exceeding 100 concurrent requests *throws*, logging every counter value; the exception is caught in `ServiceMain`'s loop and the loop continues. It exists so runaway request backlogs surface in logs/event viewer.
- **`parsePlaceId` has a C++ pointer-comparison quirk**: `if (placeId == "")` (line 288) compares `LPCTSTR` addresses, not contents. When `-PlaceId:` is absent, `parse()` returns its internal static buffer, the comparison is false, `atoi("")` yields 0, and since `0 > -1` the console mode will still fire a test `OpenJob` with place id 0. Only a non-empty `-PlaceId:` produces an intended id.
- **A `std::string` exception is intentionally fatal**: `StringCrash` calls `RBXCRASH()` even though the catch block continues to build a receiver fault afterwards (dead code path unless RBXCRASH is compiled out).
- **Single global soap context**: `service` is a process-global; `accept_timeout = 1` makes `stepRCC` a poller so the service can react to stop requests. Send/recv timeouts are left commented out (unbounded request time).
- **`-CrashReporter` reuses `-Console` plumbing**: it only differs in the `crashUploaderOnly` flag handed to `start_CWebService` and skipping the accept loop; there is no dedicated code path here.
- **`EventLongUninstall`** (line 453) is a typo for "EventLog..." but is internally consistent.
- **`-AQTime` disables thread naming globally**, affecting diagnostics when profiling.
- The file includes `logmanager.h`, `rbx/boost.hpp`, `Util/*`, `v8datamodel/datamodel.h` etc. from the wider engine tree; those dependencies live outside this folder (see INDEX.md).

UNKNOWN: exact behavior of `start_CWebService`/`stop_CWebService` (defined outside this folder); whether `GetBaseURL()` resolves from AppSettings or registry (declared elsewhere in the engine).
