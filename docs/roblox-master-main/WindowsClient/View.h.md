# WindowsClient/View.h

## Purpose

Header for `RBX::View` — "class responsible for the game view": owns the GfxDLL `ViewBase`, the RenderJob, UserInput, fullscreen/resolution management, and window placement persistence. References but does not own the Game.

## API

```cpp
class View {
public:
    View(HWND h);
    ~View();
    void AboutToShutdown();
    void Start(const shared_ptr<Game>& game);
    void Stop();
    void OnResize(WPARAM wParam, int cx, int cy);
    void ShowWindow();
    void CloseWindow();                       // PostMessage(GetHWnd(), WM_CLOSE)
    void HandleWindowsMessage(UINT uMsg, WPARAM wParam, LPARAM lParam);
    HWND GetHWnd() const;                     // from context.hWnd
    ViewBase* GetGfxView() const;             // TODO: refactor verbs so this isn't needed
    CRenderSettings::GraphicsMode GetLatchedGraphicsMode();
    bool IsFullscreen();
    void SetFullscreen(bool value);
    shared_ptr<DataModel> getDataModel();
private:
    shared_ptr<Game> game;                    // referenced, not owned
    OSContext context;
    bool fullscreen, desireFullscreen, changedResolution, changingResolution;
    std::vector<G3D::Vector2int16> fullScreenSizes;
    WINDOWPLACEMENT nonFullscreenPlacement;
    DWORD restoreWindowStyle;
    HMONITOR hMonitor;
    boost::scoped_ptr<RBX::ViewBase> view;    // graphics backend (D3D9/D3D11/OpenGL)
    FunctionMarshaller* marshaller;
    boost::scoped_ptr<UserInput> userInput;
    boost::shared_ptr<Tasks::Sequence> sequence;
    boost::shared_ptr<RenderJob> renderJob;
    bool windowSettingsValid; Vector4 windowSettingsRectangle; bool windowSettingsMaximized;
    void modifyWindow(DWORD argMask, const RECT& area);
    bool findBestMonitorMatch(LPCTSTR szDevice, int desiredX, int desiredY,
                              bool resolutionAuto, DEVMODE& dmBest);
    void changeResolution(); void restoreResolution();
    G3D::Vector2int16 calcDefaultResolution(float aspect_XdivY);
    G3D::Vector2int16 getCurrentDesktopResolution();
    void initializeSizes(); void bindWorkspace(); void unbindWorkspace();
    void initializeView(); void initializeInput(); void resetScheduler();
    void initializeJobs(); void RemoveJobs();
    void rememberWindowSettings(); void saveWindowSettings();
};
```

## Usage

Constructed once per non-teleport game by Application (`new View(hWnd)`); `Start(game)` after Document::Initialize; `ShowWindow()` invoked later on a background thread when pre-roll/waitEvent gating releases; `Stop()` before document teardown.

## Gotchas

- The ctor immediately calls `initializeView()` — graphics device creation happens in `new View(...)`, throwing `initialization_error` up through Application::Initialize if all backends fail.
- `sequence` member is never used in View.cpp (dead).
