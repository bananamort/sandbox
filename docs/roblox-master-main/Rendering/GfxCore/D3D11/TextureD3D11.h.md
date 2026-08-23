# Rendering/GfxCore/D3D11/TextureD3D11.h

## Purpose

`TextureD3D11`: wraps an `ID3D11Resource` (Texture2D/3D/Cube) plus its default `ID3D11ShaderResourceView`, and lazily creates per-(slice,mip) `RenderbufferD3D11` views so a texture can double as render target.

## API

- `class TextureD3D11 : public Texture, public boost::enable_shared_from_this<TextureD3D11>`
  - ctor mirrors Texture's; overrides upload/download/lock/unlock/supportsLocking/getRenderbuffer/commitChanges/generateMipmaps.
  - `ID3D11ShaderResourceView* getSRV() const`; `ID3D11Resource* getObject() const`.
  - `static unsigned getInternalFormat(Texture::Format format)` — GfxCore Format → DXGI_FORMAT.
  - Private: `objectSRV`, `object`, `RenderbufferMap renderbuffers` — `std::map<std::pair<unsigned,unsigned>, weak_ptr<Renderbuffer>>` keyed by (index, mip), holding weak refs.

## Usage

Created via DeviceD3D11::createTexture; sampled through getSRV in bindTexture; used as RT by getRenderbuffer (e.g. rendering into a face of a cubemap shadow buffer).

## Gotchas

- enable_shared_from_this is required because RenderbufferD3D11 keeps a strong `owner` back-reference to the texture — the texture must always live in a shared_ptr.
- The renderbuffer map holds weak_ptrs: RT views are recreated on demand if the caller dropped them, and die automatically with the texture.
