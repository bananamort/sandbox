# cpucount.cpp

## Purpose
Implementation of `RbxTotalUsableCoreCount` — platform-dispatched CPU-count probe. Windows uses the C++11 standard library; everything else delegates to `RBX::SystemUtil::getCPUCoreCount()`.

## API
```cpp
unsigned int RbxTotalUsableCoreCount(unsigned int defaultValue)
```
- `_WIN32`: returns `std::thread::hardware_concurrency()`, or `defaultValue` if that is 0.
- Non-Windows: returns `RBX::SystemUtil::getCPUCoreCount()` (no default fallback on this branch).

## Usage
Declared in include/CPUCount.h. Consumed wherever worker-thread counts are derived (task scheduler sizing).

## Gotchas
- The `defaultValue` parameter is silently ignored on non-Windows builds.
- File has no copyright banner; it is one of the smallest TUs in Base.
