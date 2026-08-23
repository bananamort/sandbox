# Rendering/GfxCore/D3D9/FramebufferD3D9.h

## Purpose

Class declarations for D3D9 render-target plumbing: `RenderbufferD3D9` (an `IDirect3DSurface9` that either wraps a face/mip of an owned `TextureD3D9` or stands alone) and `FramebufferD3D9` (a color+depth surface set, including the backbuffer main framebuffer, with readback support).

## API

- `class RenderbufferD3D9 : public Renderbuffer`
  - `enum OwnerType { Owner_CubePosX (=0), Owner_CubeNegX, Owner_CubePosY, Owner_CubeNegY, Owner_CubePosZ, Owner_CubeNegZ, Owner_Tex2, Owner_None }` — identifies which texture surface a renderbuffer views; comments mandate the cube values stay 0–5.
  - Constructors:
    - `RenderbufferD3D9(Device*, shared_ptr<TextureD3D9> owner, OwnerType target)` — view into an owned texture.
    - `RenderbufferD3D9(Device*, Texture::Format format, unsigned int width, height, samples, IDirect3DSurface9* object)` — adopt existing surface (backbuffer).
    - `RenderbufferD3D9(Device*, Texture::Format format, unsigned int width, height, samples)` — create own surface.
  - `onDeviceLost()` / `onDeviceRestored()`; `void updateObject(IDirect3DSurface9* value)`; `IDirect3DSurface9* getObject()`.
  - Members: object (owned or borrowed depending on constructor), `owner` shared_ptr keeping the source texture alive, `target`.
- `class FramebufferD3D9 : public Framebuffer`
  - Constructors:
    - `FramebufferD3D9(Device*, IDirect3DSurface9* colorSurface, IDirect3DSurface9* depthSurface)` — main/backbuffer variant.
    - `FramebufferD3D9(Device*, const std::vector<shared_ptr<Renderbuffer>>& color, const shared_ptr<Renderbuffer>& depth)` — offscreen MRT variant.
  - `void download(void* data, unsigned int size)` — read pixels of the bound color surface.
  - `IDirect3DSurface9* grabCopy()` — snapshot of the current backbuffer as a new surface (caller frees).
  - Accessors: `getColor()`, `getDepth()`.

## Usage

Offscreen targets are built from RenderbufferD3D9 views created by TextureD3D9::getRenderbuffer; DeviceContextD3D9::bindFramebuffer sets them via SetRenderTarget/SetDepthStencilSurface. The main framebuffer is constructed directly over swap-chain surfaces. Readback paths (screenshot, VR) use download/grabCopy.

## Gotchas

- The first six `OwnerType` values double as cube-face indices for TextureD3D9 surface lookup — reordering breaks every cube render target.
- A RenderbufferD3D9 created by adoption does not own its surface; one created standalone must release it in its destructor (ownership differs per constructor).
- D3D9 has no framebuffer "object": binding is just setting up to 4 render targets + depth stencil, so multi-render-target support is capped at 4 and resolveFramebuffer is a no-op/MSAA handled implicitly.
- `grabCopy` allocates a system-memory surface each call — repeated use leaks unless the caller releases it.
