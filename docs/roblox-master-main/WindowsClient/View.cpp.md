# WindowsClient/View.cpp

## Purpose

Implementation of `RBX::View` (View.h). Three responsibilities: (1) graphics-backend creation with fallback chain (`initializeView`) — this is where `initialization_error` "graphics drivers too old" originates and propagates out of `Application::Initialize`; (2) window/fullscreen lifecycle — resolution switching via `ChangeDisplaySettingsEx`, style/placement juggling, foreground-forcing; (3) per-game wiring in `Start()`/`Stop()` — binds the DataModel into the GfxDLL view, creates the RenderJob and UserInput, registers them with the TaskScheduler. Declares the module's FastFlags: `DirectXEnable`, `DirectX11Enable`, `GraphicsReportingInitErrorsToGAEnabled`, `UseNewAppBridgeInputWindows` (FFlagVARIABLE) and `FullscreenRefocusingFix` (DYNAMIC_FASTFLAGVARIABLE), plus LOGGROUPs `PlayerShutdownLuaTimeoutSeconds` and `RobloxWndInit`.

## API

Real signatures (namespace `RBX` unless noted):

- `View::View(HWND h)` — sets `context.hWnd`, seeds `desireFullscreen` from `GameBasicSettings::singleton().getFullScreen()`, grabs the process-wide `FunctionMarshaller::GetWindow()`, then calls `initializeView()` **in the ctor** (graphics device exists as soon as `new View(...)` returns).
- `View::~View()` — `RBXASSERT(!this->game && "Call Stop() before shutting down!")`; resets `view`; releases the marshaller reference.
- `void View::Start(const shared_ptr<Game>& game)` — asserts no current game; order matters: `bindWorkspace()` (DataModel LegacyLock Write → `view->bindWorkspace(dm)` + `view->buildGui()`) → `initializeJobs()` (`new RenderJob(this, marshaller, dataModel)`) → `initializeInput()` (`new UserInput(GetHWnd(), game, this)` under a Write lock, then `ControllerService::setHardwareDevice(userInput.get())`) → `resetScheduler()` (`TaskScheduler::add(renderJob)`) → `userInput->setKeyboardDesired(true)` (DE6272 keyboard-focus fix).
- `void View::Stop()` — `RemoveJobs()` → detaches ControllerService hardware device → `userInput->removeJobs(); userInput.reset()` → `unbindWorkspace()` → `saveWindowSettings()` → `game.reset()`.
- `static void View::initializeView()` (private) — backend selection algorithm:
  - `ViewBase::InitPluginModules()` first.
  - Builds a fallback list: if `FFlag::DirectXEnable` off → `[OpenGL]` only; else latched mode first when it is NoGraphics/D3D9/D3D11/OpenGL-specific; default order `[D3D11 if DirectX11Enable] → D3D9 → OpenGL`.
  - Loops `ViewBase::CreateView(graphicsMode, &context, &CRenderSettingsItem::singleton())` + `view->initResources()`, catching `std::exception` per mode and appending messages to `lastMessage`.
  - Total failure: if `GraphicsReportingInitErrorsToGAEnabled`, `RobloxGoogleAnalytics::trackEventWithoutThrottling(GA_CATEGORY_GAME, "GraphicsInitError"|"GraphicsInitErrorNoModes", lastMessage + GPU make + osVer)`; `::WriteProfileString("Settings","lastGFXMode","-1")`; throws `initialization_error("Your graphics drivers seem to be too old for Roblox to use.\n\nVisit http://www.roblox.com/drivers ...")`.
  - Success writes `lastGFXMode` profile string, then `initializeSizes()`.
