# util/FileSystem.h

## Purpose
Thin helper over boost::filesystem for locating standard per-user directories (AppData, Pictures, Videos, exe dir), the cache directory, temp files, and logs; plus cache clearing. Uses dynamic loggroup `FileSystem`.

## Declared API
```cpp
enum FileSystemDir {
    DirAppData = 0,
    DirPicture,
    DirVideo,
    DirExe
};

namespace RBX::FileSystem {
    boost::filesystem::path getUserDirectory(bool create, FileSystemDir dir, const char* subDirectory = 0);
    boost::filesystem::path getCacheDirectory(bool create, const char* subDirectory);
    boost::filesystem::path getTempFilePath();
    boost::filesystem::path getLogsDirectory();
    void clearCacheDirectory(const char* subDirectory);
}
```

## Gotchas
- `create=false` returns the path without ensuring existence — subsequent file ops may fail if missing.
- `getCacheDirectory`/`clearCacheDirectory` take a `subDirectory` with no default: callers must always scope their cache use.
- Includes `boost/thread/mutex.hpp` though no mutex appears in declarations — implementation-side locking implied.
- Platform root paths (e.g., %APPDATA%) resolved in the .cpp.

## UNKNOWN
- Exact base path per FileSystemDir per platform (.cpp outside App/include).
