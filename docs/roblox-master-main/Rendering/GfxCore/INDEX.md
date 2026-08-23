# Rendering/GfxCore — Index

GfxCore is the backend-abstraction layer of Roblox's renderer: a set of abstract interfaces (in `include/GfxCore/`) that higher-level rendering code programs against, plus three concrete implementations selected at runtime. `Device::create(API, windowHandle)` (DeviceCreate.cpp) is the single factory entry point: `API_Direct3D9` → DeviceD3D9 (Win32 only), `API_Direct3D11` → DeviceD3D11 (Win32/Durango), `API_OpenGL` → DeviceGL (Win32/Mac/iOS/Android + GearVR/Cardboard VR). Everything above the factory sees only `Device` (frame lifecycle, caps, resource factories), `DeviceContext` (immediate-mode state/draw commands), and opaque `Texture`/`Framebuffer`/`Geometry`/`Shader`/`Resource` handles; each backend mirrors this split as `DeviceXxx` + `DeviceContextXxx` + per-resource classes (`TextureGL`, `FramebufferD3D11`, …) with identical responsibilities: state caching per context, device-lost/restore notifications for non-managed resources, and API-specific translation tables from backend-neutral enums (rasterizer/blend/depth states, sampler states, vertex layouts, primitive types) to native equivalents. Shared root files implement the interface base classes and the device factory; `glew/` contains the vendored OpenGL extension loader and is intentionally undocumented.

## Roster

### Root — abstract interface implementation & factory
- [pix.cpp](pix.cpp.md) — PIX/profiler marker plumbing.
- [States.cpp](States.cpp.md) — rasterizer/blend/depth/sampler state objects.
- [Shader.cpp](Shader.cpp.md) — shader/program base classes.
- [Device.cpp](Device.cpp.md) — Device base: lost/restore notification fan-out.
- [Texture.cpp](Texture.cpp.md) — Texture base: formats, sizes, region math.
- [Framebuffer.cpp](Framebuffer.cpp.md) — Framebuffer/Renderbuffer bases.
- [Resource.cpp](Resource.cpp.md) — Resource base (device back-pointer, lost/restore hooks).
- [DeviceCreate.cpp](DeviceCreate.cpp.md) — `Device::create(API)` backend dispatch.
- [Geometry.cpp](Geometry.cpp.md) — Geometry/VertexLayout/vertex+index buffer bases.

### include/GfxCore — public abstract interfaces
- [pix.h](include/GfxCore/pix.h.md)
- [States.h](include/GfxCore/States.h.md)
- [Geometry.h](include/GfxCore/Geometry.h.md)
- [Texture.h](include/GfxCore/Texture.h.md)
- [Framebuffer.h](include/GfxCore/Framebuffer.h.md)
- [Device.h](include/GfxCore/Device.h.md)
- [Resource.h](include/GfxCore/Resource.h.md)
- [Shader.h](include/GfxCore/Shader.h.md)

### GL — OpenGL / OpenGL ES backend (Win32, Mac, iOS, Android; Cardboard/GearVR VR)
- [HeadersGL.h](GL/HeadersGL.h.md) — GL header aggregation per platform.
- [ContextGL.h](GL/ContextGL.h.md) / platform contexts: [ContextGLWin32.cpp](GL/ContextGLWin32.cpp.md), [ContextGLMac.mm](GL/ContextGLMac.mm.md), [ContextGLiOS.mm](GL/ContextGLiOS.mm.md), [ContextGLAndroid.cpp](GL/ContextGLAndroid.cpp.md).
- [DeviceGL.h](GL/DeviceGL.h.md) / [DeviceGL.cpp](GL/DeviceGL.cpp.md) — device, caps, stats, VR adapter.
- [DeviceContextGL.cpp](GL/DeviceContextGL.cpp.md) — immediate context.
- [TextureGL.h](GL/TextureGL.h.md) / [TextureGL.cpp](GL/TextureGL.cpp.md).
- [FramebufferGL.h](GL/FramebufferGL.h.md) / [FramebufferGL.cpp](GL/FramebufferGL.cpp.md).
- [ShaderGL.h](GL/ShaderGL.h.md) / [ShaderGL.cpp](GL/ShaderGL.cpp.md) — GLES/HLSL→GLSL shader pipeline.
- [GeometryGL.h](GL/GeometryGL.h.md) / [GeometryGL.cpp](GL/GeometryGL.cpp.md).
- VR: [CardboardVRGL.cpp](GL/CardboardVRGL.cpp.md), [GearVRGL.cpp](GL/GearVRGL.cpp.md).

### D3D9 — Direct3D 9 backend (Win32 only)
- [DeviceD3D9.h](D3D9/DeviceD3D9.h.md) / [DeviceD3D9.cpp](D3D9/DeviceD3D9.cpp.md) — device, lost/reset machinery, HWVP/SWVP fallback.
- [DeviceContextD3D9.cpp](D3D9/DeviceContextD3D9.cpp.md) — immediate context + FFP emulation subclass.
- [TextureD3D9.h](D3D9/TextureD3D9.h.md) / [TextureD3D9.cpp](D3D9/TextureD3D9.cpp.md) — mirror-based dynamic texture updates.
- [FramebufferD3D9.h](D3D9/FramebufferD3D9.h.md) / [FramebufferD3D9.cpp](D3D9/FramebufferD3D9.cpp.md) — surface views, readback.
- [ShaderD3D9.h](D3D9/ShaderD3D9.h.md) / [ShaderD3D9.cpp](D3D9/ShaderD3D9.cpp.md) — constant-table reflection, d3dx runtime compilation.
- [GeometryD3D9.h](D3D9/GeometryD3D9.h.md) / [GeometryD3D9.cpp](D3D9/GeometryD3D9.cpp.md).

### D3D11 — Direct3D 11 backend (Win32 + Durango/Xbox One)
- [HeadersD3D11.h](D3D11/HeadersD3D11.h.md).
- [DeviceD3D11.h](D3D11/DeviceD3D11.h.md) / [DeviceD3D11.cpp](D3D11/DeviceD3D11.cpp.md); platform variants: [DeviceD3D11Win32.cpp](D3D11/DeviceD3D11Win32.cpp.md), [DeviceD3D11Durango.cpp](D3D11/DeviceD3D11Durango.cpp.md).
- [DeviceContextD3D11.cpp](D3D11/DeviceContextD3D11.cpp.md).
- [TextureD3D11.h](D3D11/TextureD3D11.h.md) / [TextureD3D11.cpp](D3D11/TextureD3D11.cpp.md).
- [FramebufferD3D11.h](D3D11/FramebufferD3D11.h.md) / [FramebufferD3D11.cpp](D3D11/FramebufferD3D11.cpp.md).
- [ShaderD3D11.h](D3D11/ShaderD3D11.h.md) / [ShaderD3D11.cpp](D3D11/ShaderD3D11.cpp.md).
- [GeometryD3D11.h](D3D11/GeometryD3D11.h.md) / [GeometryD3D11.cpp](D3D11/GeometryD3D11.cpp.md).
- VR: [OculusVRD3D11.cpp](D3D11/OculusVRD3D11.cpp.md), [OpenVRD3D11.cpp](D3D11/OpenVRD3D11.cpp.md).

_Excluded_: `glew/` (vendored GLEW loader, out of scope by contract). Build-system files (`CMakeLists.txt`, `.vcxproj`, `.xcodeproj`) are not documented.
