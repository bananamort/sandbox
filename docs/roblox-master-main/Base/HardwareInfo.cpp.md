# HardwareInfo.cpp

## Purpose
Implements `RBX::CPUCount` by querying three metrics from the GeekInfo system-metric library (`kSystemMetricCPULogicalCount`, `kSystemMetricCPUCoreCount`, `kSystemMetricCPUPhysicalCount`) and converting the returned strings to integers with `boost::lexical_cast`.

## API
```cpp
unsigned char RBX::CPUCount(unsigned int *TotAvailLogical,
                            unsigned int *TotAvailCore,
                            unsigned int *PhysicalNum)
```
Sets `StatusFlag = 1` if any of the three lexical casts throws `boost::bad_lexical_cast`; out-params may be left untouched in that case. Returns 0 only when all three parsed.

## Usage
Declared in include/HardwareInfo.h. The tail of the file carries a commented-out (`#if 0`) macOS unit test by "eric l." showing the original GeekInfo 2.1.4 link line (Carbon/IOKit/Cocoa frameworks) — historical evidence that GeekInfo was a vendored static lib under GeekInfo/src/geekinfo-2.1.4/.

## Gotchas
- Includes `"geekinfo.h"`, which does NOT exist anywhere in roblox-sandbox — the GeekInfo dependency was pruned or was an external download; this TU cannot compile as-is without restoring it.
- On cast failure earlier metrics may already have been written while later ones are stale/garbage — check the return before trusting any out-param.
