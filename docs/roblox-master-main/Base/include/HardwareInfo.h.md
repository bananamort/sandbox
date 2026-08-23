# HardwareInfo.h

## Purpose
Declares `RBX::CPUCount`, a detailed CPU-topology query (logical processors, physical cores, physical packages) backed by the GeekInfo library.

## API
```cpp
namespace RBX {
unsigned char CPUCount(
    unsigned int *TotAvailLogical,
    unsigned int *TotAvailCore,
    unsigned int *PhysicalNum);
}
```
Returns a status flag: 0 == success, nonzero == at least one metric failed to parse.

## Usage
Implemented in Base/HardwareInfo.cpp. Out-params are written unconditionally on success; treat as garbage if the return value is nonzero.

## Gotchas
- Distinct from `RbxTotalUsableCoreCount` (include/CPUCount.h): this one reports full topology, not a usable-worker count.
- Header lacks `#pragma once`/include guards — safe only because its single declaration survives multiple inclusion.
