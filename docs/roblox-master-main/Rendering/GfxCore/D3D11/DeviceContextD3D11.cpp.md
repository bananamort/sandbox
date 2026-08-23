# Rendering/GfxCore/D3D11/DeviceContextD3D11.cpp

## Purpose

Implementation of `DeviceContextD3D11` — the D3D11 immediate-mode backend for the abstract `DeviceContext` interface (declared in `include/GfxCore/Device.h`). Translates cached renderer state objects (`RasterizerState`, `BlendState`, `DepthState`, `SamplerState`) into D3D11 pipeline state objects on demand, manages the global constant buffer, framebuffer binding/clear/copy/resolve, texture SRV + sampler binding, draws, and legacy D3DPERF debug markers.

## API

- Tables: `gCullModeD3D11[Cull_Count]`, `gBlendFactors[Factor_Count]`, `gDepthFuncD3D11[Function_Count]`, `gSamplerFilterD3D11[Filter_Count]` (Point/Linear/Anisotropic only), `gSamplerAddressD3D11[Address_Count]` (Wrap/Clamp only).
- `DeviceContextD3D11(Device* device, ID3D11DeviceContext* deviceContext11)` — takes ownership semantics of the immediate context; when `PIX_ENABLED`, `LoadLibraryW(L"d3d9.dll")` + `GetProcAddress` resolves `D3DPERF_BeginEvent/EndEvent/SetMarker/GetStatus`; if no profiler is attached (`GetStatus()` == 0) it force-clears `FFlag::GraphicsDebugMarkersEnable`.
- `~DeviceContextD3D11()` — frees d3d9.dll, releases immediate context, globals constant buffer, and all four state-object hash maps.
- `void defineGlobalConstants(size_t dataSize)` — creates a `D3D11_USAGE_DEFAULT` constant buffer of exactly `dataSize` bytes once (RBXASSERT-guarded against double define).
- `void updateGlobalConstants(const void* data, size_t dataSize)` — `UpdateSubresource` into slot 0 and binds it to both VS and PS (`VSSetConstantBuffers`/`PSSetConstantBuffers(0, 1, ...)`).
- `void bindFramebuffer(Framebuffer*)` — builds RTV array from color renderbuffers, DSV from depth; before binding, unbinds any SRV whose texture owns a bound renderbuffer (feedback-loop avoidance); sets viewport to full buffer size.
- `void setWorldTransforms4x3(const float*, size_t)` / `setConstant(int handle, const float*, size_t)` — forwarded to `cachedProgram` (RBXASSERT a program is bound).
- `void setRasterizerState(const RasterizerState&)` — on pre-DX11 shader profiles strips depth bias (`RasterizerState(cullMode, 0)`); slope bias = `depthBias / 32.f`; `FrontCounterClockwise = true`.
- `void setBlendState(const BlendState&)` — single render target, `BlendOp = ADD`, blend factor `{0,0,0,0}`, sample mask `0xffffffff`; color mask mapped from `Color_R/G/B/A`.
- `void setDepthState(const DepthState&)` — depth disabled entirely for `(Always, write=false)`; stencil modes `Stencil_None` / `Stencil_IsNotZero` (NOT_EQUAL, keep all ops) / `Stencil_UpdateZFail` (front INCR / back DECR on depth-fail); stencil masks 0xFF.
- `void clearStates()` — invalidates every cache field, nulls all PS SRVs, poisons state caches with out-of-range enum values to force re-setup.
- `void setDefaultAnisotropy(unsigned int value)` — used by `bindTexture` when anisotropic sampler has anisotropy 0.
- `void bindTexture(unsigned int stage, Texture*, const SamplerState&)` — PS-only SRV bind (`PSSetShaderResources`), per-stage `TextureUnit` caching; samplers created lazily into `samplerStateHash`.
- `void drawImpl(Geometry*, Geometry::Primitive, unsigned offset, unsigned count, unsigned indexRangeBegin, unsigned indexRangeEnd)` — forwards to `GeometryD3D11::draw(...)` passing its own layout/geometry/program caches.
- `void bindProgram(ShaderProgram*)` — caches program, calls `bind()`, resets vertex-layout cache (layout is per vertex shader).
- `ID3D11DeviceContext* getContextDX11()` — raw context accessor.
- `void clearFramebuffer(unsigned int mask, const float color[4], float depth, unsigned int stencil)` — RBXASSERT a bound framebuffer; clears each color RTV and/or depth-stencil view.
- `void copyFramebuffer(Framebuffer*, Texture*)` — `CopyResource`; asserts 2D, 1 mip, matching dimensions.
- `void resolveFramebuffer(FrameBuffer* msaaBuffer, Framebuffer*, unsigned int mask)` — per-attachment `ResolveSubresource` using `TextureD3D11::getInternalFormat`.
- `void discardFramebuffer(Framebuffer*, unsigned int mask)` — empty no-op.
- `void invalidateCachedGeometry()/invalidateCachedProgram()/invalidateCachedVertexLayout()/invalidateCachedTexture(Texture*)` — called by resource destructors/draw paths to keep the caches honest.
- `static void ascii2unicode(wchar_t* dest, const char* src, int max)` — local helper for marker text.
- `void pushDebugMarkerGroup(const char*)` / `popDebugMarkerGroup()` / `setDebugMarker(const char*)` — D3DPERF events/markers ("works for RenderDoc too"), 512-wchar buffers.
- `void beginQuery(ID3D11Query*)` / `endQuery(ID3D11Query*)` / `bool getQueryData(ID3D11Query*, void* dataOut, size_t dataSize)` — thin query wrappers; `getQueryData` uses `D3D11_ASYNC_GETDATA_DONOTFLUSH` and returns `hr == S_OK`.

## Usage

Instantiated only by `DeviceD3D11` (see DeviceD3D11.h/.cpp), which passes its `ID3D11DeviceContext`. It implements the full non-VR portion of `DeviceContext`; higher renderer code calls it exclusively through the abstract interface. State objects are content-addressed through `rasterizerStateHash`/`blendStateHash`/`depthStateHash`/`samplerStateHash` with `checkDuplicates` verification.

## Gotchas

- Textures are bound **pixel-shader only** (`PSSetShaderResources`/`PSSetSamplers`) — no VS texture support in this backend.
- Only a subset of sampler filters/address modes exists in the lookup tables; adding new enum values in `SamplerState` without extending these tables will index out of bounds.
- `defineGlobalConstants` must be called exactly once before `updateGlobalConstants`; sizes must match.
- Depth-bias rasterizer states are ignored unless the device shader profile is DX11 (`getShaderProfile() == shaderProfile_DX11`).
- `discardFramebuffer` silently does nothing (no D3D11 discard equivalent used here).
- Debug markers go through d3d9.dll's D3DPERF exports even on the D3D11 path; if no profiler is attached the feature flag is switched off globally at construction time.
- `copyFramebuffer` requires destination texture with exactly 1 mip level and identical dimensions (RBXASSERT).
