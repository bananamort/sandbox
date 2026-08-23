# Rendering/GfxCore/GL/ContextGLAndroid.cpp

## Purpose

Android EGL implementation of `ContextGL` plus the runtime extension-resolution shim layer: resolves HeadersGL.h's generic GLES entry points via eglGetProcAddress with core-name-then-extension-suffix fallback, sets up display/surface/context against an ANativeWindow with a six-way config fallback chain, and disables vsync.

## API

- Extension pointers: static function pointers for VAO trio (OES), glMapBuffer/glUnmapBuffer (OES), glMapBufferRange (EXT), glTexImage3D/glTexSubImage3D (OES), glTexStorage2D/3D (EXT), sync quad (EXT), glBlitFramebuffer/glRenderbufferStorageMultisample/glInvalidateFramebuffer (EXT).
- `template<T> static void loadExtensionGL(T& ptr, const char* namecore, const char* nameext)` — eglGetProcAddress(core) then eglGetProcAddress(ext); no clearing of previous values.
- `#define LOAD_EXTENSION_GL(name, suffix)` — wires namePtr to "name" / "name<suffix>".
- Stub functions (file scope): each generic entry point forwards through its Ptr; **no null checks**.
- `class ContextGLAndroid : public ContextGL` — members aNativeWindow/display/surface/context/surfaceWidth/Height.
  - ctor(void* windowHandle) — ANativeWindow_acquire + size log; eglGetDisplay/eglInitialize (throw runtime_error with eglGetError on failure); `tryChooseConfig` ladder: 8888/d24 → 8888/d16 → 565/d16, then the same three with EGL_MIN_SWAP_INTERVAL 1; eglCreateWindowSurface; context at EGL_CONTEXT_CLIENT_VERSION 2 (GLES2 only); eglMakeCurrent; query surface dims; log EGL_MIN_SWAP_INTERVAL and set eglSwapInterval(0) (comment notes clamping makes FALSE "impossible"); resolve all extensions.
  - dtor — makeCurrent(NULL), destroy context+surface, eglTerminate, ANativeWindow_release.
  - `setCurrent()` — unconditional eglMakeCurrent (asserted).
  - `swapBuffers()` — eglSwapBuffers.
  - `getMainFramebufferId()` — 0. `isMainFramebufferRetina()` — false.
  - `pair<unsigned,unsigned> updateMainFramebuffer(w,h)` — cached surface dims.
  - `static bool tryChooseConfig(display, EGLConfig*, r, g, b, depthBits, swapInterval)` — attrib list RENDERABLE_TYPE=ES2 + sizes; returns first match.
- `static ContextGL* ContextGL::create(void*)`.

## Usage

DeviceGL on Android; windowHandle is an ANativeWindow*. The stub layer means all GfxCore GL code calls plain `glXxx` names identically on every platform.

## Gotchas

- Context is pinned to GLES 2.0 (client version 2) even on ES3 devices; ES3 features arrive only through the resolved EXT/OES entry points.
- Extension stubs dereference null pointers when an extension is absent — DeviceCapsGL flags are the only guard; calling un-gated APIs crashes.
- Config fallback may silently downgrade to RGB565+d16 on weak devices — color quality varies by hardware without upstream notification beyond logs.
- The swap-interval-1 retry configs in the ladder exist for devices that reject interval-0 surfaces.
- setCurrent() re-issues eglMakeCurrent every call (no current-context check like other platforms).
