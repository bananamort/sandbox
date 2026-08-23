# SystemUtil.h

## Purpose
Declares the RBX::SystemUtil namespace — one stop for hardware/OS inventory strings used in analytics, log headers, and device fingerprinting: CPU make/speed/topology, RAM totals and availability, video memory, OS platform/version/device name, GPU make, max display resolution.

## API
```cpp
namespace RBX {
namespace SystemUtil {
    // CPU
    std::string getCPUMake();
    uint64_t    getCPUSpeed();
    uint64_t    getCPULogicalCount();
    uint64_t    getCPUCoreCount();
    uint64_t    getCPUPhysicalCount();
    bool        isCPU64Bit();
    // Memory
    uint64_t    getMBSysRAM();
    uint64_t    getMBSysAvailableRAM();
    uint64_t    getVideoMemory();
    // OS
    std::string osPlatform();
    int         osPlatformId();
    std::string osVer();
    std::string deviceName();
    // GPU
    std::string getGPUMake();
    // Display
    std::string getMaxRes();
}
}
```

## Usage
Implemented once per platform under rbx/{Win,Darwin,Android,Durango}/SystemUtil.cpp. Also consumed by cpucount.cpp (getCPUCoreCount backs RbxTotalUsableCoreCount on non-Windows).

## Gotchas
- Defines `uint64_t` as `unsigned __int64` on _WIN32 unconditionally — if anything else defines uint64_t first (C99 headers), this typedef collides.
- Return units are mixed: RAM getters are MB-scaled ("MB" prefix) while CPU counts are raw counts and speed is UNKNOWN unit (Hz vs MHz — see platform impls).
