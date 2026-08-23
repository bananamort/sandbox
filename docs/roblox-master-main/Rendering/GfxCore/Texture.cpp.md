# Rendering/GfxCore/Texture.cpp

## Purpose

Format-geometry tables and static helpers for `Texture`: the `gTextureFormats` description table (bits-per-pixel, compressed, depth), region ctors, format predicates, single-mip/full-chain byte-size math with block-compression and PVRTC special cases, mip helpers, and GPU-memory profiling. Also declares FastFlag `FFlag::GraphicsTextureCommitChanges` (default false).

## API

- `static const FormatDescription gTextureFormats[Format_Count]` — in enum order: L8=8bpp, LA8=16, RGB5A1=16, RGBA8=32, RG16=32, RGBA16F=64, BC1=4bpp compressed, BC2/BC3=8bpp compressed, PVRTC_2bpp×2=2bpp compressed, PVRTC_4bpp×2=4bpp compressed, ETC1=4bpp compressed, D16=16 depth, D24S8=32 depth.
- `TextureRegion()` — all-zero; `(x,y,z,w,h,d)`; `(x,y,w,h)` sets z=0, depth=1.
- `Texture::Texture(...)` — asserts positive dims, `mipLevels <= getMaxMipCount`, `depth==1` unless Type_3D; adds to profiler counter `memory/gpu/texture` (full chain size) when usage != Renderbuffer; dtor mirrors.
- Static: `isFormatCompressed/isFormatDepth/getFormatBits` (table lookups); `getImageSize(format,w,h)`:
  - BC1/BC2/BC3/ETC1: ceil(w/4)*ceil(h/4)*(bpp*16/8) — 4x4 blocks.
  - PVRTC 2bpp: `(max(width,16u) * max(height,8u) * 2 + 7)/8`; 4bpp: `(max(width,8u) * max(height,8u) * 4 + 7)/8` — PVRTC minimum-dimension rules.
  - else `w*h*(bpp/8)` with assert !compressed.
- `getTextureSize(type,format,w,h,d,mips)` — sums per-mip getImageSize*depth-scalars, ×6 for cubes.
- `getMipSide(value,mip)` — `value >> mip`, clamped to ≥1.
- `getMaxMipCount(w,h,d)` — halving loop until all zero.

## Usage

Asset decoders and texture-streaming code use these helpers to slice `.texture`/DDS-style blobs without touching backends; backends reuse them for allocation sizing; profiler dashboards read the counters.

## Gotchas

- `getMipSide(depth, mip)` is also used for 3D texture depth scaling — depth mips shrink like sides.
- RGB5A1 counts as 16bpp here but note no RGB8 exists in this enum (desktop RGB textures are padded to RGBA8 upstream).
- `GraphicsTextureCommitChanges` flag gates something in backend commit paths (UNKNOWN which behavior exactly — referenced by backends; check TextureD3D9/GL usage).
- Cube size multiplies the *whole chain* by 6 (each face has all mips).
