# CPUCount.h

## Purpose
One-line header declaring `RbxTotalUsableCoreCount`, the engine's portable "how many cores can we use" query used when sizing thread pools and task schedulers.

## API
```cpp
unsigned int RbxTotalUsableCoreCount(unsigned int defaultValue);
```

## Usage
Implemented in Base/cpucount.cpp. Callers pass a fallback count for platforms where the OS query fails or returns 0.

## Gotchas
- Returns usable logical-core count; the "default" path only triggers on Windows when `std::thread::hardware_concurrency()` returns 0.
