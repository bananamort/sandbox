# util/MachOBaseAddr.h

## Purpose
Mach-O (macOS/iOS) helpers returning the dynamic loader slide for the main executable and the size of its __TEXT segment — used to translate between static link addresses and runtime addresses.

## Declared API
```cpp
uint32_t machODynamicBaseAddress(void);   // ASLR slide / base address of the image
uint32_t machOTextSize(void);             // size of the __TEXT segment
```
Global namespace, plain C linkage style; guarded by `App_MachOBaseAddr_h`.

## Gotchas
- **32-bit only** (`uint32_t` return): addresses truncate on 64-bit Mach-O binaries.
- No `extern "C"` wrapper and no namespace — C++ mangled names expected.
- Platform-specific: meaningful only on Apple platforms.

## UNKNOWN
- Call sites (crash reporting / symbolization likely; outside this slice).
