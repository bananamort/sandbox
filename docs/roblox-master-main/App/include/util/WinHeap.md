# util/WinHeap.h

## Purpose
One-function Windows heap configuration hook: requests a low-fragmentation-friendly Windows heap setup for the process.

## Declared API
```cpp
namespace RBX::UTIL {
    void setWindowsNoFragHeap();
}
```

## Gotchas
- Meaningful only on Windows (name and semantics); behavior on other platforms is .cpp-side (likely no-op or #ifdef'd out).
- Must be called early in process startup to affect allocator behavior.
- No parameters or return value — success/failure not reported.

## UNKNOWN
- Implementation: presumably HeapSetInformation with LFH enablement (.cpp outside App/include).
