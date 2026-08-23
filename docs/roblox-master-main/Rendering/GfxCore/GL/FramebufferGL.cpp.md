# Rendering/GfxCore/GL/FramebufferGL.cpp

## Purpose

Implementation of `RenderbufferGL` and `FramebufferGL` — GL renderbuffer allocation (with MSAA), FBO assembly from texture or renderbuffer attachments with completeness validation, synchronous RGBA8 readback with row flipping, and dimension updates for the resizable default framebuffer.

## API

- `RenderbufferGL(Device*, const shared_ptr<TextureGL>& container, unsigned int target)` — texture view; no GL object allocated (bufferId 0); dims/samples(1) inherited from the texture.
- `RenderbufferGL(Device*, Format, width, height, samples)` — asserts samples>0; throws if samples > caps.maxSamples; glGenRenderbuffers + (Multisample|plain) glRenderbufferStorage with `TextureGL::getInternalFormat(format)`.
- `~RenderbufferGL()` — deletes bufferId when nonzero.
- `FramebufferGL(Device*, unsigned int id)` — wraps default/main framebuffer with base dims (0,0) and samples 1.
- `FramebufferGL(Device*, color, depth)` — throws when color empty or > maxDrawBuffers; glGenFramebuffers, attach each color as texture2D (getTarget face) or renderbuffer at COLOR_ATTACHMENT0+i; geometry from color[0] (asserts consistency for others); depth attached to BOTH GL_DEPTH_ATTACHMENT and GL_STENCIL_ATTACHMENT and asserted to be a standalone depth-format renderbuffer (getTextureId()==0); `glCheckFramebufferStatus` must be COMPLETE else delete+throw "Unsupported framebuffer configuration: error %x"; unbinds.
- `~FramebufferGL()` — deletes FBO when id nonzero (id 0 = default never deleted).
- `void download(void* data, unsigned int size)` — asserts size == w*h*4; saves binding, binds own FBO, desktop sets glReadBuffer(BACK for id 0 else COLOR_ATTACHMENT0), glReadPixels RGBA/UNSIGNED_BYTE, restores binding, then flips rows vertically in place (bottom-up → top-down).
- `void updateDimensions(unsigned int width, unsigned int height)` — asserts attachment-free (default framebuffer only).

## Usage

FBOs created through Device::createFramebuffer paths; the main framebuffer instance lives inside DeviceGL and gets updateDimensions on resize/validate. DeviceContextGL::bind/clear/copy/resolve/discard all operate via getId().

## Gotchas

- Depth attachments must be real renderbuffers, never texture views (asserted) — no depth-texture shadow mapping support here.
- Depth buffer is bound to both DEPTH and STENCIL attachment points unconditionally — assumes packed D24S8-style formats.
- download() always flips rows: GL's bottom-up origin is normalized here, so callers get top-down pixels like D3D.
- Framebuffer completeness failure leaves attachments alive but deletes the FBO object before throwing.
- The main-framebuffer constructor hardcodes samples=1 regardless of actual window MSAA.
