# Rendering/GfxCore/D3D9/DeviceD3D9.cpp

## Purpose

Implementation of the Direct3D 9 device: dynamic loading of d3d9.dll, HWVP→SWVP device creation fallback, capability probing, frame lifecycle (validate/beginFrame/endFrame with Present), full device-lost/reset resource management, GPU frame timing via timestamp queries, and all resource factory methods.

## API

Implements DeviceD3D9 and QueryD3D9 as declared in DeviceD3D9.h.

- Fast flags (defined here): `DebugGraphicsD3D9ForceSWVP`, `DebugGraphicsD3D9ForceFFP`.
- File-local helpers:
  - `getPresentParameters(windowHandle, w, h)` — windowed DISCARD swap chain, X8R8G8B8 backbuffer, auto D24S8 depth-stencil, immediate present interval.
  - `getFramebufferSize(HWND)` — client rect clamped to ≥1.
  - `createDevice(d3d, adapter, hwnd)` — HW vertex processing only if `DeclTypes & UBYTE4` and VS≥2.0 (and not force-SWVP flag); falls back to SWVP on the HAL device; returns NULL if both fail.
  - `isTextureFormatSupported` — CheckDeviceFormat against current display mode; `getMaxSamplesSupported` — scans modes 2..16 for A8R8G8B8 multisample; `createDirect3D` — LoadLibrary/GetProcAddress `Direct3DCreate9`.
  - `createDeviceCaps(...)` — fills DeviceCapsD3D9: shaders = PS/VS ≥2.0 unless ForceFFP; FFP = inverse; stencil needs D24S8/D24FS8 + two-sided caps; index32 from MaxVertexIndex; DXT1/3/5 support; half-float via A16B16G16R16F; volume/NPOT texture caps; maxDrawBuffers=NumSimultaneousRTs; maxTextureUnits hardcoded 16; `colorOrderBGR=true`; `needsHalfPixelOffset=true`; vendor from PCI VendorId (0x10DE NVidia, 0x1002 AMD, 0x8086/0x8087/0x163C Intel).
- `QueryD3D9` — ctor calls onDeviceRestored (CreateQuery), dtor calls onDeviceLost (Release).
- `DeviceD3D9::DeviceD3D9(void* windowHandle)` — probes DX11 feature level FIRST (comment: slow when DX9 device exists on some machines), creates IDirect3D9 + device (throws std::runtime_error on failure), builds caps (+dumpToFLog), picks `DeviceContextFFPD3D9` vs `DeviceContextD3D9`, creates main framebuffer over swap-chain surfaces, creates EVENT query + TIMESTAMP/TIMESTAMP/TIMESTAMPFREQ timing queries.
- Frame loop:
  - `validate()` — triggers lost/reset path on client-rect size change, then `validateDevice(w,h)`.
  - `beginFrame()` — returns NULL (skip frame) when no framebuffer/device lost/size changed/TestCooperativeLevel fails; issues first half of the timestamp pair, BeginScene, binds main framebuffer + clearStates.
  - `endFrame()` — EndScene; alternates issuing/reading timestamp queries to compute `gpuTime` in ms; busy-waits (with D3DGETDATA_FLUSH) on last frame's EVENT query, abandoning it after >5 s timeout; fires `frameCallback(device9)`; Presents.
  - `getStatistics()` — only gpuFrameTime populated.
- Feature level: `getFeatureLevelDX11` loads d3d11.dll and maps raw feature-level code to "D3D11_9.1"…"D3D11_11.1"; fallback `getFeatureLevel()` infers "D3D_9.0/9.1/9.2/9.3" from caps heuristics (separate alpha blend, occlusion query, instancing/stream offset, simultaneous RTs; bare shader support → 9.1, nothing → 9.0).
- Lost/reset machinery: `validateDevice` state machine over TestCooperativeLevel (OK / DEVICELOST / DEVICENOTRESET / unknown); `handleDeviceLost` destroys main FB then fireDeviceLost + frameCallback(NULL); `resetDevice` calls device9->Reset, on success fireDeviceRestored + recreate main framebuffer.
- Factories: createVertexShader/createFragmentShader/createShaderProgram throw RBX::runtime_error without shader support; createShaderProgramFFP throws without FFP support; buffers/layout/texture/renderbuffer/geometry/framebuffer factories construct the corresponding D3D9 classes directly.
- VR: `getVR()` returns NULL, `setVR(bool)` no-op.

## Usage

Created by the device factory with a native Win32 HWND. Callers must run validate() each frame before beginFrame() and treat a NULL context as "skip this frame". Resource lifetime is tied to the lost/restore notification cycle (fireDeviceLost/fireDeviceRestored).

## Gotchas

- `endFrame()` has `RBXASSERT(!deviceLost)` — callers must not call it after a failed validate.
- The frame-event query busy-wait can spin up to 5 seconds of CPU per frame before the query is abandoned (then recreated next frame); a wedged GPU shows as a stall here.
- Timestamp queries alternate issue/read every other frame (`frameTimeQueryIssued`) — gpuTime is always one frame stale and stays at its initial 0 until the second completed pass.
- `beginFrame` returns NULL on any cooperative-level hiccup — every consumer must null-check the context.
- Global constants must be float4-register aligned (offset % 16 == 0 asserted) because they're blitted straight into registers starting at register 0 of both shader stages.
- DX11 probe happens in the constructor before DX9 init purely for performance reasons; if it yields an empty string, getFeatureLevel() reconstructs from D3D9 caps with "playing detective" heuristics.
- `createDevice` never tries mixed VP or REF device — software rendering is only SWVP-on-HAL; there is no pure-software rasterizer fallback.
- Vendor detection treats 0x163C as Intel alongside 0x8086/0x8087 (Intel usually uses 0x8086; 0x163C is unusual).
