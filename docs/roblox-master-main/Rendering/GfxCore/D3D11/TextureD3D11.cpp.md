# Rendering/GfxCore/D3D11/TextureD3D11.cpp

## Purpose

Implementation of `TextureD3D11` — the D3D11 backend for the abstract `Texture` interface. Creates 2D/cube/3D textures plus their shader resource views, implements upload/download (staging-texture readback), lazily creates renderbuffer views of texture mips (for framebuffer attachments), and mip generation.

## API

- `gTextureFormatD3D11[Format_Count]` — abstract formats to DXGI: R8_UNORM, R8G8_UNORM, B5G5R5A1_UNORM, R8G8B8A8_UNORM, R16G16_UNORM, R16G16B16A16_FLOAT, BC1/BC3 (+ duplicate BC3 entry), then five `DXGI_FORMAT_UNKNOWN` placeholders, D16_UNORM, D24_UNORM_S8_UINT.
- `gTextureUsageD3D11[Usage_Count]` — Static and Dynamic both become `D3D11_USAGE_DEFAULT` + SRV bind (comment: dynamic "doesn't support updateSubresource and map cannot lock just part of resource"); Renderbuffer adds `D3D11_BIND_RENDER_TARGET | D3D11_RESOURCE_MISC_GENERATE_MIPS`.
- `static ID3D11Resource* createTexture(ID3D11Device*, Type, Format, width, height, depth, mipLevels, const TextureUsageD3D11&)` — `CreateTexture2D` (ArraySize 6 + TEXTURECUBE misc for cubes) or `CreateTexture3D`; throws `RBX::runtime_error("Error creating texture: %x")`.
- `static ID3D11ShaderResourceView* createSRV(ID3D11Device*, resource, Type, Format, mipLevels)` — full-mip SRV (`MostDetailedMip = 0`, `MipLevels = mipLevels`); throws on failure.
- `TextureD3D11(Device*, Type, Format, width, height, depth, mipLevels, Usage)` — allocates resource + SRV immediately.
- `void upload(unsigned int index, unsigned int mip, const TextureRegion& region, const void* data, unsigned int size)` — `UpdateSubresource` at `D3D11CalcSubresource(mip, index, mipLevels)`; full-region uploads pass NULL box; row pitch = `getImageSize(format, region.width, 1)`, slice pitch only for 3D.
- `bool download(unsigned int index, unsigned int mip, void* data, unsigned int size)` — creates a one-subresource STAGING texture, `CopySubresourceRegion`, `Map(READ)`, repacks via `copyHelper`, unmaps/releases; returns true. Returns false unconditionally for Type_3D. Throws on staging creation failure.
- `static void copyHelper(target, targetRowPitch, targetSlicePitch, source, sourceRowPitch, sourceSlicePitch, width, height, depth, Format)` — memcpy fast path when pitches match, else per-row copy with compressed-format height in 4-row blocks.
- `bool supportsLocking() const` — always false.
- `LockResult lock(unsigned int, unsigned int, const TextureRegion&)` / `unlock(unsigned int, unsigned int)` — stubs returning empty/no-op.
- `shared_ptr<Renderbuffer> getRenderbuffer(unsigned int index, unsigned int mip)` — lazily constructs `RenderbufferD3D11(device, shared_from_this(), index, mip)` cached in a `(index,mip)`→weak map; asserts/returns null for non-2D/non-cube types.
- `static unsigned getInternalFormat(Texture::Format)` — raw table lookup (used by resolve paths).
- `void commitChanges()` — empty no-op.
- `void generateMipmaps()` — `GenerateMips(objectSRV)`; RBXASSERT usage is Renderbuffer.
- `~TextureD3D11()` — invalidates context texture cache, releases SRV and resource.

## Usage

Created via `Device::createTexture(...)` on a D3D11 device. Renderers bind it through `DeviceContextD3D11::bindTexture` (SRV path); framebuffer code obtains attachment views through `getRenderbuffer(index, mip)` → `FramebufferD3D11`. `download` backs screenshot/readback flows.

## Gotchas

- Dynamic textures silently degrade to DEFAULT usage — there is no real dynamic-map path in D3D11 here.
- `lock()/unlock()/supportsLocking()` are dead stubs: locking is unsupported; all writes must go through `upload()`.
- Five abstract formats map to `DXGI_FORMAT_UNKNOWN` in the table — creating such a texture produces an invalid format passed straight to D3D11 (no guard before CreateTexture).
- Cube textures share one SRV across all six faces; per-face upload uses array `index`.
- `download` is synchronous CPU-GPU sync (Map READ) — expensive.
- `getRenderbuffer` requires 2D or cube; 3D render-to-texture is explicitly not implemented (assert + null return).
- `generateMipmaps` only valid on Renderbuffer-usage textures (those carry GENERATE_MIPS misc flag).
