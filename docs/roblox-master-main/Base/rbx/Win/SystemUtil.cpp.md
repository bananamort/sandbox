# Win/SystemUtil.cpp

## Purpose
Windows implementation of RBX::SystemUtil: GetVersionEx for OS version, IsWow64Process for 64-bit detection, EnumDisplayDevices for GPU name, and a DirectDraw2 (`IDirectDraw2::GetAvailableVidMem`) probe for total video memory.

## API
Partial rbx/SystemUtil.h surface:
- `osVer()` — `RBX::format("%d.%d.%d.%d", osvi.dwOSVersionInfoSize, major, minor, build)`. NOTE first field is dwOSVersionInfoSize (sizeof struct, e.g. "148"), not service-pack — looks like an old bug preserved in output.
- `isCPU64Bit()` — literal true under `_WIN64`; otherwise `IsWow64Process(GetCurrentProcess(), &result) && result`.
- `osPlatformId()` — constant `VER_PLATFORM_WIN32_NT`. `osPlatform()` — "Win32". `deviceName()` — "PC".
- `getGPUMake()` — DeviceString of first display device.
- `getVideoMemory()` — cached static from `GetDirecXVideoMemorySize()`: CoInitialize → CLSID_DirectDraw → Initialize(0) → GetAvailableVidMem with DDSCAPS_VIDEOMEMORY|DDSCAPS_LOCALVIDMEM, retrying with |DDSCAPS_3DDEVICE; 0 on double failure. FASTLOG'd under FLog::DXVideoMemory.

## Usage
Windows desktop client analytics/log headers. Includes ProcessPerfCounter.h and RegistryUtil.h and FastLog.h though only the DDraw path uses logging; setupapi.h/d3d9.h includes are vestigial (no d3d calls in-file).

## Gotchas
- Not implemented here (link-time holes on Win if referenced): getCPUMake/getCPUSpeed/getCPU*Count/RAM getters — UNKNOWN where Windows builds get them (likely another TU or they're simply unreferenced).
- GetVersionEx is deprecated/lying on Windows 8.1+ without manifest version lie fix-ups — osVer() reports the compatibility-shimmed version.
- `CoInitialize(NULL)` result not released on early-failure paths symmetrically (CoUninitialize always called even when CoInitialize failed).
