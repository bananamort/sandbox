# Rendering/GfxCore/D3D9/TextureD3D9.cpp

## Purpose

Implementation of the D3D9 texture: creation per type (2D/cube/volume) with usage→pool/usage mapping, lock-based upload/download with pitch-aware copies, a SYSTEMMEM mirror for DYNAMIC textures (lock there, UpdateTexture to the DEFAULT object), renderbuffer views for render targets, mipmap regeneration via StretchRect, and device-lost recreation.

## API

Implements TextureD3D9 as declared in TextureD3D9.h.

- Tables:
  - `gTextureUsageD3D9[Usage_Count]` — Managed→(MANAGED, 0); Dynamic→(DEFAULT, D3DUSAGE_DYNAMIC); RenderTarget→(DEFAULT, D3DUSAGE_RENDERTARGET).
  - `gTextureFormatD3D9[Format_Count]` — L8, A8L8, A1R5G5B5, A8R8G8B8, G16R16, A16B16G16R16F, DXT1/3/5; several D3DFMT_UNKNOWN placeholders; depth formats D16, D24S8.
- File-local helpers: `createTexture(device9, type, ...)` dispatching to CreateTexture/CreateCubeTexture/CreateVolumeTexture (throws on failure); `fillRectOptional`/`fillBoxOptional` region converters; `boxFromRect`; `lockHelper`/`unlockHelper` per-type lock/unlock (failure logs + NULL pBits, does not throw); `copyHelper` row/slice-wise copy with compressed-format block rows ((h+3)/4) and a whole-block memcpy fast path when pitches match; `getSurfaceHelper` level/cube-face surface getter.
- Constructor — creates `object` from usage table; for Usage_Dynamic also creates a SYSTEMMEM `mirror` of identical dimensions.
- Destructor — invalidates context texture cache, releases object+mirror.
- Data paths:
  - `upload(index, mip, region, data, size)` — locks mirror-if-present else object (full-mip uploads pass NULL rect), copyHelper with computed source pitches, unlock, markAsDirty.
  - `download(index, mip, data, size)` — returns false immediately unless pool is MANAGED; else READONLY lock + copyHelper out. Full-mip only.
  - `supportsLocking()` → always true.
  - `lock/unlock` — same lockTarget rule as upload; unlock marks dirty.
- Render-target views: `getRenderbuffer(index, mip)` — weak_ptr cache keyed (index, mip); maps 2D→Owner_Tex2, cube face index→OwnerType enum value directly; 3D returns empty shared_ptr (not implemented).
- Deferred sync: `commitChanges()` / `flushChanges()` — complementary fast-flag gates (`FFlag::GraphicsTextureCommitChanges` on ⇒ commitChanges active; off ⇒ flushChanges active); both do `UpdateTexture(mirror, object)` when mirror dirty. Context's bindTexture calls flushChanges.
- `generateMipmaps()` — per face, StretchRect level n−1→n with linear filter down the chain (2D + cube).
- Lost/restore: DEFAULT-pool textures released on lost and recreated (empty) on restore; MANAGED survives.
- `markAsDirty()` — NVidia vendor special case: immediate UpdateTexture after every lock/unlock cycle (driver perf workaround, in-code comment); other vendors defer via mirrorDirty.
- Static `getInternalFormat(format)` — exposes the format table.

## Usage

Created by DeviceD3D9::createTexture. Streaming content goes to the mirror (dynamic) or straight into managed memory; the mirror reaches the GPU at bind time (flushChanges) or commitChanges depending on flag state. Render targets obtain surface views via getRenderbuffer for FramebufferD3D9 assembly.

## Gotchas

- Only Usage_Dynamic gets a mirror; Usage_RenderTarget locks go straight to the DEFAULT-pool object — locking a render target texture works here but is driver-dependent slow path.
- `download` hard-fails (returns false) for non-managed textures despite the mirror existing for dynamic ones — callers must check the return value.
- The two flush entry points are mutually exclusive by fast flag: if GraphicsTextureCommitChanges is enabled, bindTexture no longer flushes and frames must call commitChanges explicitly — forgetting this leaves dynamic textures never updated on non-NVidia vendors.
- NVidia path issues UpdateTexture inside every upload/lock-unlock — many small updates per frame multiply driver overhead by design choice.
- lockHelper swallows lock failures (NULL pBits returned, no exception) — callers writing through a failed lock would crash; upload/lock don't re-check pBits.
- getRenderbuffer for Type_3D asserts and returns an empty pointer — volume render targets are unsupported.
- onDeviceRestored recreates DEFAULT-pool objects without restoring contents — all dynamic/render-target pixels are undefined after device reset until re-uploaded.
