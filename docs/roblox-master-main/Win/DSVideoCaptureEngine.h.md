# DSVideoCaptureEngine.h

Source: `roblox-sandbox/Win/DSVideoCaptureEngine.h` (73 lines)

## Purpose

Declares `RBX::DSVideoCaptureEngine`, the DirectShow-based `IVideoCapture` implementation behind the Windows client's "Record Video" feature: it builds a capture graph with custom video/audio source filters and a WMASF writer, receives rendered frames via `pushNextFrame`, and exposes its own clock (`DS::IAudioTime`) so the audio stream can timestamp against the same timeline.

## API

```cpp
namespace RBX { namespace DS {
    class IAudioTime { virtual LONG GetTime() = 0; virtual LONG GetAbsoluteTime() = 0; };
    class CVideoStreamFilter;   // forward decls — real definitions live in the .cpp
    class CAudioStreamFilter;
}}

class RBX::DSVideoCaptureEngine : public IVideoCapture, public DS::IAudioTime
{
public:
    DSVideoCaptureEngine();
    virtual ~DSVideoCaptureEngine();
    virtual bool start(int cx, int cy, SoundState* s);
    virtual bool stop();
    virtual bool isRunning();
    virtual void setVideoQuality(int vq);
    virtual void pushNextFrame(void* device, Verb* cancelAction);
    virtual std::string& getFileName();      // inline: returns fullFileName

    virtual LONG GetTime();                  // DS::IAudioTime
    virtual LONG GetAbsoluteTime();
private:
    const double defNx;        // 16.0 — 16:9 normalization ratios
    const double defNy;        // 9.0
    const LONG MaxRecordTime;  // 30*60*1000 ms = 30 min hard cap
    HRESULT BuildCaptureGraph(int cx, int cy, bool forceNoAudio);
    HRESULT BuildCaptureGraphNoThrow(int cx, int cy, bool forceNoAudio);   // SEH __except wrapper
    void DestroyCaptureGgaph();            // (sic) typo in the real symbol name
    int GenerateFileName(LPWSTR fileName);
    void GetSquareSizes(int cx, int cy, int& ncx, int& ncy);
    DWORD startTime;
    IGraphBuilder* graph;  IMediaControl* mediaControl;
    DS::CVideoStreamFilter* videoSource;  DS::CAudioStreamFilter* audioSource;
    SoundState* soundState;
    int framesPushed;  LONG lastPushedVideoFrameTime;
    std::string fullFileName;
    unsigned char* frameData;  unsigned frameDataSize;
};
```

## Usage

Included by WindowsClient/GameVerbs.cpp (three redundant `#include` lines), which constructs the engine inside a `VideoControl` for the record-video verb pair. ATL COM headers are skipped under RBX_PLATFORM_DURANGO.

## Gotchas

- The private helper is really named `DestroyCaptureGgaph` ("Ggaph") — search for the typo when navigating.
- `setVideoQuality` is declared and wired through VideoControl but the implementation is an empty body (see .cpp).
