# Rendering/GfxCore/GL/TextureGL.h

## Purpose

Class declaration for `TextureGL` — the OpenGL/GLES Texture backend. Owns the GL texture object, a PBO-style scratch buffer for deferred uploads (enabled by `GraphicsTextureCommitChanges` + Usage_Dynamic + caps.ext3, i.e. GLES3 *or* desktop GL3), per-stage sampler caching, and lazy renderbuffer views for render-to-texture.

## API

- `TextureGL(Device*, Type, Format, w, h, depth, mipLevels, Usage)` — creates its own GL texture.
- `TextureGL(Device*, ..., unsigned int id)` — adopts an **external** GL texture id (e.g. swapchain/VR-provided).
- `~TextureGL()`.
- Overrides: `upload(index, mip, region, data, size)`, `bool download(index, mip, data, size)`, `supportsLocking()`, `lock/unlock(index, mip, region)`, `shared_ptr<Renderbuffer> getRenderbuffer(index, mip)`, `commitChanges()`, `generateMipmaps()`.
- GL-specific: `void bind(unsigned int stage, const SamplerState&, TextureGL** cache)` — binds texture + applies sampler state with per-object cache slot; `unsigned int getId()`; `unsigned int getTarget()` (GL_TEXTURE_2D/CUBE/3D); `static unsigned int getInternalFormat(Format)`.
- Private: nested `struct Change { index; mip; TextureRegion region; unsigned scratchOffset; }`; members `id; SamplerState cachedState; bool external; unsigned scratchId/scratchOffset/scratchSize; std::vector<Change> pendingChanges; RenderBufferMap renderBuffers` (`(index,mip)`→weak Renderbuffer).

## Usage

Created by DeviceGL::createTexture or wrapped around external ids. DeviceContextGL::bindTexture delegates to bind(); FramebufferGL pulls attachments via getRenderbuffer. Uploads on ext3 dynamic textures behind `GraphicsTextureCommitChanges` accumulate into pendingChanges flushed at commitChanges (desktop GL3 included, not just GLES).

## Gotchas

- External textures (external=true) skip destruction of the GL object and typically skip re-upload paths.
- The scratch-buffer machinery means upload() may not hit the GPU immediately — commitChanges timing matters on GLES.
