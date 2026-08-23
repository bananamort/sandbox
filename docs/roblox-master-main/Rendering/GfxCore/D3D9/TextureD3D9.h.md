# Rendering/GfxCore/D3D9/TextureD3D9.h

## Purpose

Class declaration for the D3D9 texture implementation: `TextureD3D9` wraps `IDirect3DBaseTexture9` (2D/cube/volume), supports upload/download/lock, per-face/mip renderbuffer views for render targets, and a "mirror" copy used when reading back from a non-lockable (render-target) texture.

## API

- `class TextureD3D9 : public Texture, public boost::enable_shared_from_this<TextureD3D9>`
  - `TextureD3D9(Device*, Type type, Format format, unsigned int width, height, depth, mipLevels, Usage usage)` / destructor.
  - Data in: `void upload(unsigned int index, unsigned int mip, const TextureRegion& region, const void* data, unsigned int size)`.
  - Data out: `bool download(unsigned int index, unsigned int mip, void* data, unsigned int size)`.
  - CPU access: `bool supportsLocking() const`; `LockResult lock(unsigned int index, unsigned int mip, const TextureRegion& region)`; `void unlock(unsigned int index, unsigned int mip)`.
  - Render-target views: `shared_ptr<Renderbuffer> getRenderbuffer(unsigned int index, unsigned int mip)` — creates/caches per (face/slice, mip).
  - Deferred updates: `void commitChanges()`; mips: `void generateMipmaps()`.
  - Device lost: `onDeviceLost()` / `onDeviceRestored()`.
  - Manual flush: `void flushChanges()`.
  - `IDirect3DBaseTexture9* getObject()`; static `unsigned int getInternalFormat(Format format)` → D3DFORMAT value.
- Members: `object` (the texture), `mirror` (secondary `IDirect3DBaseTexture9*` used for readback of non-lockable targets), `mirrorDirty`, and `RenderbufferMap renderbuffers` keyed by `std::pair<index, mip>` holding weak_ptr\<Renderbuffer\>.
- Private helpers: `markAsDirty()`, `copyData(index, mip, region, data, size, bool download, unsigned int lockFlags)` — shared implementation of upload/download via lock or mirror copy.

## Usage

Created by DeviceD3D9::createTexture. Streaming updates go through upload/lock then commitChanges; render targets obtain surface views via getRenderbuffer for FramebufferD3D9; download on a render target copies through the mirror because D3D9 render targets are not directly lockable.

## Gotchas

- The class inherits `enable_shared_from_this` — instances must always be held by shared_ptr (weak_ptr cache in `renderbuffers` depends on it).
- `getRenderbuffer` caches weak references; a returned view dies if the texture drops its shared ownership.
- Mirror path is only synced when dirty (`mirrorDirty`/`markAsDirty`) — downloading without a prior render may read stale mirror data depending on flush timing.
- Locking is only legal for pool/usage combinations D3D9 allows (see supportsLocking); otherwise lock fails and callers must use upload/download.
- Cube textures use `index` as face (0–5, matching RenderbufferD3D9::OwnerType ordering); volume textures use it as slice.
