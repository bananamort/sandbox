# Rendering/GfxCore/GL/TextureGL.cpp

## Purpose

Implementation of `TextureGL` — GL/GLES texture creation (immutable storage via glTexStorage when available, else per-mip glTexImage), uploads with UNPACK_ALIGNMENT handling and compressed-format branching, an optional PIXEL_UNPACK_BUFFER scratch ring for dynamic textures behind `GraphicsTextureCommitChanges`, desktop-only readback, renderbuffer views for FBO attachments, mip generation, and bind-time sampler parameter application.

## API

- Flag: `GraphicsTextureCommitChanges` (external) — enables the PBO-scratch deferred-upload path.
- Tables: `gTextureTargetGL[Type_Count]` → 2D/3D/CUBE_MAP; `gTextureFormatGL[Format_Count]` — 16 (internalFormat, dataFormat, dataType) triples covering R8/RG8/RGB5_A1/RGBA8/RG16/RGBA16F, DXT1/3/5, 4 PVRTC variants, ETC1, D16, D24S8 (compressed entries have 0 format/type); `getTextureFormatGL(format, ext3)` — pre-GLES3 substitutes LUMINANCE8/LUMINANCE_ALPHA8 paths for L8/LA8.
- Samplers: `gSamplerFilterMinGL[Filter_Count][2]` indexed [filter][hasMips]; `gSamplerFilterMagGL`; `gSamplerAddressGL` → REPEAT/CLAMP_TO_EDGE.
- `static bool doesFormatSupportPartialUpload(Format)` — false only for ETC1.
- `static unsigned createTexture(type, format, w, h, depth, mips, caps)` — TexStorage2D/3D when extTextureStorage; else per-face/per-mip glTexImage2D/3D (compressed: zero-filled glCompressedTexImage2D since NULL not allowed; GLES uses dataFormat as internalformat); sets GL_TEXTURE_MAX_LEVEL when partial mip chains supported else asserts full chain; unbinds.
- `static void uploadTexture(id, type, format, index, mip, region, entireRegion, data, caps)` — binds at unit 0, sets UNPACK_ALIGNMENT 1 for <32bpp uncompressed, then glTexSubImage3D / compressed sub-image (full-image CompressedTexImage2D fallback for ETC1 without storage ext) / glTexSubImage2D; unbinds. When `data` is an offset (PBO path) the bound PIXEL_UNPACK_BUFFER supplies the bytes.
- `TextureGL(device, ..., usage)` — validation gauntlet throws runtime_error on unsupported format (platform/caps variants), NPOT dims (unless Renderbuffer single-mip), 3D type, or dynamic+compressed under the flag; poisons context texture-stage-0 cache ("createTexture poisons the binding"); allocates; optionally creates scratch PBO sized to the whole texture (`GL_DYNAMIC_COPY`) when flag && Dynamic && ext3.
- `TextureGL(device, ..., unsigned int id)` — external adoption, external=true, no allocation.
- `~TextureGL()` — invalidates cache, deletes scratch buffer, deletes texture unless external.
- `void upload(index, mip, region, data, size)` — locking path (scratch): row-wise memcpy into mapped region then unlock; direct path: invalidate stage 0 + uploadTexture with entireRegion detection (x==0&&y==0&&full w/h).
- `bool download(index, mip, data, size)` — GLES: always false. Desktop: PACK_ALIGNMENT handling, glGetCompressedTexImage/glGetTexImage, returns true.
- `bool supportsLocking()` — flag ? (scratchId != 0) : false.
- `LockResult lock(index, mip, region)` — maps a range of the scratch ring (UNSYNCHRONIZED; wraps with INVALIDATE_BUFFER + commitChanges() when out of space); records pending Change; returns {data, rowPitch, slicePitch}. Empty result if no scratch.
- `void unlock(index, mip)` — glUnmapBuffer of scratch.
- `shared_ptr<Renderbuffer> getRenderbuffer(index, mip)` — asserts Usage_Renderbuffer && mip==0; lazily creates RenderbufferGL(device, shared_from_this(), faceTarget).
- `void commitChanges()` — no-op without flag/changes; replays each pending change sourcing from scratchOffset within the still-bound PIXEL_UNPACK_BUFFER; clears list.
- `void generateMipmaps()` — asserts non-dynamic; no-op ≤1 mip; glGenerateMipmap.
- `void bind(stage, state, TextureGL** cache)` — active texture stage, glBindTexture on object change, glTexParameteri filters/wraps (+desktop MAX_ANISOTROPY_EXT) on state change.
- `unsigned getTarget()`; `static unsigned getInternalFormat(Format)`.

## Usage

Created by DeviceGL::createTexture / adopted from VR surfaces. Bindings flow through DeviceContextGL::bindTexture → bind(). Framebuffers consume getRenderbuffer(index, mip). The commitChanges deferred model requires callers to invoke it before GPU reads the texture.

## Gotchas

- The PBO path passes `reinterpret_cast<void*>(change.scratchOffset)` as the data pointer — valid ONLY while the PIXEL_UNPACK_BUFFER stays bound (uploadTexture does that internally).
- ETC1 cannot do partial uploads and falls back to whole-image CompressedTexImage2D; dynamic+compressed is rejected outright under the flag.
- Every create/upload/download/generate/bind hijacks texture unit 0 — hence repeated invalidateCachedTextureStage(0) calls; skipping them corrupts the context cache.
- NPOT rejection exempts single-mip renderbuffers.
- download() is a hard no-op returning false on all GLES platforms.
- External-id constructor never validates format/dims against the actual GL object.
