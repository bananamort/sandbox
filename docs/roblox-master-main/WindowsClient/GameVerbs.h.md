# WindowsClient/GameVerbs.h

## Purpose

Declares the four client shell verbs wired into the verb system (v8tree/Verb.h) during `Application::initVerbs()`: LeaveGameVerb (exit), ScreenshotVerb (screenshot + optional upload), RecordToggleVerb (DirectShow video capture + upload), ToggleFullscreenVerb. These are the UI/accelerator entry points whose IDs surface in WindowsClient.rc and UserInput's whitelist.

## API

```cpp
class LeaveGameVerb : public Verb {           // "Request to leave the game. Results in process shutdown."
    View& v;
public:
    LeaveGameVerb(View& v, VerbContainer* container);
    virtual void doIt(IDataState* dataState);
};

class ScreenshotVerb : public RBX::Verb {
    Game* game; ViewBase* view; const Document& doc;
    void screenshotFinished(const std::string &filename);
    void askUploadScreenshot(std::string filename);
    void uploadScreenshot(const std::string &filename);
public:
    ScreenshotVerb(const Document& doc, ViewBase* view, Game* game);
    virtual void doIt(IDataState* dataState);
    virtual bool isEnabled() const { return true; }
};

class RecordToggleVerb : public Verb {
    const Document& doc; View* view; Game* game;
    boost::scoped_ptr<VideoControl> videoControl;
    std::string fileName;
    bool videoUploadingEnabled; bool stop;
    boost::scoped_ptr<boost::thread> helper;
    boost::function<void()> job;
    CEvent jobWait, jobDone, threadDone;      // rbx::CEvent
    void action();
    bool isUploadingVideo() const; void EnableVideUpload(bool);
    void uploadVideo(); void abortCapture();
public:
    RecordToggleVerb(const Document& doc, View* view, Game* game);
    ~RecordToggleVerb();
    virtual bool isEnabled() const; virtual bool isChecked() const; virtual bool isSelected() const;
    void startAction(); void stopAction();
    virtual void doIt(IDataState* dataState);
    VideoControl* GetVideoControl();
};

class ToggleFullscreenVerb : public RBX::Verb {
    VideoControl* videoControl;   // disabled while recording
    View& view;
public:
    ToggleFullscreenVerb(View& view, VerbContainer* container, VideoControl* videoControl);
    virtual bool isChecked() const; virtual bool isEnabled() const;
    virtual void doIt(RBX::IDataState* dataState);
};
```

## Usage

Constructed in Application::initVerbs with the current Document/View/Game each session (see Application.cpp.md); torn down by shutdownVerbs. See GameVerbs.cpp.md.

## Gotchas

- Verb names are exact strings: "Exit", "Screenshot", "RecordToggle", "ToggleFullScreen" — the last one has inconsistent casing vs the class name.
