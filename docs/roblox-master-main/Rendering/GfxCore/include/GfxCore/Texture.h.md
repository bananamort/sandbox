# Rendering/GfxCore/include/GfxCore/Texture.h

## Purpose

Backend-neutral texture abstraction: `TextureRegion` (a 3D sub-rectangle for uploads) and `Texture` (2D/3D/cube resource with format, mips, usage) plus static format-geometry helpers. Covers both sampleable textures and render-target usage (`Usage_Renderbuffer`) from which `Renderbuffer`s can be extracted.

## API

- `struct TextureRegion { unsigned int x,y,z,width,height,depth; TextureRegion(); TextureRegion(x,y,z,w,h,d); TextureRegion(x,y,w,h); }` — the 4-arg ctor zeroes z/depth.
- `class Texture : public Resource`
  - `enum Type { Type_2D, Type_3D, Type_Cube, Type_Count }`.
  - `enum Usage { Usage_Static, Usage_Dynamic, Usage_Renderbuffer, Usage_Count }`.
  - `enum Format { Format_L8, Format_LA8, Format_RGB5A1, Format_RGBA8, Format_RG16, Format_RGBA16F, Format_BC1, Format_BC2, Format_BC3, Format_PVRTC_RGB2, Format_PVRTC_RGBA2, Format_PVRTC_RGB4, Format_PVRTC_RGBA4, Format_ETC1, Format_D16, Format_D24S8, Format_Count }` — spans desktop (BC/DXT), iOS (PVRTC), Android (ETC1), plus depth formats.
  - `struct LockResult { void* data; unsigned int rowPitch; unsigned int slicePitch; }`.
  - Data path: `virtual void upload(unsigned int index, unsigned int mip, const TextureRegion&, const void* data, unsigned int size) = 0`; `virtual bool download(unsigned int index, unsigned int mip, void* data, unsigned int size) = 0`; lockable path `supportsLocking()/lock(index, mip, region)/unlock(...)` returning row/slice pitch; `commitChanges()` flushes locked edits; `generateMipmaps()` builds the chain on-GPU.
  - `virtual shared_ptr<Renderbuffer> getRenderbuffer(unsigned int index, unsigned int mip) = 0` — exposes a texture face/mip as a render target attachment.
  - Getters: `getType/getFormat/getWidth/getHeight/getDepth/getMipLevels/getUsage`.
  - Static helpers: `isFormatCompressed(Format)`, `isFormatDepth(Format)`, `getFormatBits(Format)`, `getImageSize(format, w, h)` (single-mip byte size incl. compression block rounding), `getTextureSize(type, format, w, h, d, mips)` (full chain), `getMipSide(value, mip)`, `getMaxMipCount(w,h,d)`.

## Usage

Content pipeline uploads decoded or compressed images via `upload` (or map/unmap for dynamic textures like video/decal atlases); renderers create render targets with `Usage_Renderbuffer` and fetch attachments through `getRenderbuffer`. The static size helpers are used by asset loaders to walk mip chains in a blob without backend knowledge.

## Gotchas

- For cube textures `index` is the face, for arrays/volume it's slice — semantics differ by Type (UNKNOWN exact convention per call-site without checking callers).
- Compressed formats have no CPU-side representation here beyond blob offsets: `getImageSize` rounds to 4x4 blocks, so loaders must respect that when slicing.
- `lock()` is only legal when `supportsLocking()` returns true (backend/format dependent — e.g. D3D9 dynamic vs static pools).
- Depth formats (D16/D24S8) are sampled/downloadable only where the backend allows it.
