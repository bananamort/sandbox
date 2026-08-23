# Rendering/GfxCore/D3D9/TextureD3D9.h

## Purpose

Class declaration for the D3D9 texture implementation: `TextureD3D9` wraps `IDirect3DBaseTexture9` (2D/cube/volume), supports upload/download/lock, per-face/mip renderbuffer views for render targets, and a SYSTEMMEM "mirror" staging copy for `Usage_Dynamic` textures (lock the mirror, then `UpdateTexture` into the non-lockable DEFAULT-pool object).

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
- Members: `object` (the texture), `mirror` (SYSTEMMEM staging copy created only for `Usage_Dynamic`; uploads/locks go through it and reach `object` via `UpdateTexture` in flushChanges/commitChanges), `mirrorDirty`, and `RenderbufferMap renderbuffers` keyed by `std::pair<index, mip>` holding weak_ptr\<Renderbuffer\>.
- Private helpers: `markAsDirty()`, `copyData(index, mip, region, data, size, bool download, unsigned int lockFlags)` — shared implementation of upload/download via lock or mirror copy.

## Usage

Created by DeviceD3D9::createTexture. Dynamic-texture streaming locks the SYSTEMMEM mirror and reaches the GPU via UpdateTexture at bind time (`flushChanges`, called from DeviceContextD3D9::bindTexture) or at `commitChanges` depending on the `GraphicsTextureCommitChanges` flag; managed/static uploads go straight into the lockable object. Render targets obtain surface views via getRenderbuffer for FramebufferD3D9. Note `download` only works on MANAGED (static) textures — it returns false for everything else and never touches the mirror.

## Gotchas

- The class inherits `enable_shared_from_this` — instances must always be held by shared_ptr (weak_ptr cache in `renderbuffers` depends on it).
- `getRenderbuffer` caches weak references; a returned view dies if the texture drops its shared ownership.
- Mirror path is only synced when dirty (`mirrorDirty`/`markAsDirty`) — GPU visibility of dynamic-texture edits depends on flushChanges/commitChanges timing (and NVidia drivers get an immediate per-lock UpdateTexture; see TextureD3D9.cpp).
- Locking is only legal for pool/usage combinations D3D9 allows (see supportsLocking); otherwise lock fails and callers must use upload/download.
- Cube textures use `index` as face (0–5, matching RenderbufferD3D9::OwnerType ordering); volume textures use it as slice.
