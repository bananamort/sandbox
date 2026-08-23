# Rendering/GfxCore/D3D9/DeviceContextD3D9.cpp

## Purpose

Implementation of the D3D9 immediate-mode context: translates cached backend-neutral state (rasterizer/blend/depth/sampler/texture/program/framebuffer) into `IDirect3DDevice9` render-state and stage-state calls, plus the fixed-function emulation subclass `DeviceContextFFPD3D9` that maps constants to legacy transform/texture-factor state.

## API

Implements every method declared in DeviceD3D9.h for `DeviceContextD3D9` and `DeviceContextFFPD3D9`.

- File-local lookup tables: `gCullModeD3D9`, `gBlendFactorsD3D9`, `gDepthFuncD3D9`, `gSamplerFilterD3D9` (min/mag/mip per filter), `gSamplerAddressD3D9`; helpers `findKey<Map>`, `transposeMatrix(dest, source, lastColumn)` (row→column-major with injected 4th column), `colorComponentToInt/colorToD3D`, `ascii2unicode`.
- Constructor: resolves `device9` from the device, zeroes caches; when `PIX_ENABLED`, loads d3d9.dll and gets `D3DPERF_BeginEvent/EndEvent/SetMarker/GetStatus` via GetProcAddress; if `GetStatus` is unavailable or reports inactive, forces `FFlag::GraphicsDebugMarkersEnable = false`.
- State methods:
  - `clearStates()` resets framebuffer-surface count, program/layout/geometry cache, all 16 texture units (sampler set to invalid `Filter_Count` to force miss), and sets rasterizer/blend/depth caches to out-of-range enum values.
  - `updateGlobalConstants` writes the whole global block to both vertex (`SetVertexShaderConstantF(0,...)`) and pixel registers at register 0, size `globalDataSize/16`.
  - `bindFramebuffer` unbinds render targets 1..N-1 from the previous bind count before setting new color targets and depth stencil; records `cachedFramebufferSurfaces`.
  - `clearFramebuffer` maps Buffer_Color/Depth/Stencil mask to D3DCLEAR flags.
  - `copyFramebuffer` grabs a system-memory copy of the buffer surface (`grabCopy`) then row-by-row memcpys into the destination texture's level-0 lock (pitch-aware).
  - `resolveFramebuffer` is a single `StretchRect` MSAA→single-sample on color only.
  - `discardFramebuffer` is an empty no-op.
  - `bindProgram` caches and calls `ShaderProgramD3D9::bind()`; `setWorldTransforms4x3`/`setConstant` delegate to the cached program.
  - `bindTexture` substitutes `defaultAnisotropy` when anisotropic filter requested with anisotropy==0, flushes pending texture changes (`TextureD3D9::flushChanges`), then applies texture + sampler state through per-stage cache.
  - `setRasterizerState` sets cull mode and depth bias — integer bias scaled by 1/2^24 into D3DRS_DEPTHBIAS float bits; same integer reused /32 for slope-scale bias (source comment admits magic numbers).
  - `setBlendState` enables/disables alpha blend, src/dst factors, optional separate alpha blend, and color write mask.
  - `setDepthState` disables Z entirely for (Always, write=false); else sets compare func + write enable. Stencil modes: `Stencil_None` off; `Stencil_IsNotZero` single-sided NOTEQUAL vs ref 0, all ops KEEP; `Stencil_UpdateZFail` two-sided ALWAYS with DECR front zfail / INCR back zfail.
  - `drawImpl` forwards to `GeometryD3D9::draw` passing `&cachedVertexLayout`/`&cachedGeometry`.
- Debug markers: push/pop/set map to D3DPERF BeginEvent/EndEvent/SetMarker with 512-wchar conversion.
- FFP overrides:
  - `updateGlobalConstants`: view = identity; projection = transposed `_G.ViewProjection` from the global constant block (looked up by name in the device's constant map).
  - `bindProgram`: disables lighting, sets stage-0 alpha op MODULATE with ARG2=CURRENT.
  - `setWorldTransforms4x3`: world matrix = transpose of first 4x3 (identity if none).
  - `setConstant`: handle 0 means tint → `D3DRS_TEXTUREFACTOR` + ARG2=TFACTOR.

## Usage

Owned by DeviceD3D9 as its immediate context; the renderer calls the abstract DeviceContext interface. The FFP variant is selected by DeviceD3D9 when shader support is absent (`createShaderProgramFFP` pairs with it).

## Gotchas

- `bindProgram`/`setWorldTransforms4x3`/`setConstant` dereference `cachedProgram` without null check — calling transforms/constants before any bind crashes; correctness depends on renderer always binding first.
- `updateGlobalConstants` writes `globalDataSize/16` float4 registers to BOTH shader stages starting at register 0 — shader register layout must reserve that block.
- `bindFramebuffer` loop starts at index 1 (`i = 1`), so stale MRT target 0 is implicitly replaced but targets ≥ previous count rely on the explicit NULL loop; mismatched counts between binds are handled but subtle.
- `copyFramebuffer` requires matching format/size (RBXASSERT only) — release builds silently corrupt if they differ; also assumes destination is lockable (not a raw render target).
- Depth bias formula reuses the integer depth bias for slope-scale bias (/32) — intentional approximation per in-code comment.
- Debug markers are gated at runtime: constructor flips the fast flag off when PIX isn't active, so marker calls become cheap pointer-null checks.
- FFP `setConstant` only honors handle 0; other handles are ignored silently.
