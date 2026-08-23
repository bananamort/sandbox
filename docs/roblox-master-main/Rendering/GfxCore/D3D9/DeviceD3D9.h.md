# Rendering/GfxCore/D3D9/DeviceD3D9.h

## Purpose

Class declarations for the Direct3D 9 backend: `DeviceCapsD3D9` (caps + GPU vendor), `DeviceContextD3D9` (immediate-mode `DeviceContext` implementation over `IDirect3DDevice9`), its fixed-function-emulation subclass `DeviceContextFFPD3D9`, `QueryD3D9` (event/timing query wrapper), and `DeviceD3D9` (`Device` implementation with device-lost/reset handling).

## API

- `struct DeviceCapsD3D9 : DeviceCaps` — adds `Vendor vendor` with enum values `Vendor_Unknown`, `Vendor_NVidia`, `Vendor_AMD`, `Vendor_Intel`.
- `class DeviceContextD3D9 : public DeviceContext`
  - `DeviceContextD3D9(Device* device)` / `~DeviceContextD3D9()`.
  - Overrides: defineGlobalConstants(size_t), clearStates, invalidateCachedProgram, invalidateCachedVertexLayout, invalidateCachedGeometry, invalidateCachedTexture(Texture*), updateGlobalConstants(const void*, size_t), setDefaultAnisotropy(unsigned int), bindFramebuffer/clearFramebuffer/copyFramebuffer/resolveFramebuffer/discardFramebuffer, bindProgram/setWorldTransforms4x3/setConstant, bindTexture(stage, Texture*, SamplerState), setRasterizerState/setBlendState/setDepthState, drawImpl(Geometry*, Geometry::Primitive, offset, count, indexRangeBegin, indexRangeEnd), pushDebugMarkerGroup/popDebugMarkerGroup/setDebugMarker.
  - State: `Device* device; IDirect3DDevice9* device9; size_t globalDataSize; unsigned int defaultAnisotropy; unsigned int cachedFramebufferSurfaces; ShaderProgramD3D9* cachedProgram; VertexLayoutD3D9* cachedVertexLayout; GeometryD3D9* cachedGeometry; TextureUnit cachedTextureUnits[16];` rasterizer/blend/depth caches.
  - D3DPERF function pointers loaded dynamically: `pfn_D3DPERF_BeginEvent/pfn_D3DPERF_EndEvent/pfn_D3DPERF_SetMarker`.
- `class DeviceContextFFPD3D9 : public DeviceContextD3D9` — overrides only `updateGlobalConstants`, `bindProgram`, `setWorldTransforms4x3`, `setConstant` to emulate shaders via the fixed-function pipeline.
- `class QueryD3D9 : public Resource` — `QueryD3D9(Device*, unsigned int type)`; `onDeviceLost()/onDeviceRestored()`; `IDirect3DQuery9* getObject()`.
- `class DeviceD3D9 : public Device`
  - `DeviceD3D9(void* windowHandle)` / `~DeviceD3D9()`.
  - Frame: `validate()`, `beginFrame()` → immediate context, `endFrame()`, `getMainFramebuffer()`.
  - VR: `getVR()` / `setVR(bool)` (stub — no VR backend on D3D9).
  - Constants/shaders: defineGlobalConstants(size_t, const std::vector<ShaderGlobalConstant>&), getAPIName() → "DirectX 9", getFeatureLevel(), getShadingLanguage(), createShaderSource(path, defines, fileCallback), createShaderBytecode(source, target, entrypoint).
  - Shader factories: createVertexShader/createFragmentShader(bytecode), createShaderProgram(vs, fs), `createShaderProgramFFP()`.
  - Resource factories: vertex/index buffers, vertex layout, texture, renderbuffer, `createGeometryImpl(...)`, `createFramebufferImpl(color, depth)`.
  - Info/stats/accessors: `getCaps()`/`getCapsD3D9()`, `getStatistics()`, `getImmediateContextD3D9()`, `getDevice9()`, `getGlobalDataSize()`, `getGlobalConstants()` (map name→ShaderGlobalConstant).
  - Private members: windowHandle, IDirect3D9*/IDirect3DDevice9*, `deviceLost`, caps, immediate context, main framebuffer, `frameEventQuery` + issued flag, three frame-time queries (`frameTimeBeginQuery/frameTimeEndQuery/frameTimeFreqQuery`) + issued flag, `gpuTime`, globalDataSize/globalConstants map, `frameCallback` (DeviceFrameDataCallback), cached `featureLvlStr`; helpers `createMainFramebuffer/validateDevice/resetDevice/handleDeviceLost/getFeatureLevelDX11`.
  - Private `DX11_FEATURE_LEVEL` enum (0x9100…0xb100) mirrors D3D11 feature levels for `getFeatureLevelDX11`, plus a raw `DX11_CreateDevice` typedef used to probe DX11-level support.

## Usage

Instantiated by the Device factory for `API_Direct3D9`. Higher layers use the abstract interfaces; the D3D9-specific surface (`getCapsD3D9`, `getImmediateContextD3D9`, `getDevice9`) serves sibling D3D9 classes. All D3D9 COM interface types are forward-declared (`struct IDirect3D9;` etc.), so including this header does not pull in d3d9.h.

## Gotchas

- `device9` appears in both the context (borrowed pointer) and the device (owner); lifetime is tied to reset/lost handling in DeviceD3D9.cpp.
- Texture unit cache is fixed at 16 stages.
- `cachedFramebufferSurfaces` tracks bound FBO surfaces — invalidate paths must keep it consistent or binds are skipped incorrectly.
- The header declares a Windows-only surface (HMODULE, WINAPI function pointers) despite forward-declaring COM types; not portable outside Win32 builds.
- `getFeatureLevel()` result is cached in `featureLvlStr` and obtained by probing D3D11 DLLs via `DX11_CreateDevice` — it reports hardware DX11 feature level even though rendering is D3D9.
