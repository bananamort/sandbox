# Rendering/GfxCore/GL/DeviceGL.cpp

## Purpose

Implementation of `DeviceGL` — the OpenGL/GLES Device backend: platform context creation, capability probing (three variants: GLES, desktop legacy, desktop GL3 flag), main-framebuffer ownership, GL timer-query GPU frame stats, optional fence-sync latency reduction, VR hookup (Cardboard on mobile), and the resource factory methods.

## API

- Flags: `DebugGraphicsGL` (ARB debug output callback), `GraphicsGL3` (prefer GL3/GLES3 paths), `RenderVR` (external), `GraphicsGLReduceLatency` (fence sync each endFrame).
- `static std::set<std::string> getExtensions()` — parses GL_EXTENSIONS; on desktop with GraphicsGL3+GL3.0 falls back to glGetStringi enumeration when the string is empty.
- `static DeviceCapsGL createDeviceCaps(ContextGL*, const std::set<std::string>&)` [GLES builds] — version3 = GraphicsGL3 && "OpenGL ES 3*"; sets supports flags from extensions (OES_element_index_uint, IMG PVR, OES half float/ETC1, APPLE_texture_max_level…), maxTextureUnits 16 vs 8, extVertexArrayObject disabled on Adreno renderers.
- `static DeviceCapsGL createDeviceCapsOld(ContextGL*)` [desktop, !GraphicsGL3] — GLEW-macro-driven caps; NPOT requires ARB_texture_non_power_of_two AND maxTextureSize ≥ 8192 ("GL extensions lie"); Intel vendors lose VAOs (IB state not in VAO); AMD loses texture storage (cubemap/3D-update bugs).
- `static DeviceCapsGL createDeviceCaps(...)` [desktop dispatch] — old path unless GraphicsGL3; GL3 path keys off version[0] >= '3'.
- `static void GLAPIENTRY debugOutputGLARB(...)` — FASTLOGS the message.
- `static DeviceVRGL* createVR()` — Cardboard only, iOS/Android, gated by RenderVR flag.
- `DeviceGL::DeviceGL(void* windowHandle)` — ContextGL::create → caps → log renderer/version/vendor/GLSL/extensions/caps → new DeviceContextGL → main FramebufferGL(glContext->getMainFramebufferId()) + updateMainFramebuffer(0,0) dims → timer query gen (desktop, extTimerQuery) → optional debug callback → Profiler::gpuInit(0) non-Windows → vr->setup(this).
- `~DeviceGL()` — gpuShutdown (non-Windows), vr/context/framebuffer/glContext reset in that order.
- `std::string getFeatureLevel()` — hand-rolled parse of GL_VERSION into "OpenGL X.Y" or "OpenGL unknown".
- `bool validate()` — setCurrent + refresh main framebuffer dimensions; always true (no loss concept).
- `DeviceContext* beginFrame()` — setCurrent, start GL_TIME_ELAPSED query if idle, bindFramebuffer(main), clearStates, return context.
- `void endFrame()` — stop/poll timer query (glGetQueryObjectui64v vs EXT variant by flag) into gpuTime (ms); if GraphicsGLReduceLatency && extSync: client-wait up to 5 s on previous fence, delete it, insert a new glFenceSync; submit VR frame; swapBuffers.
- `Framebuffer* getMainFramebuffer()`; `DeviceVR* getVR()` (NULL unless vr && vrEnabled); `setVR(bool)`.
- `void defineGlobalConstants(size_t dataSize, const std::vector<ShaderGlobalConstant>&)` — stores constants list, forwards size to context (asserted once-only).
- `std::string getShadingLanguage()` — glsl/glsl3/glsles/glsles3 per platform+ext3.
- `std::string createShaderSource(path, defines, fileCallback)` — no preprocessor: returns fileCallback(path) directly.
- `std::vector<char> createShaderBytecode(source, target, entrypoint)` — no bytecode: asserts entrypoint=="main", returns source bytes verbatim.
- Shader factories throw without shader support; `createShaderProgramFFP()` always throws "No FFP support".
- Resource factories: VertexBufferGL/IndexBufferGL/VertexLayoutGL/TextureGL/RenderbufferGL/GeometryGL/FramebufferGL one-liners.
- `DeviceStats getStatistics() const` — gpuFrameTime from polled query.

## Usage

Selected by Device::create(API_OpenGL, windowHandle). Mobile (iOS/Android) uses this for all rendering; desktop it's an option behind D3D9/D3D11. The shader pipeline differs fundamentally from D3D: source passes through untouched and shaders compile at program-link time.

## Gotchas

- GL has no real bytecode stage — createShaderBytecode is identity; any caller expecting offline compilation semantics breaks here.
- FFP is unsupported (throws); caps.supportsFFP is set false in every path despite the base class offering the field.
- The 5-second glClientWaitSync in endFrame can stall the CPU thread deliberately (reduce-latency mode off by default).
- Intel/AMD driver workarounds are Windows-only string matches on GL_VENDOR.
- beginFrame binds the main framebuffer unconditionally — callers wanting to start in another FBO must rebind after beginFrame.
- validate() never reports device loss (returns true always).
