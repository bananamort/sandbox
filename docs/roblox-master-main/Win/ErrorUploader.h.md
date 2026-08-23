# ErrorUploader.h

Source: `roblox-sandbox/Win/ErrorUploader.h` (55 lines)

## Purpose

Declares `ErrorUploader`, the base class for background error-file uploaders: a shared-state blob (`data`: filename queue + recursive mutex + target URL + dmp count + interprocess mutex HANDLE) and a scoped `RBX::worker_thread`. Provides queue management (`Cancel`, `IsUploading`) inline; the actual dequeue/upload pump lives in subclasses (DumpErrorUploader/ScriptErrorUploader pattern). Cross-platform includes are present but the class is Win32-flavored (HANDLE).

## API

```cpp
class ErrorUploader {
protected:
    struct data {
        std::queue<std::string> files;
        boost::recursive_mutex sync;    // TODO: Would non-recursive be safe here?  (in-source)
        std::string url;
        int dmpFileCount;
        HANDLE hInterprocessMutex;
        data();
    };
    shared_ptr<data> _data;
    boost::scoped_ptr<RBX::worker_thread> thread;

    static std::string MoveRelative(LPCTSTR fileName, std::string path);
public:
    ErrorUploader();                    // new data()
    void Cancel();                      // drain queue under lock
    bool IsUploading();                 // !files.empty()
};
```

## Usage

Base of the uploader family declared beside it in Win/: DumpErrorUploader and ScriptErrorUploader derive from it and drive `thread`/`_data`. Verified by tree-wide grep: NOTHING calls `Cancel()` or `IsUploading()` — both are dead public API; enqueueing happens in the subclasses' `Upload()` methods, not here. The non-Win32 branch includes `_FindFirst.h`, which does exist in-tree at `Network/raknet/Source/_FindFirst.h`, so a POSIX port was plausible but no non-Windows instantiation exists today.

## Gotchas

- `IsUploading()` is only queue-emptiness — says nothing about whether the worker thread actually succeeded or is mid-transfer.
- `Cancel()` pops filenames without deleting the underlying files; already-moved-to-archive files just stop being uploaded.
- Header-only `Cancel/IsUploading` lock `_data->sync` directly; recursive mutex chosen deliberately (in-source TODO questions it).
