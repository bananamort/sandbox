# VideoControl.h

Source: `roblox-sandbox/Win/VideoControl.h` (81 lines)

## Purpose

Declares the in-game video-recording controller: `IVideoCapture` (abstract capture backend — start/stop/pushNextFrame), `SoundState` (boost::function bundle letting a capture backend tap FMOD audio via SoundService's createDSP/getSampleRate/enabled), and `VideoControl`, which binds a capture implementation to a ViewBase frame-data callback and FrameRateManager so recording pauses auto FPS adjustment and feeds each rendered D3D device frame to the encoder.

## API

```cpp
struct RBX::SoundState {
    boost::function<FMOD::DSP*(FMOD_DSP_DESCRIPTION&)> createDSPFunction;
    boost::function<int()> getSampleRateFunction;
    boost::function<bool()> enabledFunction;
};

class RBX::IVideoCapture {
    virtual bool start(int cx, int cy, SoundState* s) = 0;
    virtual bool stop() = 0;
    virtual bool isRunning() = 0;
    virtual void setVideoQuality(int vq) = 0;
    virtual void pushNextFrame(void* device, Verb* cancelAction) = 0;
    virtual std::string& getFileName() = 0;
};

class RBX::VideoControl {
public:
    VideoControl(IVideoCapture* capture, RBX::ViewBase* rbxView,
                 FrameRateManager* frameRateManager, Verb* verb);
    void startRecording(RBX::Soundscape::SoundService* soundservice);
    void stopRecording();
    void pause();  void unPause();            // both no-op bodies
    bool isReadyToUpload();                   // recorded && !capture->isRunning()
    bool isVideoPaused();                     // always false
    bool isVideoRecording();                  // capture->isRunning()
    bool isVideoRecordingStopped();           // !isRunning()
    void setVideoQuality(int vq);
    std::string& getFileName();               // forwards to capture
private:
    void onFrameData(void* device);           // frame callback → pushNextFrame(device, verb)
};
```

Forward decls: IDirect3DDevice9/IDirect3DSwapChain9; includes util/SoundService.h.

## Usage

WindowsClient wires VideoControl with the DirectShow backend DSVideoCaptureEngine (this directory) for the "Record Video" feature; GameVerbs/UI drive startRecording/stopRecording through a Verb. The capture receives raw D3D9 device pointers via onFrameData.

## Gotchas

- `pause()/unPause()` are EMPTY and `isVideoPaused()` hardcoded false — pause UI state lies.
- Quality comes from `GameSettings::singleton()` at construction AND at every startRecording, overriding any earlier setVideoQuality call.
