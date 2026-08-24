# Network/CrashReporter.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 446 lines, Windows-only `#ifdef _WIN32`)

## Purpose

Implements the Windows crash/hang reporter: installs a top-level `UnhandledExceptionFilter` (patching out CRT's `SetUnhandledExceptionFilter` reset via an x86 jmp hook and disabling the 64-bit user-mode callback exception filter), writes MiniDump+/Full-memory dumps via `MiniDumpWriteDump`, runs dump collection on a watcher thread (so stack overflows are capturable), detects 3-minute heart-beat hangs (`NotifyAlive`/`EnableHangReporting`), and relaunches the exe with `-d` to upload dumps (skipped for RCCService).

## API

```cpp
DFInt::WriteFullDmpPercent(0)
extern std::string RBX::specialCrashType; extern bool RBX::gCrashIsSpecial;   // security-exploit tagging

class CrashReporter {
    static CrashReporter* singleton;
    void Start();                                   // SetUnhandledExceptionFilter + anti-reset patch + watcher thread
    LONG ProcessException(EXCEPTION_POINTERS*, bool noMsg);       // full-dmp sampling; special-crash Influx "report"+GA "LoggableCrash"
    LONG ProcessExceptionInThead(...);              // hand off to watcher for stack overflow
    HRESULT GenerateDmpFileName(...);               // <path>\<app version>[.Full].dmp
    void WatcherThreadFunc();                       // 3-min wait loop; hang → printJobs + forced dump + upload
    void LaunchUploadProcess();                     // CreateProcess("<self>" -d), non-RCC only
    void EnableImmediateUpload(bool); void DisableHangReporting(); void NotifyAlive();
};
static LONG WINAPI CrashExceptionFilter(...);       // _exit(EXIT_FAILURE) after dump — no cleanup by design
void PreventSetUnhandledExceptionFilter();          // x86-only (#error otherwise): jmp-patch kernel32 export
void fixExceptionsThroughKernel();                  // clears PROCESS_CALLBACK_FILTER_ENABLED policy
```

## Usage

Started during app init; `NotifyAlive()` is called from the main loop so hangs can be distinguished from quiet periods.

## Gotchas

- Special ("loggable") crashes under RCC bypass the sampling path and always report type+filename to InfluxDB (`"report"`, 10000=hundredths %) and throttling-exempt GA.
- Hang dumps request full memory (`true` passed as writeFullDmp) and only fire once per session.
- The process deliberately `_exit`s post-dump to avoid destructor deadlocks.
