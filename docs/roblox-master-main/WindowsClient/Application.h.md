# WindowsClient/Application.h

## Purpose

Class header for `RBX::Application` — the owner of the whole client shell: window plumbing, command line, settings loading, join/teleport orchestration (Document + View + verbs), crash reporting, anti-tamper kickoff, and the Teleporter. Included by main.cpp; the harness's top-level handle to everything.

## API

```cpp
class Application {
    enum RequestPlaceInfoResult { SUCCESS, FAILED, RETRY, GAME_FULL, USER_LEFT };
public:
    Application();
    ~Application();
    bool Initialize(HWND hWnd, HINSTANCE hInstance);
    bool LoadAppSettings(HINSTANCE hInstance);
    void AboutToShutdown();
    void Shutdown();
    bool ParseArguments(const char* argv);
    void HandleWindowsMessage(UINT uMsg, WPARAM wParam, LPARAM lParam);
    void OnResize(WPARAM wParam, int cx, int cy);
    void Teleport(const std::string& authenticationUrl,
                  const std::string& ticket,
                  const std::string& scriptUrl);
    void UploadSessionLogs();
    void OnHelp();
    std::string WaitEventName() { return waitEventName; }
    static void OnGetMinMaxInfo(MINMAXINFO* lpMMI);
private:
    boost::scoped_ptr<boost::thread> launchPlaceThread, reportingThread;
    void LaunchPlaceThreadImpl(const std::string& placeLauncherUrl);
    void InferredCrashReportingThreadImpl();
    void InitializeNewGame(HWND hWnd);
    void StartNewGame(HWND hWnd, HttpFuture& scriptResult, bool isTeleport);
    void initializeLogger(); void setWindowFrame(); void initializeCrashReporter();
    void uploadCrashData(bool userRequested); void handleError(const std::exception& e);
    bool requestPlaceInfo(int placeId, std::string& authenticationUrl,
                          std::string& ticket, std::string& scriptUrl) const;
    RequestPlaceInfoResult requestPlaceInfo(const std::string url, ... ) const;
    void renewLogin(...) const; HttpFuture renewLoginAsync(...) const;
    HttpFuture loginAsync(const std::string& userName, const std::string& passWord) const;
    void shareHwnd(HWND hWnd); const char* getVRDeviceName();
    rbx::atomic<int> enteredShutdown;
    HANDLE processLocal_stopPreventMultipleJobsThread, processLocal_stopWaitForVideoPrerollThread;
    HWND mainWindow; HANDLE mapFileForWnd; LPCTSTR bufForWnd;
    LONG stopLogsCleanup; ATL::CEvent clenupFinishedEvent;
    boost::scoped_ptr<boost::thread> logsCleanUpThread; void logsCleanUpHelper();
    void waitForNewPlayerProcess(HWND hWnd); void waitForShowWindow(int delay);
    void validateBootstrapperVersion();
    static void onMessageOut(const StandardOutMessage& message);
    std::string getversionNumber();              // declared; no definition in this module (UNKNOWN)
    SharedLauncher::LaunchMode launchMode;
    boost::scoped_ptr<View> mainView; boost::scoped_ptr<RbxWebView> webView;
    po::variables_map vm;                        // parsed command line
    std::string moduleFilename, globalBasicSettingsPath, waitEventName;
    boost::scoped_ptr<Document> currentDocument;
    bool crashReportEnabled, hideChat; MainLogManager logManager;
    boost::scoped_ptr<DumpErrorUploader> dumpErrorUploader;
    boost::shared_ptr<CProcessPerfCounter> processPerfCounter;
    boost::shared_ptr<ProfanityFilter> profanityFilter;
    boost::scoped_ptr<boost::thread> singleRunningInstance, showWindowAfterEvent,
                                     validateBootstrapperVersionThread;
    Teleporter teleporter; FunctionMarshaller* marshaller;
    bool spoofMD5;                               // DEBUG/NOOPT only
    boost::scoped_ptr<ToggleFullscreenVerb> toggleFullscreenVerb;
    boost::scoped_ptr<LeaveGameVerb> leaveGameVerb;
    boost::scoped_ptr<RecordToggleVerb> recordToggleVerb;
    boost::scoped_ptr<ScreenshotVerb> screenshotVerb;
    void initVerbs(); void shutdownVerbs();
    void openUrlInBrowserApp(const std::string url); void closeBrowser();
    void doOpenUrl(const std::string url); void doCloseBrowser();
    void onDocumentStarted(bool isTeleport);
};
```

Also includes: `RBX::Analytics::InfluxDb::Points analyticsPoints` member; forward declarations for Game/UserInput/RenderJob/RbxWebView/Document/View/Tasks::Sequence.

## Usage

Owned as a stack object by `_tWinMain`. Lifecycle calls in order: ctor → `LoadAppSettings` → `ParseArguments` → `Initialize` → (message-pump era: HandleWindowsMessage / OnResize / Teleport via Teleporter) → `AboutToShutdown` (WM_DESTROY or machine-ban) → `Shutdown`.

## Gotchas

- `getversionNumber()` is declared but has no definition anywhere in WindowsClient — never called, would link-fail if used.
- `mainView` is reset/recreated on every non-teleport `StartNewGame`; during teleport it must survive (`RBXASSERT(mainView)`).
- `spoofMD5` only settable in LOVE_ALL_ACCESS/_DEBUG/_NOOPT builds (`--md5`).
- `waitEventName` doubles as an obfuscated trigger channel for ReleasePatcher magic values (see Application.cpp ParseArguments).
