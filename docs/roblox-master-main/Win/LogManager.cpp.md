# LogManager.cpp

Source: `roblox-sandbox/Win/LogManager.cpp` (862 lines)

## Purpose

Implements the full Win32 log/crash machinery declared in LogManager.h: `%USERDIR%/logs` path resolution (call_once), session-id file naming (`log_<id>[postfix].txt`, `log_<id>_<channel>.txt`), FastLog channel fan-out, `RobloxCrashReporter` minidump config + `.crashevent` upload, crash-log/script-crash-log gathering with archive dedup, log culling by creation time, the assert/failure/pure-call hooks that convert engine failures into minidumps, and ATL COM error reporting.

## API

```cpp
static const ATL::CPath& DoGetPath();  void InitPath();          // logs dir under %APPDATA%-equivalent
std::string GetAppVersion();                                     // CVersionInfo from _AtlBaseModule.m_hInst

void MainLogManager::fastLogMessage(FLog::Channel id, const char* message);   // lazy per-channel RBX::Log
std::string MainLogManager::getSessionId();      // guid.erase(8).erase(0,3)
std::string MainLogManager::getCrashEventName(); // "log_<id> <version><crashEventExtention>"
std::string MainLogManager::getLogFileName();    // "log_<id>.txt"
std::string MainLogManager::getFastLogFileName(FLog::Channel);  // "log_<id>_<channel>.txt"
std::string MainLogManager::MakeLogFileName(const char* postfix);
RBX::Log* LogManager::getLog();                  // lazy new RBX::Log(getLogFileName(), name)
RBX::Log* MainLogManager::provideLog();          // main thread → own log; else ThreadLogManager::getCurrent()

MainLogManager::MainLogManager(LPCTSTR productName, const char* crashExtention, const char* crashEventExtention);
  // generates GUID; CullLogs("\\",1024) + CullLogs("archive\\",1024);
  // mainLogManager = this; Log::setLogProvider(this);
  // setAssertionHook(handleDebugAssert), setFailureHook(handleFailure);
  // _set_purecall_handler(purecallHandler); FLog::SetExternalLogFunc(fastLogMessage)

LONG RobloxCrashReporter::ProcessException(_EXCEPTION_POINTERS*, bool noMsg); // super::ProcessException,
  // one-shot MessageBox "An unexpected error occurred and ROBLOX needs to quit.", UploadCrashEventFile(info)
void RobloxCrashReporter::RobloxCrashReporter(outputPath, appName, crashExtention);
  // MiniDumpWithDataSegs (+MiniDumpWithIndirectlyReferencedMemory on Vista+ via IsVistaPlus())

void MainLogManager::WriteCrashDump();
bool MainLogManager::CreateFakeCrashDump();      // FLog::WriteFastLogDump + "Fake" dmp
void MainLogManager::EnableImmediateCrashUpload(bool);
void MainLogManager::DisableHangReporting();
void MainLogManager::NotifyFGThreadAlive();      // crashReporter->NotifyAlive()
void MainLogManager::CullLogs(const char* folder, int filesRemaining);   // oldest-first DeleteFile
std::vector<std::string> MainLogManager::gatherCrashLogs();              // *.dmp + first-9-chars wildcard siblings
std::vector<std::string> MainLogManager::gatherAssociatedLogs(const std::string& pattern);
std::vector<std::string> MainLogManager::gatherScriptCrashLogs();        // *.cse rename+dedup vs recent archives
bool MainLogManager::hasCrashLogs(std::string) const;
// NB: `hasErrorLogs()` is declared in LogManager.h but has NO definition anywhere in this tree (dead declaration).

HRESULT LogManager::ReportCOMError(...4 overloads...);   // AtlSetErrorInfo via RbxReportError helpers
void LogManager::ReportException(std::exception const&);
void LogManager::ReportLastError(LPCSTR);                // GetLastError() printf
void LogManager::ReportEvent(WORD type, LPCSTR message [,...]);  // StandardOut + ATLTRACE(debug)

static bool handleDebugAssert/handleFailure/handleG3DFailure/handleG3DDebugAssert(...);
static void purecallHandler(void);                       // ReportEvent + _CrtDbgBreak + RBXCRASH()
ThreadLogManager* ThreadLogManager::getCurrent();       // boost thread_specific_ptr, once-init
```

## Usage

Runs as the process-wide logging backbone of the Windows client and RCC: `WindowsClient/Application.cpp:80` builds `logManager("Roblox", ".Client.dmp", ".Client.crashevent")` as a member; `RCCService/RCCServiceSoapServiceImpl.cpp:377` builds `("Roblox Web Service", ".dmp", ".crashevent")`. `InitPath()` is also invoked from other TUs needing the logs dir. `gatherCrashLogs()`/`gatherScriptCrashLogs()`/`hasCrashLogs()` feed ErrorUploader/DumpErrorUploader upload passes at next launch. `fastLogMessage` is installed as `FLog::SetExternalLogFunc` so all FASTLOG traffic lands in per-channel files. Cross-dir consumers include Win/DumpErrorUploader.cpp and Win/ErrorUploader.cpp.

## Gotchas

- `#define MAX_CONSOLE_LINES 250;` — macro definition carries a trailing semicolon (line 190); unused here but a copy-paste landmine.
- `getThisYearTimeInMinutes` uses magic month constant 43829.0639f (avg minutes/month) — year-boundary comparisons rely on the separate `curTime.wYear > fileTime.wYear` check.
- `gatherCrashLogs` assumes dump names start with a 9-char session prefix (`wildCard.substr(0,9) + "*.*"`) to associate logs — renaming scheme changes break association.
- `gatherScriptCrashLogs` renames pending `.cse` files to embed CURRENT sessionId (in-source comment admits it isn't the original session's id, just for uniquing).
- `ProcessException`'s one-shot MessageBox guard uses function-local `static bool showedMessage = silent;` — silent-mode init happens once, process-wide.
- Crash reporter strips unicode from paths (see header doc); `strcpy(controls.pathToMinidump, outputPath)` has no bounds check.
- `LogManager::~LogManager` deletes `log` so the file closes before archiving ("this will close the file so that we can move it").
- Debug-only `ATLTRACE` duplicates every ReportEvent message.
