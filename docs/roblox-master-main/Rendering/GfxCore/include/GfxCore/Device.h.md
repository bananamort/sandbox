# Rendering/GfxCore/include/GfxCore/Device.h

## Purpose

The central abstraction of GfxCore. Defines three classes: `DeviceContext` (immediate-mode command interface: bind framebuffer/program/textures/states and draw), `Device` (resource factory + frame lifecycle + shader-source compilation), `DeviceVR` (HMD pose/eye-framebuffer interface), plus the capability descriptor `DeviceCaps` and per-frame `DeviceStats`. Concrete backends: D3D9 (`DeviceD3D9`/`DeviceContextD3D9`), D3D11 (`DeviceD3D11`/`DeviceContextD3D11`, with Win32/Durango variants), OpenGL (`DeviceGL`/`DeviceContextGL`).

## API

- `class DeviceContext`
  - `enum BufferMask { Buffer_Color=1<<0, Buffer_Depth, Buffer_Stencil }`.
  - `virtual void setDefaultAnisotropy(unsigned int value) = 0`
  - `virtual void updateGlobalConstants(const void* data, size_t dataSize) = 0` — upload the global constant block registered by `defineGlobalConstants`.
  - Framebuffer ops: `bindFramebuffer(Framebuffer*)`, `clearFramebuffer(unsigned int mask, const float color[4], float depth, unsigned int stencil)`, `copyFramebuffer(Framebuffer*, Texture*)`, `resolveFramebuffer(Framebuffer* msaaBuffer, Framebuffer*, unsigned int mask)`, `discardFramebuffer(Framebuffer*, unsigned int mask)`.
  - Program/constants: `bindProgram(ShaderProgram*)`, `setWorldTransforms4x3(const float* data, size_t matrixCount)` (note: 4x3 row-major world matrices), `setConstant(int handle, const float* data, size_t vectorCount)`.
  - `virtual void bindTexture(unsigned int stage, Texture*, const SamplerState&) = 0`.
  - State: `setRasterizerState(const RasterizerState&)`, `setBlendState(const BlendState&)`, `setDepthState(const DepthState&)`.
  - Non-virtual draw entry points: `void draw(Geometry*, Geometry::Primitive, unsigned int offset, unsigned int count, unsigned int indexRangeBegin, unsigned int indexRangeEnd)` and `void draw(const GeometryBatch&)`; both forward to pure-virtual `drawImpl(...)`. The index range exists for D3D9's DrawIndexedPrimitive min/maxIndex computation.
  - Debug markers: `pushDebugMarkerGroup(const char*)`, `popDebugMarkerGroup()`, `setDebugMarker(const char*)`.
- `struct DeviceCaps` — booleans (`supportsFramebuffer/Shaders/FFP/Stencil/Index32/TextureDXT/PVR/HalfFloat/3D/NPOT/ETC1/TexturePartialMipChain`), limits (`maxDrawBuffers/maxSamples/maxTextureSize/maxTextureUnits`), quirks (`colorOrderBGR`, `needsHalfPixelOffset`, `requiresRenderTargetFlipping`), `retina`; `dumpToFLog(int channel)`.
- `struct DeviceStats { float gpuFrameTime; }`.
- `class DeviceVR` — nested `Pose { bool valid; float position[3]; float orientation[4]; }`, `State { Pose headPose; Pose handPose[2]; float eyeOffset[2][3]; float eyeFov[2][4]; /* up-down-left-right */ bool needsMirror; }`; virtuals `update()`, `recenter()`, `Framebuffer* getEyeFramebuffer(int eye)`, `State getState()`.
- `typedef boost::function<void(void*)> DeviceFrameDataCallback`.
- `class Device`
  - `enum API { API_OpenGL, API_Direct3D9, API_Direct3D11 }`; `static Device* create(API api, void* windowHandle)` — implemented in DeviceCreate.cpp.
  - Frame lifecycle: `bool validate()` (D3D9 loss check), `DeviceContext* beginFrame()`, `void endFrame()`, `Framebuffer* getMainFramebuffer()`.
  - VR: `DeviceVR* getVR()`, `void setVR(bool enabled)`.
  - Constants/shaders: `defineGlobalConstants(size_t dataSize, const std::vector<ShaderGlobalConstant>&)`; shader-source pipeline `std::string getAPIName() / getFeatureLevel() / getShadingLanguage()`; `createShaderSource(path, defines, fileCallback)` (preprocessor over source files); `createShaderBytecode(source, target, entrypoint)` (offline-style compile to a bytecode blob); factory trio `createVertexShader/createFragmentShader(bytecode)` → `createShaderProgram(vs, fs)` and FFP fallback `createShaderProgramFFP()`.
  - Geometry factories: `createVertexBuffer/createIndexBuffer(elementSize, elementCount, GeometryBuffer::Usage)`, `createVertexLayout(elements)`, non-virtual `createGeometry(layout, vertexBuffer|vector<VertexBuffer>, indexBuffer, baseVertexIndex=0)` forwarding to `createGeometryImpl(...vector form...)`.
  - Textures/framebuffers: `createTexture(Type, Format, width, height, depth, mipLevels, Usage)`, `createRenderbuffer(Format, w, h, samples)`, non-virtual single/multi-RT `createFramebuffer(color[, depth])` forwarding to `createFramebufferImpl(vector color, depth)`.
  - Info/stats: `const DeviceCaps& getCaps()`, `DeviceStats getStatistics()`; `suspend()/resume()` default `RBXASSERT(false)` — "only DX11-Durango".
  - Protected: intrusive resource list heads (`resourceListHead/Tail`), `fireDeviceLost()/fireDeviceRestored()`.

## Usage

This is the seam every backend implements and every higher renderer consumes exclusively — no backend headers leak above this directory. Typical flow: `Device::create(api, windowHandle)` at startup → `validate()` each frame → `beginFrame()` gives a `DeviceContext` used for all binds/draws → `endFrame()` presents. Shader assets are compiled via `createShaderSource`+`createShaderBytecode` into bytecodes cached by callers.

## Gotchas

- `setWorldTransforms4x3` takes 4x3 matrices — D3D9-era convention; backends expand to 4x4 internally.
- The `indexRangeBegin/indexRangeEnd` pair on draws is purely for D3D9 `DrawIndexedPrimitive` min/max index optimization but must be supplied on all backends.
- `createShaderSource` receives a file-callback so include resolution is owned by the caller (content system), not the device.
- Durango-only suspend/resume asserts on other backends if called.
