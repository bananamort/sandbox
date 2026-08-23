# Rendering/GfxCore/D3D11/DeviceD3D11.h

## Purpose

Class declarations for the D3D11 backend: `DeviceVRD3D11` (abstract VR with Oculus/OpenVR factories), `DeviceContextD3D11` (immediate context with state caching/interning), and `DeviceD3D11` (device + swapchain + frame lifecycle, with Win32/Durango platform split delegated to cpp files). Also the `ReleaseCheck` COM-release helper that asserts refcount 0 on desktop but not Xbox.

## API

- `template<class Ty> inline void ReleaseCheck(Ty*& object)` — `object->Release()`, `RBXASSERT(refCnt == 0)` unless Durango ("on xbox, object->Release() always returns 1"), nulls pointer.
- `class DeviceVRD3D11 : public DeviceVR` — adds `virtual void setup(Device*) = 0`, `virtual void submitFrame(DeviceContext*) = 0`; statics `createOculus(IDXGIAdapter** outAdapter)` / `createOpenVR(IDXGIAdapter** outAdapter)`.
- `class DeviceContextD3D11 : public DeviceContext`
  - ctor `(Device*, ID3D11DeviceContext*)`.
  - Extras: `defineGlobalConstants(size_t dataSize)`, `getGlobalDataSize()`, `clearStates()`, cache invalidators `invalidateCachedProgram/VertexLayout/Geometry/invalidateCachedTexture(Texture*)` (used when resources are destroyed/reloaded), query helpers `beginQuery/endQuery/getQueryData(ID3D11Query*, void*, size_t)`, `getContextDX11()`.
  - State: cached `Framebuffer*/ShaderProgramD3D11*/VertexLayoutD3D11*/GeometryD3D11*`; `TextureUnit cachedTextureUnits[16]` (texture + SamplerState, default Filter_Point); cached Rasterizer/Blend/Depth states.
  - Interning: boost::unordered_map keyed by each GfxCore state type via `StateHasher<T>` → native ID3D11RasterizerState/BlendState/DepthStencilState/SamplerState; debug-only `checkDuplicates` walks a hash asserting no duplicate native object.
  - Members: `device11`, `immediateContext11`, `globalsConstantBuffer` + `globalDataSize`, `defaultAnisotropy`.
  - D3D9-legacy perf markers: function pointers `pfn_D3DPERF_BeginEvent/EndEvent/SetMarker` loaded from an `HMODULE d3d9` — used to implement debug marker groups via d3d9perf for tooling compatibility.
- `class DeviceD3D11 : public Device`
  - `enum ShaderProfile { shaderProfile_DX11, shaderProfile_DX11_level_9_3 }` — feature-level split.
  - `getAPIName()` = "DirectX 11"; `getFeatureLevel()`/`getShadingLanguage()` return "D3D11"/"hlsl11" or "D3D11_9.3"/"hlsl11_level_9_3" per profile.
  - All Device factory virtuals; `createShaderSource(path, defines, fileCallback)` and `createShaderBytecode(source, target, entrypoint)` declared here.
  - Durango-only `suspend()/resume()` overrides.
  - Accessors: `getDevice11()`, `getShaderProfile()`, `getImmediateContext11()`, `getImmediateContextD3D11()`, `getWindowHandle()`.
  - Private: windowHandle, caps, device11, swapChain11, immediateContext (scoped_ptr), mainFramebuffer, `createMainFramebuffer(w,h)`, shaderProfile, gpuTime + three timestamp queries (`beginQuery`, `endQuery`, `disjointQuery`, `frameTimeQueryIssued`) for GPU frame timing, vr/vrEnabled; platform-dependent privates `createDevice()`, `present()`, `resizeSwapchain()`, `getFramebufferSize()` implemented separately in DeviceD3D11Win32.cpp / DeviceD3D11Durango.cpp.

## Usage

Win32 client and Durango console renderer. The context caches everything per-frame; resource classes call the invalidate* hooks so destroyed objects never linger in caches.

## Gotchas

- Two shader profiles exist: full D3D11 vs feature level 9_3 (low-end); shading-language name changes accordingly, so offline/source shader selection must branch on it.
- Debug markers go through dynamically-bound D3D9 D3DPERF entry points even on D3D11 (PIX compatibility).
- GPU timer is a triple-query (timestamp start/end + disjoint) pattern; stats come from `getStatistics()`.
