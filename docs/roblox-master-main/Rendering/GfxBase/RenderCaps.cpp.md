# RenderCaps.cpp

Source: `roblox-sandbox/Rendering/GfxBase/RenderCaps.cpp` (15 lines)

## Purpose

Sole constructor of `RBX::RenderCaps` — the graphics-capability record (GPU name, VRAM size, and feature flags) filled in by each backend at startup.

## API

```cpp
RBX::RenderCaps::RenderCaps(std::string gfxCardName, size_t vidMemSize);
```
Initializes:
- `gfxCardName(gfxCardName)`
- `vidMemSize(vidMemSize)`
- `texturePowerOf2Only(false)` — default assumes NPOT textures OK
- `supportsGBuffer(false)` — default off
- `skinningBoneCount(0)`

Includes: `GfxBase/RenderCaps.h`, `FastLog.h` (no logging actually present in this TU).

## Usage

Called by backend init code (GfxCore D3D/GL wrappers) once adapter info is known; the rest of the engine then reads flags off the instance.

## Gotchas

- Defaults matter: `texturePowerOf2Only=false` and `supportsGBuffer=false` are optimistic/pessimistic respectively — backends must explicitly flip them after probing.
- `skinningBoneCount=0` means "unknown/unset"; consumers must handle zero.
