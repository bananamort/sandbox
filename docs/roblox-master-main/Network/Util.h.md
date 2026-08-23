# Network/Util.h

**Module**: Network (root) · **Type**: header (.h, 26 lines)

## Purpose

Declares the RakNet↔RBX `SystemAddress` conversion helpers implemented in `Util.cpp`, and defines the `NETWORK_PROFILER` / `NETWORK_DEBUG` macros on Windows non-optimized, debug, or test builds.

## API

```cpp
#ifdef _WIN32
  #if defined(_NOOPT) || defined(_DEBUG) || defined(RBX_TEST_BUILD)
    #define NETWORK_PROFILER
    #define NETWORK_DEBUG
  #endif
#endif

namespace RBX::Network {
    const RBX::SystemAddress RakNetToRbxAddress(const RakNet::SystemAddress& raknetAddress);
    std::string RakNetAddressToString(const RakNet::SystemAddress& raknetAddress,
                                      bool writePort = true, char portDelineator='|');
}
```

Also forward-declares `RBX::SpatialRegion::Id`.

## Usage

Included wherever peer addresses are converted or formatted; `NETWORK_PROFILER` gates `NetworkProfiler` instrumentation (see `NetworkProfiler.h/.cpp`).

## Gotchas

- The profiler/debug macros are **Windows-only**; on other platforms `NETWORK_PROFILER` is never defined regardless of build type.
- Includes `RakNetTypes.h` directly, so including this header pulls in RakNet types.