- `void View::ShowWindow()` — the deferred first-show called from a background thread after join gating: maximized (`SW_SHOWMAXIMIZED`) or `SW_SHOWNORMAL` + `SetWindowPlacement` from `GameBasicSettings` `getStartScreenPos/getStartScreenSize` (only when not fullscreen and rect non-zero); focus via `marshaller->Submit(boost::bind(&SetFocusWrapper, hWnd))` because `SetFocus` has thread affinity; foreground steal by toggling `HWND_TOPMOST` → `HWND_NOTOPMOST` ("more reliable than HWND_TOP"); finally `SetFullscreen(true)` if the persisted full-screen setting says so.
- `bool View::SetFullscreen(bool value)` — entering: saves `GWL_STYLE` into `restoreWindowStyle` then `changeResolution()`; leaving: `restoreResolution()`. Always persists via `GameBasicSettings::singleton().setFullScreen(value)`.
- `void View::changeResolution()` — snapshots placement into `nonFullscreenPlacement` (skipped when `DFFlag::FullscreenRefocusingFix && already fullscreen`); `MonitorFromWindow(MONITOR_DEFAULTTONEAREST)`; re-runs `initializeSizes()` ("in case user has modified desktop settings during program run"); `findBestMonitorMatch(...)`; `ChangeDisplaySettingsEx(mi.szDevice, &dm, NULL, CDS_FULLSCREEN, NULL)` unless an exact match was found; on success `modifyWindow(WS_VISIBLE|WS_POPUP|WS_CLIPSIBLINGS|WS_CLIPCHILDREN, monitorRect)`.
- `void View::restoreResolution()` — hides the window *before* `ChangeDisplaySettingsEx(device, NULL, ...)` (comment: otherwise it wrongly reports success), re-shows `SW_SHOWNORMAL`, restores style (or `WS_OVERLAPPEDWINDOW` fallback), `SetWindowPlacement(&nonFullscreenPlacement)`.
- `bool View::findBestMonitorMatch(LPCTSTR szDevice, int desiredX, int desiredY, bool resolutionAuto, DEVMODE& dmBest)` — keeps current mode if it already covers the desired height and `resolutionAuto`; else picks the enumerated mode within 10 % aspect ratio, same bpp/frequency, closest pixel count to desired; sets `dmBest.dmFields = DM_PELSWIDTH|DM_PELSHEIGHT` only; returns true when no switch needed.
- `void View::rememberWindowSettings()` / `saveWindowSettings()` — capture `WINDOWPLACEMENT` (+ task-bar-aware rect adjustment by probing `FindWindow("Shell_traywnd")`); later flushed under a DataModel Write lock into `GameBasicSettings` `setStartScreenSize/setStartScreenPos/setStartMaximized`. `AboutToShutdown()` = `rememberWindowSettings()` only.
- `void View::RemoveJobs()` — `TaskScheduler::singleton().removeBlocking(renderJob, callback)` where callback is `boost::bind(&FunctionMarshaller::ProcessMessages, marshaller)`, then an explicit `marshaller->ProcessMessages()` to drain a possibly-asynchronously-marshalled final `renderPerform` before `renderJob.reset()` (explicit use-after-free guard).
- `void View::HandleWindowsMessage(UINT uMsg, WPARAM wParam, LPARAM lParam)` — WM_ACTIVATE: on activate while fullscreen(-desired) and not mid-switch → `changeResolution()` + `SW_RESTORE` + focus + HWND_TOP; on deactivate while fullscreen (and activating window not our child) → popup-style + refocus. All other messages go to `userInput->postUserInputMessage(...)` unless `FFlag::UseNewAppBridgeInputWindows` is set.
- Remaining small members: `OnResize(WPARAM,int,int)` → `view->onResize(cx,cy)`; `getDataModel()`; `GetLatchedGraphicsMode()` (delegates to `CRenderSettingsItem::singleton()`); `IsFullscreen()`; `calcDefaultResolution(float aspect_XdivY)` (video-memory heuristic: ≤32 MB→600 lines, ≤64→1024, ≤128→1200, ≤256→1280, else 1600; Intel cards special-cased — "828" chip → 600, other Intel → 1200, because "Intel videocards report random amount of video memory"); `getCurrentDesktopResolution()` (defaults 800×600 on any failure); file-scope `namespace { HWND SetFocusWrapper(HWND) }`.

## Usage

Join flow (this file is one half of the precision pair Teleporter/View): Teleporter drives Document/Application to build the Game; once the Game exists, Application calls `View::Start(game)` — bind workspace → RenderJob → UserInput → scheduler. The window stays hidden until the post-join path invokes `ShowWindow()` (from the pre-roll/waitEvent sequence, see Teleporter.cpp), which applies persisted geometry and forces foreground. Teardown mirror-image: `Stop()` drains render/marshalled work before freeing anything.

## Gotchas

- Graphics device creation happens in the constructor; a machine with no working backend makes `new View(hWnd)` throw through `Application::Initialize`, producing main.cpp's invisible-window error path.
- `kSavedScreenSizeRegistryKey` (`HKCU\...\RobloxPlayerV4WindowSizeAndPosition`, lines 42–43) is declared but never referenced — window settings actually round-trip through GameBasicSettings. Dead constant.
- `cxBorder/cyBorder` are fetched via GetSystemMetrics then unconditionally zeroed (`cxBorder = cyBorder = 0;`) — leftover experiment in `changeResolution`.
- The `sequence` member (a boost shared_ptr<Tasks::Sequence> declared in View.h) never appears in this file — dead member, as noted in View.h.md.
- Stray `{{{ }}}` double-brace block around the Google Analytics call (lines 220–226) — compiles as nested scopes, harmless but confusing.
- Log-string typo `"view::geCurrentDesctopResolution"` and log typo `"Done Vew::restoreResolution"` are verbatim in source.
- `findBestMonitorMatch` returns `match=true` meaning "current mode already good — do NOT call ChangeDisplaySettingsEx"; callers must honor that convention.
- `HandleWindowsMessage` swallows everything except WM_ACTIVATE when `UseNewAppBridgeInputWindows` is on — input would then be expected from the newer app bridge (not present in this snapshot).
