# Rendering/GfxCore/GL/FramebufferGL.h

## Purpose

Class declarations for the GL render-target layer: `RenderbufferGL` (either a texture-backed attachment view or a true GL renderbuffer for MSAA/depth) and `FramebufferGL` (FBO owner; also wraps the window-system default framebuffer with id 0).

## API

- `class RenderbufferGL : public Renderbuffer`
  - `RenderbufferGL(Device*, const shared_ptr<TextureGL>& owner, unsigned int target)` — texture-backed; target is TEXTURE_2D or a CUBE_MAP_POSITIVE_X face.
  - `RenderbufferGL(Device*, Texture::Format, width, height, samples)` — standalone (glRenderbufferStorageMultisample when samples>1).
  - `~RenderbufferGL()`.
  - `unsigned int getTextureId()` — owner id or 0; `unsigned int getTarget()`; `unsigned int getBufferId()`.
  - Members: `unsigned int target; unsigned int bufferId; shared_ptr<TextureGL> owner;`.
- `class FramebufferGL : public Framebuffer`
  - `FramebufferGL(Device*, unsigned int id)` — main/default-framebuffer wrapper (no attachments).
  - `FramebufferGL(Device*, const std::vector<shared_ptr<Renderbuffer>>& color, const shared_ptr<Renderbuffer>& depth)` — creates + validates an FBO.
  - `~FramebufferGL()`.
  - `void download(void* data, unsigned int size)` — readback.
  - `void updateDimensions(unsigned int width, unsigned int height)` — used by DeviceGL when the OS resizes the drawable.
  - `unsigned int getId()` — FBO id (0 = default); `unsigned int getDrawBuffers()` = color.size().
  - Members: `id; color; depth`.

## Usage

Created via the abstract Device factories and directly by DeviceGL for the main framebuffer. DeviceContextGL consumes getId()/getDrawBuffers(); TextureGL::getRenderbuffer produces the texture-backed variant.

## Gotchas

- getTextureId() returns 0 for standalone renderbuffers — only meaningful on the owner variant.
- The id-based constructor deliberately stores no color/depth, so getDrawBuffers()==0 and downloads rely purely on the default framebuffer semantics.
