# VideoControl.cpp

Source: `roblox-sandbox/Win/VideoControl.cpp` (124 lines)

## Purpose

Implements VideoControl's recording lifecycle: constructor seeds quality from GameSettings; `startRecording` builds a SoundState bound to the live SoundService (FMOD DSP tap), installs `onFrameData` as the ViewBase frame callback via `setFrameDataCallback` (which returns the render dimensions used to start the capture), and pauses FrameRateManager auto-adjustment so recorded footage has stable timing; `stopRecording` uninstalls the callback, stops capture, resumes FPS adjustment, and marks `recorded = true` for upload gating.

## API

```cpp
VideoControl::VideoControl(IVideoCapture* capture, ViewBase* rbxView,
                           FrameRateManager* frameRateManager, Verb* verb);
    // RBXASSERT(verb/rbxView); videoQuality=-1 then setVideoQuality(GameSettings::...getVideoQualitySetting())
bool VideoControl::isVideoRecordingStopped();  // !capture->isRunning()
bool VideoControl::isVideoRecording();         // capture->isRunning()
bool VideoControl::isVideoPaused();            // false
bool VideoControl::isReadyToUpload();          // recorded && !capture->isRunning()
void VideoControl::startRecording(Soundscape::SoundService* soundservice);
    // SoundState{createDSP/getSampleRate/enabled binds}; dims = rbxView->setFrameDataCallback(bind onFrameData)
    // captureStarted = dims.first && dims.second && capture->start(cx, cy, soundState.get()); RBXASSERT
    // frameRateManager->PauseAutoAdjustment(); recorded=false
void VideoControl::stopRecording();            // recorded=true; capture->stop();
                                               // ResumeAutoAdjustment(); setFrameDataCallback(empty)
void VideoControl::pause()/unPause();          // no-ops
void VideoControl::setVideoQuality(int vq);    // capture->setVideoQuality(vq)
static void logError(std::string);             // StandardOut MESSAGE_ERROR
void VideoControl::onFrameData(void* device);  // if running: capture->pushNextFrame(device, verb)
```

## Usage

Driven from WindowsClient recording verbs/UI. Includes d3d9/d3dx9 (NOMINMAX defined first), v8datamodel/{ContentProvider,GameSettings}, GfxBase/{FrameRateManager,ViewBase}. The concrete IVideoCapture in this directory is DSVideoCaptureEngine.

## Gotchas

- If `capture->start` fails, the frame callback REMAINS installed and FPS adjustment stays unpaused but `recorded` stays false — only the RBXASSERT fires (no-op in release).
- Recording start requires nonzero dimensions from setFrameDataCallback; zero dims silently skip starting.
- stopRecording clears the callback with an empty boost::function rather than a documented "remove" API — callers must treat empty as unregister.
