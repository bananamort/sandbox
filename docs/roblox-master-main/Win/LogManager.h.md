# LogManager.h

Source: `roblox-sandbox/Win/LogManager.h` (159 lines)

## Purpose

Declares the Win32 logging + crash-reporting hierarchy: `LogManager` (per-thread log-file base class with COM-error/event reporting statics), `MainLogManager` (process-wide singleton implementing `RBX::ILogProvider`, owning the crash reporter, fast-log channels, log culling/gathering, session GUIDs, and assert/failure hooks), `ThreadLogManager` (thread-local variant handed out to non-main threads), and `RobloxCrashReporter` (minidump-producing `CrashReporter` subclass that uploads `.crashevent` files).

## API

```cpp
class LogManager {
    RBX::Log* getLog();
    static MainLogManager* getMainLogManager();
#ifdef _MFC_VER
    static HRESULT ReportCOMError(const CLSID&, CException*);
#endif
    static HRESULT ReportCOMError(const CLSID&, HRESULT);
    static HRESULT ReportCOMError(const CLSID&, LPCOLESTR, HRESULT hRes = 0);
    static HRESULT ReportCOMError(const CLSID&, LPCSTR, HRESULT hRes = 0);
    static HRESULT ReportExceptionAsCOMError(const CLSID&, std::exception const&);
    static void ReportException(std::exception const&);
    static void ReportLastError(LPCSTR message);
    static void ReportEvent(WORD type, LPCSTR message);
    static void ReportEvent(WORD type, LPCSTR message, LPCSTR fileName, int lineNumber);
    static void ReportEvent(WORD type, HRESULT hr, LPCSTR fileName, int lineNumber);
    const ATL::CPath& GetLogPath() const;
    virtual std::string getLogFileName() = 0;
protected:
    LogManager(const char* name);            // captures GetCurrentThreadId()
};

class RobloxCrashReporter : public CrashReporter {   // from network/CrashReporter.h
    static bool silent;
    RobloxCrashReporter(const char* outputPath, const char* appName, const char* crashExtention);
    LONG ProcessException(struct _EXCEPTION_POINTERS *info, bool noMsg);
protected: void logEvent(const char* msg); /*override*/
};

class MainLogManager : public RBX::ILogProvider, public LogManager {
    MainLogManager(LPCTSTR productName, const char* crashExtention, const char* crashEventExtention);
    RBX::Log* provideLog();
    std::string getLogFileName();  std::string getFastLogFileName(FLog::Channel);
    std::string MakeLogFileName(const char* postfix);
    bool hasErrorLogs() const;  bool hasCrashLogs(std::string extension) const;
    std::vector<std::string> gatherCrashLogs();          // *.dmp + associated logs
    std::vector<std::string> gatherAssociatedLogs(const std::string& pattern);
    void CullLogs(const char* folder, int filesRemaining);
    std::vector<std::string> gatherScriptCrashLogs();    // *.cse core-script-error logs, deduped vs archive
    void WriteCrashDump();                               // install RobloxCrashReporter via Start()
    bool CreateFakeCrashDump();                          // FastLog dump + literal "Fake" .dmp → triggers upload next start
    void NotifyFGThreadAlive();  void DisableHangReporting();
    void EnableImmediateCrashUpload(bool enabled);
    std::string getSessionId();  std::string getCrashEventName();
    enum GameState { UN_INITIALIZED = 0, IN_GAME, LEAVE_GAME };
    GameState getGameState();  void setGameLoaded();  void setLeaveGame();
    static void fastLogMessage(FLog::Channel id, const char* message);
private:
    static bool handleDebugAssert(const char*, const char*, int);
    static bool handleFailure(const char*, const char*, int);
    static bool handleG3DFailure(...);  static bool handleG3DDebugAssert(...);
    std::vector<std::string> getRecentCseFiles();
};

class ThreadLogManager : public LogManager {
    static ThreadLogManager* getCurrent();   // thread_specific_ptr, lazily created
};
```

## Usage

The client's single logging entry point. `WindowsClient/Application.cpp` constructs `MainLogManager`, which registers itself via `RBX::Log::setLogProvider(this)` so every engine `RBX::Log` write routes here; `provideLog()` returns the main-thread log or a per-thread `ThreadLogManager` log with `_<name>_<threadID>` inserted before the `.txt` suffix. Verified consumers of this header / the reporting statics: Win/{ErrorUploader.cpp, DumpErrorUploader.cpp, ScriptErrorUploader.cpp}, WindowsClient/{Application.h→View.cpp, Document.cpp}, RCCService/{RCCServiceSoapServiceImpl.cpp, RCCService.cpp, ThumbnailGenerator.cpp}, and CSG/CSGKernel.cpp (via `../Win/LogManager.h`). VideoControl/DSVideoCaptureEngine do NOT use it. Crash pipeline: `WriteCrashDump` at startup → SEH handler `ProcessException` → minidump + `DumpErrorUploader::UploadCrashEventFile`; WindowsClient later gathers/uploads via `gatherCrashLogs()/gatherScriptCrashLogs()`. Deadlock watchdog calls `NotifyFGThreadAlive()` once per second.

## Gotchas

- Log root is fixed at construction-time-of-first-use: `FileSystem::getUserDirectory(true, DirAppData, "logs")` frozen through `boost::call_once`; the deliberate `CString` conversion "preserves the old behavior of losing unicodeness" (in-source comment) — non-ASCII paths degrade.
- Session id is a GUID truncated twice (`erase(8)` then `erase(0,3)`) — 5 visible chars shared by all files of one run.
- `handleFailure`/pure-call handler deliberately call `RBXCRASH()` even in release; debug asserts only crash in `_DEBUG`.
- `CreateFakeCrashDump` writes a 5-byte literal `"Fake"` file as a valid `.dmp` — upload-side must tolerate it.
- `hasErrorLogs()` is declared here but defined NOWHERE in the tree (verified by grep) — dead declaration; any ODR-use fails to link.
- Header drags in ATL (`atlpath.h`, `atlutil.h`), MFC-conditional code, and `network/CrashReporter.h` — not a lightweight include.
