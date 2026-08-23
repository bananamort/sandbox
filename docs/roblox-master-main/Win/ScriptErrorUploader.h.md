# ScriptErrorUploader.h

Source: `roblox-sandbox/Win/ScriptErrorUploader.h` (18 lines)

## Purpose

Declares `ScriptErrorUploader`, the ErrorUploader subclass for core-script error logs (`.cse` files): same queue/worker pattern as DumpErrorUploader but a separate interprocess mutex and no crash-event machinery. Constructor is inline and starts the worker thread only when `backgroundUpload` is true.

## API

```cpp
class ScriptErrorUploader : public ErrorUploader {
public:
    ScriptErrorUploader(bool backgroundUpload) {
        if (backgroundUpload)
            thread.reset(new RBX::worker_thread(
                boost::bind(&ScriptErrorUploader::run, _data), "ScriptErrorUploader"));
    }
    /*override*/ void Upload(std::string url);
private:
    static RBX::worker_thread::work_result run(shared_ptr<data> _cseData);
};
```

## Usage

Verified by tree-wide grep: NOTHING instantiates ScriptErrorUploader — not WindowsClient/Application.cpp, not RCCService. It is fully wired logic (Upload/run/mutex) kept as dead code; the live `.cse` gathering path is `MainLogManager::gatherScriptCrashLogs()` (Win/LogManager.cpp), which renames pending core-script error logs and dedups them against the last hour of archives.

## Gotchas

- Same early-return mutex leak shape as DumpErrorUploader: on ERROR_ALREADY_EXISTS it returns while holding an opened handle that is never closed or stored.
- No `.Full.` skip, no Influx reporting, and filename appended to the URL WITHOUT urlEncode (unlike DumpErrorUploader) — spaces/session-id gaps in cse filenames produce malformed query strings.
