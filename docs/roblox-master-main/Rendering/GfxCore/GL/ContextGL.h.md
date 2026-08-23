# Rendering/GfxCore/GL/ContextGL.h

## Purpose

Abstract platform GL context interface — window-system glue (WGL/CGL/EAGL/Android EGL) behind a single factory. Lets `DeviceGL` stay platform-agnostic for context current-ness, buffer swap, and main (window) framebuffer behavior.

## API

- `static ContextGL* create(void* windowHandle)` — implemented per-platform in ContextGLWin32.cpp / ContextGLMac.mm / ContextGLiOS.mm / ContextGLAndroid.cpp.
- `virtual void setCurrent() = 0` — make the context current on the calling thread.
- `virtual void swapBuffers() = 0` — present.
- `virtual unsigned int getMainFramebufferId() = 0` — FBO id to bind for drawing to the window surface (0 on desktop, an FBO on iOS).
- `virtual bool isMainFramebufferRetina() = 0` — whether the drawable is scaled 2x.
- `virtual std::pair<unsigned int, unsigned int> updateMainFramebuffer(unsigned int width, unsigned int height) = 0` — resize; returns the resulting drawable size.

## Usage

`DeviceGL::validate()`/frame flow drives setCurrent/swapBuffers; main-framebuffer binding and retina handling route through these calls so the rest of the backend never touches platform APIs.

## Gotchas

- Pure interface — no data members; lifetime managed by owner (DeviceGL side), not self-registering.
- The returned pair's units are pixels of the actual drawable, which can differ from the requested logical size on retina displays.
