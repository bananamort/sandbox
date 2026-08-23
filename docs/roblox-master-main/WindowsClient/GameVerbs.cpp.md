# WindowsClient/GameVerbs.cpp

## Purpose

Verb implementations: exit, screenshot capture/upload (Facebook-era flow), DirectShow video record/upload, fullscreen toggle. Notable for two BaseUrl-consuming endpoints (`/UploadMedia/PostImage.aspx`, `/UploadMedia/DoPostImage.ashx`, `/UploadMedia/UploadVideo.aspx`) and a dedicated helper thread in RecordToggleVerb that owns COM apartment state for DirectShow.

## API

Real signatures:

- `LeaveGameVerb::LeaveGameVerb(View& view, VerbContainer* container)` — `Verb(container, "Exit")`.
- `void LeaveGameVerb::doIt(IDataState*)` — `MainLogManager::getMainLogManager()->setLeaveGame(); v.CloseWindow();` (View::CloseWindow PostMessages WM_CLOSE ⇒ main.cpp WndProc shutdown chain).
- `ScreenshotVerb::ScreenshotVerb(const Document& doc, ViewBase* view, Game* game)` — `Verb(game->getDataModel().get(), "Screenshot")`; connects `dataModel->screenshotReadySignal` to `screenshotFinished`.
- `void ScreenshotVerb::doIt(IDataState*)` — submits `DataModel::TakeScreenshotTask` as a Write task.
- `void ScreenshotVerb::screenshotFinished(const std::string& filename)` — `view->getAndClearDoScreenshot()`; shows "Screenshot saved"; branches on `GameSettings::singleton().getPostImageSetting()`: ASK → marshaller-Submit `askUploadScreenshot` (with TODO/DE3515 comments noting the ask-UI was never built and upload is disabled server-side anyway); ALWAYS → `uploadScreenshot`; NEVER → nothing.
- `static void PostImageFinished(std::string* response, std::exception* ex, weak_ptr<DataModel>)` — "ok" ⇒ message "Image uploaded to Facebook"; else failure + reset setting to ASK; always submits `ScreenshotUploadTask(true/false)`. Carries its own TODOs ("Why Facebook?", "Make non-static").
- `void ScreenshotVerb::askUploadScreenshot(std::string filename)` — builds `<BaseUrl>/UploadMedia/PostImage.aspx?seostr=...&filename=...&screenshotdir=<pictures>&from=client&rand=<rand()>` and opens it in a modal `WebBrowserAxDialog dlg(url, game->getDataModel())`.
- `void ScreenshotVerb::uploadScreenshot(const std::string& filename)` — POSTs the screenshot file to `<BaseUrl>/UploadMedia/DoPostImage.ashx?from=client` via `RBX::Http`, with quirk header trick `http.additionalHeaders[seostr] = seostr + "%0D%0A"` ("in case the seo info contains nothing but whitespaces..."); failure paths ShowMessage + ScreenshotUploadTask under catch(...).
- `RecordToggleVerb::RecordToggleVerb(const Document&, View*, Game*)` — spawns `helper` thread running `action()` immediately at construction; creates `new VideoControl(new DSVideoCaptureEngine(), gfxView, frameRateManager, this)` wrapped in scoped_ptr.
- `void RecordToggleVerb::action()` — the helper thread loop: `CoInitializeEx(NULL, COINIT_APARTMENTTHREADED)`; while(!stop){ jobWait.Wait(); if(!stop){ DataModel::scoped_write_transfer request(...); job(); } jobDone.Set(); } CoUninitialize(); threadDone.Set(). All recording start/stop work runs on THIS thread with a transferred write lock.
- `RecordToggleVerb::~RecordToggleVerb()` — abortCapture if recording; then stop=true; jobWait.Set(); threadDone.Wait() (joins helper).
- `bool isEnabled() const` — `GameSettings::singleton().videoCaptureEnabled && isUploadingVideo()`; `isChecked()/isSelected()` — `videoControl->isVideoRecording()`.
- `void startAction()` — creates SoundService provider, `videoControl->startRecording(soundService)`, caches fileName, `videoRecordingSignal(true)`. `void stopAction()` — `stopRecording()`, signal false, unless upload setting == NEVER marshals `uploadVideo` onto UI thread.
- `void abortCapture()` — silent stopRecording if active.
- `void uploadVideo()` — opens `<BaseUrl>/UploadMedia/UploadVideo.aspx?from=client&videodir=<videos>&rand=` in `WebBrowserAxDialog browser(url, dm, boost::bind(&EnableVideUpload, this, _1))`; `browser.SetFileName(fileName); browser.DoModal(view->GetHWnd());` — the dialog callback drives videoUploadingEnabled.
- `void RecordToggleVerb::doIt(IDataState*)` — toggles: picks startAction or stopAction into `job`, signals jobWait, blocks on jobDone (UI thread waits for the capture thread).
- `ToggleFullscreenVerb(View&, VerbContainer*, VideoControl*)` — `Verb(container, "ToggleFullScreen")`; `isChecked()` = `view.IsFullscreen()`; `isEnabled()` = true; `doIt` FASTLOG(FLog::Verbs,"Gui:ToggleFullscreen") then `view.SetFullscreen(!view.IsFullscreen())`.

## Usage

Verbs are invoked by the engine's verb dispatch (F9 menu / accelerators routed via UserInput whitelist). The screenshot/video upload dialogs are the primary consumers of WebBrowserAxDialog besides RbxWebView.

## Gotchas

- `isEnabled()` for RecordToggle is confusingly named: returns enabled AND uploading-enabled (videoUploadingEnabled defaults true, flipped by the upload dialog callback).
- `uploadVideo`/`askUploadScreenshot` URLs leak local filesystem paths (`screenshotdir`/`videodir`) as query params — 2016 telemetry behavior.
- Duplicate includes of DSVideoCaptureEngine.h (lines 6, 9, 11) and VideoControl.h (8, 18) — verbatim sloppiness.
- doIt blocks the calling thread on CEvent handshake; deadlock risk if the helper thread dies without setting jobDone.
