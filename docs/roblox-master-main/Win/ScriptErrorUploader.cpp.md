# ScriptErrorUploader.cpp

Source: `roblox-sandbox/Win/ScriptErrorUploader.cpp` (126 lines)

## Purpose

Implements the `.cse` (core script error) upload pump: `Upload(url)` claims named mutex "RobloxCrashScriptErrorUploaderMutex" (single-instance guard), gathers via `MainLogManager::gatherScriptCrashLogs()`, enqueues, and `run()` POSTs each file to `url?filename=<RAW name>` — posting "Too many cse files" beyond 3 per run, "Empty!!!" for zero-byte files — then archives each with `MoveRelative(file, "archive\\")`.

## API

```cpp
void ScriptErrorUploader::Upload(std::string url);
    // CreateMutex(NULL, TRUE, TEXT("RobloxCrashScriptErrorUploaderMutex"))
    // ERROR_ALREADY_EXISTS → MESSAGE_INFO + return
    // gatherScriptCrashLogs() → _data->files; wake() or inline while(run(_data)!=done)
static RBX::worker_thread::work_result ScriptErrorUploader::run(shared_ptr<data> _cseData);
    // front → isCseFile check (.cse suffix) → dmpFileCount++ → POST or placeholder body
    // MoveRelative(file,"archive\\") under try/catch; pop; more | done(releases mutex handle)
```

## Usage

Dead code at baseline: verified by tree-wide grep, no TU constructs a ScriptErrorUploader or calls its Upload — this pump never runs in any current target (the parallel DumpErrorUploader IS wired into WindowsClient and RCCService).

## Gotchas

- `url += file` — no URL-encoding of the filename (DumpErrorUploader encodes); any space in a cse filename truncates the query string server-side.
- Same destructive-archive behavior: failed uploads are popped and archived anyway (catch swallows), so a transient network error permanently skips a cse log.
- File-size probe uses `size_t begin = tellg()` on an fstream opened binary — fine on Win32, but if the file vanished between gather and run, both `tellg()` calls return -1 (SIZE_MAX as size_t), so `end > begin` is false and the code posts the `"Empty!!!"` placeholder under that filename instead of erroring out — the missing file is silently "uploaded" and archived off the queue.
- Beyond-3 placeholder posts reuse the per-file URL, mirroring DumpErrorUploader's convention.
