# RbxDbgInfo.cpp

## Purpose
Implements the RbxDbgInfo singleton (header documented previously): a memset-zeroed global struct holding a recent-place-ID history ring and fixed-size debug strings (GPU card name/driver/vendor, CPU name, server IP) that crash dumps and diagnostics embed.

## API
```cpp
RbxDbgInfo RbxDbgInfo::s_instance;          // global definition
RbxDbgInfo::RbxDbgInfo();                   // memset(this,0,sizeof)
static void AddPlace(long ID);              // push front of PlaceIDs[PLACE_HISTORY], shift rest
static void RemovePlace(long ID);           // find + shift-down + zero tail; PlaceCounter--
SetGfxCardName/SetGfxCardDriverVersion/SetGfxCardVendor/SetCPUName/SetServerIP(const char*);
```

## Usage
CProcessPerfCounter::init writes s_instance.NumCores; graphics init sets the GPU strings; network connect sets ServerIP. Crash handlers read s_instance directly.

## Gotchas
- memset over `this` including any vtable/base state — safe ONLY because RbxDbgInfo is POD by design; adding a virtual breaks this silently.
- AddPlace/RemovePlace are unsynchronized global mutations — races if places change on multiple threads.
- RemovePlace decrements PlaceCounter even when ID not found — counter drifts negative on unbalanced calls.
- strncpy with 4996-suppressed warnings, manual NUL termination everywhere.
