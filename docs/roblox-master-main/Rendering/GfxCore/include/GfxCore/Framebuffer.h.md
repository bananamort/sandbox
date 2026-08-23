# Rendering/GfxCore/include/GfxCore/Framebuffer.h

## Purpose

Declares the render-target abstraction: `Renderbuffer` (a color/depth attachment with dimensions and MSAA sample count) and `Framebuffer` (the bindable target composed of one or more renderbuffers). Backends subclass both (e.g. `RenderbufferD3D11`, `FramebufferGL`) to hold the native handle.

## API

- `class Renderbuffer : public Resource`
  - ctor `Renderbuffer(Device*, Texture::Format format, unsigned int width, unsigned int height, unsigned int samples)`; stores format/width/height/samples.
  - getters: `getFormat()`, `getWidth()`, `getHeight()`, `getSamples()`.
- `class Framebuffer : public Resource`
  - ctor `Framebuffer(Device*, unsigned int width, unsigned int height, unsigned int samples)`.
  - `virtual void download(void* data, unsigned int size) = 0` — synchronous GPU→CPU readback of the framebuffer contents.
  - getters: `getWidth()/getHeight()/getSamples()`.

## Usage

Created only through `Device::createFramebuffer(...)`/`createRenderbuffer(...)`; bound for drawing via `DeviceContext::bindFramebuffer`; cleared/copied/resolved/discarded via the corresponding DeviceContext calls. VR eye targets are handed out as plain `Framebuffer*` by `DeviceVR::getEyeFramebuffer(int eye)`.

## Gotchas

- A Renderbuffer is *not* a Texture here: it cannot be sampled. To consume a rendered image as a texture, use `DeviceContext::copyFramebuffer(Framebuffer*, Texture*)`.
- MSAA is expressed purely via `samples` on the attachments; resolve happens explicitly (`resolveFramebuffer`), which GL implements via blit and D3D11 via ResolveSubresource.
- Composition of attachments happens in the backend subclass; this header carries no attachment list.
