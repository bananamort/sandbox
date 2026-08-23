# Rendering/GfxCore/GL/ContextGLiOS.mm

## Purpose

iOS EAGL implementation of `ContextGL` plus the platform GL-extension shim layer: stub functions mapping HeadersGL.h's generic GLES entry points (VAO, mapbuffer, tex storage, 3D textures, sync, blit, invalidate) onto iOS OES/EXT/APPLE suffixed exports or the GLES3 framework. Builds the main render-to-CALayer framebuffer with drawable-backed color renderbuffer.

## API

Compiled only under RBX_PLATFORM_IOS.

- `namespace GLES3 { extern "C" ... }` — direct imports of glTexImage3D/glTexSubImage3D/glTexStorage3D/glBlitFramebuffer/glRenderbufferStorageMultisample/glInvalidateFramebuffer from the system.
- Extension shims (file-scope C functions): glBindVertexArray/glDeleteVertexArrays/glGenVertexArrays → *OES; glMapBuffer/glUnmapBuffer → *OES; glMapBufferRange → EXT; glTexStorage2D → EXT; glTexImage3D/glTexSubImage3D/glTexStorage3D → GLES3::; glFenceSync/glDeleteSync/glClientWaitSync/glWaitSync → *APPLE; glBlitFramebuffer/glRenderbufferStorageMultisample/glInvalidateFramebuffer → GLES3::.
- Flag: `GraphicsGL3` (external) — try ES3 API first, fall back to ES2.
- `class ContextGLEAGL : public ContextGL` — members view/layer/context + colorRenderbufferId/depthRenderbufferId/framebufferId/renderbufferWidth/Height.
  - ctor(void* windowHandle) — retains UIView and its CAEAGLLayer; ES3→ES2 context fallback under flag else ES2-only (throw on failure); enables 2x contentScaleFactor when isMainFramebufferRetina(); layer opaque + non-retained backing + RGBA8; current context; color renderbuffer allocated **from the drawable** (`renderbufferStorage:fromDrawable:`), dims queried back; D24S8_OES depth/stencil renderbuffer; FBO with color+depth+stencil attachments; throws unless COMPLETE.
  - dtor — setCurrent, delete FBO/renderbuffers, clear current, release objc objects.
  - `setCurrent()` — EAGLContext switch on change.
  - `swapBuffers()` — rebind color renderbuffer + presentRenderbuffer.
  - `unsigned getMainFramebufferId()` — returns the private FBO id (**not** 0, unlike desktop).
  - `bool isMainFramebufferRetina()` — screen scale ≥2 && iOS ≥6.0 && ES3 context (comment: iOS 5.1 GLES impl can't render into NPOT targets).
  - `pair<unsigned,unsigned> updateMainFramebuffer(w,h)` — cached renderbuffer dims (inputs ignored).
- `static ContextGL* ContextGL::create(void*)`.

## Usage

DeviceGL on iOS. The whole engine renders into getMainFramebufferId()'s FBO whose color attachment IS the CALayer drawable; presentRenderbuffer does the swap.

## Gotchas

- Unlike every other platform, the "main framebuffer" here is a real FBO wrapping the drawable — code assuming id 0 breaks on iOS.
- Retina requires ES3 + iOS 6+: older devices silently render at 1x scale even on Retina panels.
- The extension shims are unconditional wrappers; calling e.g. glMapBufferRange on a pre-EXT device links but crashes at runtime (no null-guards) — capability flags in DeviceCapsGL are what gate usage.
- Depth buffer uses DEPTH24_STENCIL8_OES packed format bound to both depth and stencil points.
- Drawable properties request non-retained backing (fastest, content undefined after present).
