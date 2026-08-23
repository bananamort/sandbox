# Rendering/GfxCore/D3D9/FramebufferD3D9.cpp

## Purpose

Implementation of D3D9 render targets: standalone surface creation (color render target vs depth-stencil chosen by format), texture-view renderbuffers, framebuffer assembly with size/format consistency checks, and system-memory readback (`grabCopy`/`download` with BGRA→RGBA swizzle).

## API

Implements RenderbufferD3D9 and FramebufferD3D9 as declared in FramebufferD3D9.h.

- File-local helpers:
  - `createRenderbuffer(device9, format, w, h, samples)` — depth formats → CreateDepthStencilSurface, else CreateRenderTarget; MSAA type = samples value when >1, else NONE; throws RBX::runtime_error on failure.
  - `getSurface(container, OwnerType, level)` — GetSurfaceLevel for Owner_Tex2 / GetCubeMapSurface for cube owners (enum value doubles as D3DCUBEMAP_FACES); asserts on other owner types.
- Renderbuffer constructors:
  - Texture view: grabs level-0 surface of the owned texture; keeps owner shared_ptr alive. Note base dims come from container width/height at mip-agnostic top level.
  - Adopting: stores a foreign surface (backbuffer), target=Owner_None, does NOT own it in the createRenderbuffer sense but…
  - Standalone: creates its own surface via createRenderbuffer.
  - Destructor releases `object` unconditionally — see Gotchas re: adopted surfaces.
  - `onDeviceLost` releases object; `onDeviceRestored` re-grabs from owner texture if possible, else recreates standalone.
  - `updateObject(value)` — asserts current object is NULL before adopting.
- Framebuffer constructors:
  - Main/backbuffer variant `(colorSurface, depthSurface)` — reads both surface descs (asserts equal size), sets width/height, wraps each surface in an adopting RenderbufferD3D9 (hardcoded Format_RGBA8 / Format_D24S8 labels).
  - Offscreen variant `(color, depth)` — starts at 0×0×0, takes width/height/samples from color[0]; throws when color count exceeds caps.maxDrawBuffers; asserts non-depth colors, depth format is depth, and all sizes/samples match (assert-only).
- `download(data, size)` — expects size == width*height*4; grabCopy → LockRect → row copy with per-pixel swap of bytes 0↔2 (BGRA→RGBA); unlock + release temp.
- `grabCopy()` — CreateOffscreenPlainSurface(SYSTEMMEM) + GetRenderTargetData(color[0]); throws on either failure; returns surface the caller must Release.

## Usage

Main framebuffer is assembled by DeviceD3D9::createMainFramebuffer over swap-chain surfaces; offscreen targets via DeviceD3D9::createFramebufferImpl from TextureD3D9::getRenderbuffer views and/or standalone renderbuffers. Context binds them by SetRenderTarget/SetDepthStencilSurface.

## Gotchas

- The destructor's unconditional `object->Release()` means the "adopting" constructor (used for backbuffers) hands ownership to the renderbuffer even though the surface belongs to the swap chain — releasing a swap-chain surface is refcount-safe (GetBackBuffer/AddRef semantics), but this relies on D3D COM refcounting rather than explicit ownership.
- `onDeviceRestored` fallback order matters: texture views are refreshed from the owner first; only when that fails is a brand-new empty standalone surface created — contents are NOT restored.
- Cube-face renderbuffers rely on OwnerType values 0–5 being bitwise-identical to D3DCUBEMAP_FACES — the cast `(D3DCUBEMAP_FACES)ot` has no translation layer.
- `download` assumes an 8-bit-per-channel A8R8G8B8/X8R8G8B8 target (assert-only) and always outputs RGBA by swapping R/B in place.
- grabCopy allocates a fresh SYSTEMMEM surface per call and transfers ownership to the caller; every caller must Release exactly once (copyFramebuffer asserts rc==0 after release).
- Mip-level renderbuffer views always use level 0 (`getSurface(owner, target, 0)`) regardless of which mip was requested at creation — getRenderbuffer(mip>0) caches a view but the constructor ignores its level.
- Offscreen FB samples/size mismatches across MRT attachments are assert-only; release builds proceed with inconsistent state.
