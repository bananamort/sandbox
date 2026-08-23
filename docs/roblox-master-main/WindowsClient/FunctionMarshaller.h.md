# WindowsClient/FunctionMarshaller.h

## Purpose

Declares `RBX::FunctionMarshaller` — "a very handy class for marshaling a function across Windows threads (sync and async)". An ATL message-window (CWindowImpl) living on one thread; other threads hand it boost::functions that run on its owning thread when the window's message pump dispatches the custom WM_USER messages. This is the client's thread-affinity workhorse: View::ShowWindow focus fix, RenderJob render marshalling, Teleporter::doTeleport, Document UI hops all go through it. Header errors out on non-Windows (`#error` under `#ifndef _WIN32`).

## API

```cpp
class FunctionMarshaller : public ATL::CWindowImpl<FunctionMarshaller> {
    const static int WM_EVENT = WM_USER + 101;       // See Q196026
    const static int WM_ASYNCEVENT = WM_USER + 102;  // See Q196026
    LRESULT OnEvent(UINT, WPARAM, LPARAM, BOOL&);
    LRESULT OnAsyncEvent(UINT, WPARAM, LPARAM, BOOL&);
    struct StaticData { std::map<DWORD, FunctionMarshaller*> windows;
                        boost::recursive_mutex windowsCriticalSection; ~StaticData(); };
    SAFE_STATIC(StaticData, staticData)
    rbx::safe_queue<boost::function<void()>*> asyncCalls;
    rbx::atomic<LONG> postedAsyncMessage;
    int refCount; DWORD threadID;
    FunctionMarshaller(DWORD threadID); ~FunctionMarshaller();
public:
    DECLARE_WND_CLASS("Roblox.FunctionMarshaller")   // see Q196026
    static FunctionMarshaller* GetWindow();
    static void ReleaseWindow(FunctionMarshaller* window);
    struct Closure { boost::function<void()>* f; std::string errorMessage; };
    void Execute(boost::function<void()> job);   // Executes the given function.
    void Submit(boost::function<void()> job);    // Submits ... to a separate thread.
    void ProcessMessages();                      // Call this only from the Window's thread.
    BEGIN_MSG_MAP(MarshaledListener)
        MESSAGE_HANDLER(WM_EVENT, OnEvent)
        MESSAGE_HANDLER(WM_ASYNCEVENT, OnAsyncEvent)
    END_MSG_MAP()
    virtual void OnFinalMessage(HWND hWnd);
};
```

## Usage

Per-thread singleton via `GetWindow()`/`ReleaseWindow()` (ref-counted map keyed by thread id). See FunctionMarshaller.cpp.md.

## Gotchas

- Header TODOs (verbatim): "refactor this class so it doesn't use ATL"; "Would non-recursive be safe here?"; "Wrap with a reference counter and then remove ~StaticData() cleanup code and remove ReleaseWindow()".
- The window class name string is "Roblox.FunctionMarshaller".
