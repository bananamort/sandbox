# Darwin/SystemUtil.cpp

## Purpose
macOS/iOS implementation of RBX::SystemUtil. Everything is sysctl/Mach/IOKit: CPU brand/frequency/topology via `sysctlbyname`, RAM via `hw.memsize` + Mach `host_statistics`, VRAM/GPU model via IOKit registry of the first display, OS version via private CoreFoundation API `CFCopySystemVersionString` (mac) or extern helpers from the iOS layer.

## API
Full rbx/SystemUtil.h surface:
- Helpers (anonymous namespace): `sysctlbynameuint64(name[, &out])` — reads sysctl ints with 8/16/32/64-bit width normalization, returns 0 on failure; `sysctlbynamestring(name)` — fixed 512-byte buffer.
- `getCPUMake()` — "machdep.cpu.brand_string". `getCPUSpeed()` — hw.cpufrequency / 1048576 (→ MHz).
- `getCPULogicalCount()` — hw.logicalcpu → hw.ncpu → 1. `getCPUCoreCount()` — hw.physicalcpu → logical fallback.
- `getCPUPhysicalCount()` — hw.packages → ncpu/logical_per_package → physicalcpu → ncpu → 1.
- `isCPU64Bit()` — hw.cpu64bit_capable || hw.optional.x86_64.
- `getMBSysRAM()` — hw.memsize / 1 MiB. `getMBSysAvailableRAM()` — (free+inactive pages) × pagesize / 1 MiB.
- `getVideoMemory()` — cached static; IOKit "IOFBMemorySize" of display 0; 64 MB floor default ("lowest for any intel Mac").
- `osPlatform()` — "iOS" on arm, "OSX" on intel, else #error. `osPlatformId()` — 0.
- `deviceName()/osVer()` — iOS: getFriendlyDeviceName()/getDeviceOSVersion(); mac: "Mac" and `"Mac OS X " + CFCopySystemVersionString` minus first 8 chars.
- `getGPUMake()` — IOKit "model" data + GL driver version hunted through GMUX/AppleGraphicsControl registry Config1→GLDriver1→kext bundle CFBundleGetInfoString; literal placeholder "<driver version could not be found>" on failure paths.
- `getMaxRes()` — "WxH" of CGDisplayBounds(main display); empty on iOS.

## Usage
Darwin builds only. Uses private CF/IOKit APIs (CFCopySystemVersionString declared by hand "from CFPriv.h"; CGDisplayIOServicePort later deprecated/removed in modern SDKs).

## Gotchas
- `sysctlbynamestring`: if the sysctl fails or returns shorter data, `vstr` is uninitialized stack → garbage string result (no zero-init).
- `CGDisplayIOServicePort(displays[0])` without checking dspCount — no displays ⇒ reads displays[0] uninitialized.
- getGPUMake's deep GMUX path only exists on dual-GPU MacBook Pros; single-GPU Macs return model-only string with the literal driver-placeholder suffix.
