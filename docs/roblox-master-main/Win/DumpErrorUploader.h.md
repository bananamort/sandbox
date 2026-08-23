# DumpErrorUploader.h

Source: `roblox-sandbox/Win/DumpErrorUploader.h` (29 lines)

## Purpose

Declares `DumpErrorUploader`, the ErrorUploader subclass that uploads minidumps (.dmp) and their associated logs to the crash-collection endpoint, plus the static `.crashevent` fire-and-forget poster (`UploadCrashEventFile`) invoked from the SEH crash path. Holds deliberately pre-allocated statics ("Really trying to minimize heap allocations on crash event upload") so posting works even in a crashing process.

## API

```cpp
class DumpErrorUploader : public ErrorUploader {
public:
    DumpErrorUploader(bool backgroundUpload, const std::string& crashCounterNamePrefix);
        // backgroundUpload → spawn worker_thread("ErrorUploader") bound to run(_data)
    void Upload(const std::string& url);          // gather + enqueue + wake (or run synchronously)
    void InitCrashEvent(const std::string& url, const std::string& crashEventName);
    static void UploadCrashEventFile(struct _EXCEPTION_POINTERS *info = NULL);

    static boost::scoped_ptr<RBX::Http> crashEventRequest;   // pre-built POST target
    static std::istringstream crashEventData;                // seeded "Crash happened!"
    static std::string crashEventResponse;
    static std::string crashCounterNamePrefix;
private:
    static RBX::worker_thread::work_result run(shared_ptr<data> _data);
};
```

## Usage

WindowsClient/Application.cpp constructs it (background for the client, foreground elsewhere) and calls `InitCrashEvent` with `MainLogManager::getCrashEventName()`; `RobloxCrashReporter::ProcessException` (Win/LogManager.cpp) calls `UploadCrashEventFile(info)` inside the exception path. `Upload(url)` is invoked at startup/teardown to drain gathered dumps.

## Gotchas

- All four crash-event statics are process-global: two client instances in one process would share them.
- `crashEventData` starts as the literal "Crash happened!" — that IS the crash-event body unless changed.
