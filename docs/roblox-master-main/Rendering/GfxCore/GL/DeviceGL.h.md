# Rendering/GfxCore/GL/DeviceGL.h

## Purpose

Class declarations for the OpenGL/GLES backend: `DeviceVRGL` (VR extension of the GL device contract), `DeviceCapsGL` (capability flags incl. per-extension booleans), `DeviceContextGL` (immediate-mode DeviceContext implementation), and `DeviceGL` (Device implementation owning context, main framebuffer, stats queries, VR adapter).

## API

- `class DeviceVRGL : public DeviceVR` — adds `virtual void setup(Device*) = 0`, `virtual void submitFrame(DeviceContext*) = 0`; `static DeviceVRGL* createCardboard()`.
- `struct DeviceCapsGL : DeviceCaps` — extra fields: `bool ext3; extVertexArrayObject; extTextureStorage; extMapBuffer; extMapBufferRange; extTimerQuery; extDebugMarkers; extSync;`.
- `class DeviceContextGL : public DeviceContext`
  - `DeviceContextGL(DeviceGL* dev)` / `~DeviceContextGL()`.
  - Overrides: defineGlobalConstants(size_t), clearStates, invalidateCachedProgram, invalidateCachedTexture(Texture*), invalidateCachedTextureStage(unsigned int) (GL-specific), setDefaultAnisotropy(unsigned), updateGlobalConstants(const void*, size_t), bindFramebuffer/clearFramebuffer/copyFramebuffer/resolveFramebuffer/discardFramebuffer, bindProgram/setWorldTransforms4x3/setConstant, bindTexture(stage, Texture*, SamplerState), setRasterizerState/setBlendState/setDepthState, drawImpl(...), pushDebugMarkerGroup/popDebugMarkerGroup/setDebugMarker.
  - State: `std::vector<char> globalData; unsigned int globalDataVersion; unsigned int defaultAnisotropy; ShaderProgramGL* cachedProgram; TextureGL* cachedTextures[16]; RasterizerState/BlendState/DepthState caches; DeviceGL* device;`.
- `class DeviceGL : public Device`
  - `DeviceGL(void* windowHandle)` — creates the platform ContextGL via `ContextGL::create`.
  - Frame: `bool validate()`, `DeviceContext* beginFrame()`, `void endFrame()`, `Framebuffer* getMainFramebuffer()`.
  - VR: `DeviceVR* getVR()`, `void setVR(bool enabled)`.
  - Constants/shaders: `defineGlobalConstants(size_t, const std::vector<ShaderGlobalConstant>&)`, `getAPIName()` → "OpenGL", `getFeatureLevel()/getShadingLanguage()`, `createShaderSource(path, defines, fileCallback)`, `createShaderBytecode(source, target, entrypoint)`, shader factories + `createShaderProgramFFP()` (fixed-function emulation).
  - Resource factories: vertex/index buffers, vertex layout, texture, renderbuffer, `createGeometryImpl(...)`, `createFramebufferImpl(...)`.
  - Info/stats: `getCaps()`/`getCapsGL()`, `getStatistics()` (timer-query based gpu frame time).
  - Accessors: `DeviceContextGL* getImmediateContextGL()`, `const std::vector<ShaderGlobalConstant>& getGlobalConstants()`.
  - Members: `DeviceCapsGL caps; scoped_ptr<DeviceContextGL> immediateContext; scoped_ptr<FramebufferGL> mainFramebuffer; globalConstants; unsigned frameTimeQueryId; bool frameTimeQueryIssued; GLsync frameEventQueryId; bool frameEventQueryIssued; float gpuTime; scoped_ptr<DeviceVRGL> vr; bool vrEnabled; scoped_ptr<ContextGL> glContext;`.

## Usage

Instantiated by the Device factory when `API_OpenGL` is requested. Higher layers use only the abstract Device/DeviceContext/DeviceVR interfaces; the GL-specific surface (`getCapsGL`, `getImmediateContextGL`, invalidate helpers) serves sibling GL classes.

## Gotchas

- `typedef struct __GLsync *GLsync;` at file scope duplicates HeadersGL.h's Android typedef — include-order sensitive.
- Texture cache is fixed at 16 stages.
- `createShaderBytecode` on GL does not produce GPU bytecodes in the D3D sense (see DeviceGL.cpp for actual semantics).
- VR is pluggable: currently only Cardboard via `createCardboard()` (GearVR exists as a separate class in GearVRGL.cpp but is not exposed here).
