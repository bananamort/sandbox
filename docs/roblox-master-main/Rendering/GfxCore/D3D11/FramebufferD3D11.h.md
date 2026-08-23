# Rendering/GfxCore/D3D11/FramebufferD3D11.h

## Purpose

D3D11 render targets: `RenderbufferD3D11` holds an `ID3D11View` (RTV or DSV) plus the backing `ID3D11Resource` and optional owning texture; `FramebufferD3D11` is a list of color renderbuffers + optional depth.

## API

- `class RenderbufferD3D11 : public Renderbuffer`
  - ctors: `(device, shared_ptr<TextureD3D11> owner, cubeIndex, mipIndex)` — view into a texture slice/mip; `(device, format, w, h, samples, ID3D11Texture2D*)` — wraps externally-created texture (swapchain backbuffer); `(device, format, w, h, samples)` — allocates its own texture.
  - `ID3D11View* getObject()`; `ID3D11Resource* getResource()`; `const shared_ptr<TextureD3D11>& getOwner()`.
- `class FramebufferD3D11 : public Framebuffer`
  - ctor `(device, vector<shared_ptr<Renderbuffer>> color, depth)`; `download(void*, size)` override (CPU readback); getters `getColor()/getDepth()`.

## Usage

The main framebuffer wraps the DXGI swapchain backbuffer via the external-texture ctor; MRT framebuffers take the multi-color path; cubemap/texture targets come from TextureD3D11::getRenderbuffer.

## Gotchas

- The `object` is an untyped ID3D11View — callers must know whether it's an RTV or DSV from the attachment role.
- Keeping `owner` as strong ref means rendering into a texture keeps that texture alive; the standalone ctors leave owner null and must release the resource themselves in the dtor.
