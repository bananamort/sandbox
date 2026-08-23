# DSVideoCaptureEngine.cpp

Source: `roblox-sandbox/Win/DSVideoCaptureEngine.cpp` (1305 lines)

## Purpose

DirectShow video recording: defines two custom push-source filters (`DS::CVideoStreamFilter`/`CVideoStream` — 32-bit RGB frames, `CLSID_GameVideoStream`; `DS::CAudioStreamFilter`/`CAudioStream` — 16-bit 48 kHz stereo PCM fed by an FMOD DSP tap named "SCRBX" via `SoundState::createDSPFunction`), then wires them into a filter graph ending in the WM ASF writer (`CLSID_WMAsfWriter`) to produce `.wmv` files under the user's video directory. `pushNextFrame` downloads the D3D framebuffer, letterboxes/flips it into a 16:9 canvas, and queues it for the encoder thread.

## API / key constants

```cpp
const char VidCapID[] = "VideoCapture";          // statistics channel
#define ERROR_ON_FAIL(expr)                      // printf + goto Error
namespace RBX::DS {
    DEFINE_GUID CLSID_GameVideoStream / CLSID_GameAudioStream;
    const LPWSTR RbxVideoId=L"RBXVideo", VideoFileExt=L"wmv", ProcTitle=L"robloxapp", RbxAudioId=L"RBXAudio";
    const int MaxWaitTime = 500;                 // ms the FillBuffer waits on an empty queue ("2fps is very bad")
    const int MaxFramesQueue = 5;                // OOM guard on slow machines
    const int DefSampleRate = 48000;
}
DSVideoCaptureEngine::DSVideoCaptureEngine();    // CoInitializeEx(APARTMENTTHREADED); defNx=16, defNy=9; MaxRecordTime=30min
~DSVideoCaptureEngine();                         // stop() if running; CoUninitialize
bool start(int cx, int cy, SoundState* s);
    // audio only when enabledFunction() && sampleRate==48000 → BuildCaptureGraphNoThrow
    // otherwise reports statistic and retries with forceNoAudio=true; mediaControl->Run(); frameData=cx*cy*4 buffer
bool stop();                                     // StopSoundCapture; MediaControl->Stop (retry after Sleep(1000)); DestroyCaptureGgaph
bool isRunning();                                // mediaControl->GetState(INFINITE)==State_Running
void setVideoQuality(int vq);                    // EMPTY no-op
void GetSquareSizes(cx,cy,&ncx,&ncy);            // normalize to 16:9, round up to multiple of 4 ("graph will not start" otherwise)
void pushNextFrame(void* device, Verb* cancelAction);
LONG GetTime(); LONG GetAbsoluteTime();          // timeGetTime()-startTime
HRESULT BuildCaptureGraph(cx, cy, forceNoAudio); // FilterGraph + GameVideoSource + WMAsfWriter + profile (WMV2 1 Mbps 854x480 Vista+,
                                                 //  WMV3 100 kbps XP variants; audio profile only on Vista+ w/ sound enabled)
int GenerateFileName(LPWSTR);                    // "<DirVideo>\robloxapp-YYYYMMDD-HHMMSS<0.1s>.wmv" via GetLocalTime
void DestroyCaptureGgaph();                      // SAFE_RELEASE graph/mediaControl; drops filter pointers
```

## Usage

Constructed by WindowsClient/GameVerbs.cpp inside `VideoControl` for the record-video verbs; frames arrive from `VideoControl::onFrameData` per render step. Audio taps the live FMOD DSP chain through the `SoundState` bound at start.

## Gotchas

- **Hard limits cancel recording**: >30 min (`MaxRecordTime`), a lost main framebuffer, or a window resize all trigger `cancelAction->doIt(NULL)` — resize additionally posts a GuiService notification "Recording Stopped / Because game window resolution changed".
- Frame pacing: pushes are throttled to one per ~55 ms (`GetTargetFrameRate()`) AND dropped while the queue holds ≥5 frames.
- Pixel work per frame: BGRA→BGR channel swap on every pixel, vertical flip, and letterbox into the padded 16:9 canvas; ownership of the allocated `videoData` transfers to `CVideoStream` (deleted after encode).
- `setVideoQuality` does nothing — the quality value collected by VideoControl has no effect on this backend.
- `BuildCaptureGraphNoThrow` wraps graph building in SEH `__except(true)` (catches access violations from DirectShow), returning E_FAIL.
- `FillBuffer` computes `frameRate = audioTime->GetAbsoluteTime() / pushedFrames` — average inter-frame interval used as the next sample duration; early frames can carry odd timestamps.
- The four giant WMASF profile XML strings embed fixed 854x480 geometry; capture resolution is independent of them (the muxer rescales).
- `GenerateFileName` uses `_snwprintf_s` with a `%01d` tenth-of-second field for uniqueness and appends via boost::filesystem; the "TODO: Localization: Unicode????" remains.
