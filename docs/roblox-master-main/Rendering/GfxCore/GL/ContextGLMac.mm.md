# Rendering/GfxCore/GL/ContextGLMac.mm

## Purpose

macOS NSOpenGL implementation of `ContextGL` — pixel format with main-display binding and no-software-fallback, optional GL 3.2 Core profile behind GraphicsGL3 (10.8+ only due to 10.7 driver shader-compiler crashes), vsync off, MPEngine enable, and deferred context-update handling for view resizes.

## API

- Flags: `UpdateContextOnFollowingFrame` (default false) — defers [context update] by one frame; `GraphicsGL3` (external).
- `static NSOpenGLPixelFormat* createPixelFormatWithApi(unsigned int api)` — attributes: ScreenMask=main display, NoRecovery, Accelerated, DoubleBuffer, ColorSize 24, AlphaSize 8, StencilSize 8, DepthSize **16**, plus OpenGLProfile when api != 0; nil-terminated.
- `class ContextGLNSGL : public ContextGL` — members `NSView* view; NSOpenGLPixelFormat* pixelFormat; NSOpenGLContext* context; bool updateRequired;`.
  - ctor(void* windowHandle) — retains the NSView; GraphicsGL3 && AppKit ≥ 10.8 → try ProfileVersion3_2Core, fall back to legacy format; else legacy directly; throws runtime_error on failures; creates context (no sharing), SwapInterval 0, setView, makeCurrentContext, CGLEnable(kCGLCEMPEngine) with FASTLOG on error, glewInitRBX().
  - dtor — clearCurrentContext if current, clearDrawable, release context/pixelFormat/view.
  - `setCurrent()` — makeCurrentContext on change.
  - `swapBuffers()` — flushBuffer.
  - `getMainFramebufferId()` — 0; `isMainFramebufferRetina()` — false.
  - `pair<unsigned,unsigned> updateMainFramebuffer(w, h)` — view bounds; triggers `[context update]` immediately or next-frame depending on flag when size changed.
- `static ContextGL* ContextGL::create(void*)` — factory.

## Usage

Selected by DeviceGL on macOS. windowHandle must be an NSView*. The one-frame-deferred update mode works around resize flicker/crash behaviors in specific macOS versions.

## Gotchas

- Depth buffer is only 16 bits here vs 24 on Win32 — deliberate compatibility tradeoff.
- GL3 core profile is silently skipped pre-10.8 even when the flag is set.
- Retina is unconditionally reported false — no backing-scale-factor handling in this build.
- Objective-C retain/release is manual (no ARC): ownership pairing matters if refactored.
- kCGLCEMPEngine failure is logged but non-fatal.
