# Android/SystemUtil.cpp

## Purpose
Android implementation of RBX::SystemUtil: sysconf-based CPU counts, compile-arch CPU make, and hardcoded values where Android offers no clean query (RAM 900 MB, video memory 64 MB). OS version/device name arrive from the Java layer via mutable globals.

## API
Full rbx/SystemUtil.h surface:
- `getCPUMake()` — "ARM" (`__arm__`) or "Intel" (`__i386__`); `#error` otherwise.
- `getCPUSpeed()` — always 0.
- `getCPULogicalCount()/getCPUPhysicalCount()` — both alias `getCPUCoreCount()`.
- `getCPUCoreCount()` — `sysconf(_SC_NPROCESSORS_CONF)`.
- `isCPU64Bit()` — true only under `__arm64__`.
- `getMBSysRAM()` — constant 900. `getMBSysAvailableRAM()` — 0 (comment: unused).
- `getVideoMemory()` — constant 67108864 (64 MB, "same as iOS").
- `osPlatform()` — "Android"; `osPlatformId()` — `__ANDROID_API__` macro value.
- `osVer()/deviceName()` — globals `mOSVersion`/`mDeviceName`, set externally in JNIGLActivity.cpp.
- `getGPUMake()` — "Android". `getMaxRes()` — empty string.

## Usage
Compiled only for Android builds; pairs with rbx/SystemUtil.h. Includes android/api-level.h, unistd.h, util/StreamHelpers.h (the latter appears vestigial).

## Gotchas
- `mOSVersion`/`mDeviceName` are unsynchronized global strings written by JNI init — racy if read before/concurrently with JNIGLActivity setup.
- RAM/video constants are fiction for analytics on real devices.
