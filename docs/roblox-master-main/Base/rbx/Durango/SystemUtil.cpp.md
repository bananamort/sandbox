# Durango/SystemUtil.cpp

## Purpose
Xbox One ("Durango") stub implementation of RBX::SystemUtil. Every query returns a constant: the platform name "Durango", 64-bit CPU, osPlatformId -1, and a saturated video-memory value.

## API
Implements a subset of rbx/SystemUtil.h:
```cpp
osVer() -> "Durango"; isCPU64Bit() -> true; osPlatformId() -> -1;
osPlatform() -> "Durango"; getGPUMake() -> "Durango"; deviceName() -> "Durango";
getVideoMemory() -> (1U<<31)-1   // INT32_MAX, "a lot" sentinel
```

## Usage
Selected by the build system only for Durango targets. Functions not defined here (getCPUMake, RAM getters, getMaxRes, etc.) have no stubs in-file — they resolve via UNKNOWN linkage; either never called on this platform or link errors would surface.

## Gotchas
- getVideoMemory returns 2 GiB − 1 as a fake value — analytics reading it will see a constant.
- Missing implementations are silent ODR holes rather than compile errors (declarations fail at link time only if referenced).
