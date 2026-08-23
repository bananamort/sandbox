# ErrorUploader.cpp

Source: `roblox-sandbox/Win/ErrorUploader.cpp` (43 lines)

## Purpose

Implements exactly one helper of the ErrorUploader family: `ErrorUploader::MoveRelative(fileName, path)` — relocates a file into a subdirectory next to its current location (creating that directory if missing) and returns the new full path. If the move fails, deletes the source "just in case!" (in-source comment). All other ErrorUploader behavior is inline in the header or implemented by subclasses.

## API

```cpp
static std::string ErrorUploader::MoveRelative(LPCTSTR fileName, std::string path);
// dir = fileName minus spec; Append(path); mkdir if !FileExists
// file = fileName's name only; dir.Append(file)
// MoveFile(fileName, dir); on failure → DeleteFile(fileName)
```

## Usage

Called by the concrete uploaders (DumpErrorUploader.cpp, ScriptErrorUploader.cpp) to archive processed error/log files under the logs directory before/instead of upload, so retried uploads find files in the archive layout MainLogManager::gatherCrashLogs expects.

## Gotchas

- Failure semantics are destructive: an inaccessible target (permissions, locked file, AV scan) DELETES the source rather than leaving it for retry.
- `_mkdir(dir)` takes the ATL::CPath directly — narrow build assumption; wide-char paths rely on the project's TCHAR mapping.
