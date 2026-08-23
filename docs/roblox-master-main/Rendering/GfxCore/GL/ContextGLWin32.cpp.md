# Rendering/GfxCore/GL/ContextGLWin32.cpp

## Purpose

Windows WGL implementation of `ContextGL` — pixel-format selection, legacy context creation, optional debug-context recreation via WGL_ARB_create_context, GLEW bootstrap, vsync-off, and client-rect-based main framebuffer sizing.

## API

- `class ContextGLWin32 : public ContextGL` — members `HWND hwnd; HDC hdc; HGLRC hglrc;`.
  - ctor(void* windowHandle) — GetDC; PIXELFORMATDESCRIPTOR (RGBA, 32 color + 8 alpha, 24 depth + 8 stencil, double-buffered); ChoosePixelFormat/SetPixelFormat/wglCreateContext/wglMakeCurrent each throwing RBX::runtime_error with GetLastError. If FFlag DebugGraphicsGL: wglewContextInit() then when WGLEW_ARB_create_context, deletes the context and recreates it with WGL_CONTEXT_DEBUG_BIT_ARB attribs. Then glewInitRBX() and wglSwapIntervalEXT(0) (vsync off).
  - dtor — wglMakeCurrent(NULL,NULL) only if currently current; wglDeleteContext.
  - `void setCurrent()` — no-op if already current.
  - `void swapBuffers()` — SwapBuffers(hdc), asserts current.
  - `unsigned int getMainFramebufferId()` — always 0.
  - `bool isMainFramebufferRetina()` — always false.
  - `pair<unsigned,unsigned> updateMainFramebuffer(width, height)` — returns GetClientRect dimensions (inputs ignored).
- `static ContextGL* ContextGL::create(void*)` — factory returning ContextGLWin32.

## Usage

Instantiated by DeviceGL on Windows desktop builds. The debug-flag two-phase init exists because WGL extension functions are only available after a first current context.

## Gotchas

- Pixel format is fixed legacy-style: no sRGB, no MSAA in the PFD (MSAA render targets come from FBOs instead).
- updateMainFramebuffer ignores requested size — window manager owns the drawable size.
- Debug context path leaks nothing but does a full teardown/recreate; if ARB ext missing it silently keeps the legacy context.
- VSync is force-disabled at construction; there is no runtime toggle here.
