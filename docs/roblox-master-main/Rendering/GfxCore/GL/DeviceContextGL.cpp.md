# Rendering/GfxCore/GL/DeviceContextGL.cpp

## Purpose

Implementation of `DeviceContextGL` — the OpenGL/GLES immediate-mode DeviceContext backend. Direct state-machine translation of cached renderer states into glEnable/glBlendFunc-style calls, framebuffer bind/clear/copy/resolve/discard, texture binding delegation to TextureGL, program binding with a shared global-constants buffer, and per-platform debug markers.

## API

- Flag: `GraphicsGLUseDiscard` (default false) — gates glInvalidateFramebuffer usage.
- Tables: `gCullModeGL[Cull_Count]` → GL_NONE/GL_BACK/GL_FRONT; `gBlendFactorsGL[Factor_Count]` → 7 GL blend enums; `gDepthFuncGL[Function_Count]` → ALWAYS/LESS/LEQUAL.
- `DeviceContextGL(DeviceGL* dev)` / `~DeviceContextGL()` — initializes caches; textures cache zeroed.
- `void clearStates()` — binds FBO 0, glUseProgram(0), clears texture + state caches (poisoned enum values), enables GL_PROGRAM_POINT_SIZE once (desktop only).
- `void invalidateCachedProgram()` / `invalidateCachedTexture(Texture*)` / `invalidateCachedTextureStage(unsigned int)` — cache maintenance hooks for resource destruction.
- `void defineGlobalConstants(size_t dataSize)` — resizes the CPU shadow (`globalData`), asserted once.
- `void setDefaultAnisotropy(unsigned int)`.
- `void updateGlobalConstants(const void* data, size_t dataSize)` — memcpy into shadow + `globalDataVersion++` (version drives lazy uniform re-upload in programs).
- `void bindFramebuffer(Framebuffer*)` — glBindFramebuffer + full viewport; desktop: glDrawBuffer(GL_BACK) for id 0 else glDrawBuffers over COLOR_ATTACHMENT0+i (≤16).
- `void clearFramebuffer(unsigned int mask, const float color[4], float depth, unsigned int stencil)` — forces blend-off/color-all, depth always+write, stencil mask ~0 before glClear (writes must be enabled for GL clears).
- `void copyFramebuffer(Framebuffer*, Texture*)` — saves FBO binding, binds source, glCopyTexSubImage2D into texture at level 0 from COLOR_ATTACHMENT0, restores FBO.
- `void resolveFramebuffer(Framebuffer* msaaBuffer, Framebuffer*, unsigned int mask)` — READ/DRAW binding pair + glBlitFramebuffer (color LINEAR, depth/stencil NEAREST), restores binding.
- `void discardFramebuffer(Framebuffer*, unsigned int mask)` — no-op unless ext3 && GraphicsGLUseDiscard; then glInvalidateFramebuffer on color/depth/stencil attachments.
- `void bindProgram(ShaderProgram*)` — `ShaderProgramGL::bind(&globalData[0], globalDataVersion, &cachedProgram)`.
- `setWorldTransforms4x3(const float*, size_t)` / `setConstant(int handle, const float*, size_t)` — forwarded to cached program.
- `void bindTexture(unsigned int stage, Texture*, const SamplerState&)` — anisotropy-0 default substitution, then `TextureGL::bind(stage, realState, &cachedTextures[stage])`.
- `setRasterizerState/setBlendState/setDepthState` — direct GL calls; depth bias via glPolygonOffset(slopeBias=bias/32, bias); stencil UpdateZFail uses DECR_WRAP front / INCR_WRAP back (note reversed vs D3D11's INCR/DECR naming); IsNotZero = NOTEQUAL 0.
- `void drawImpl(Geometry*, Primitive, offset, count, indexRangeBegin, indexRangeEnd)` — forwards to `GeometryGL::draw(primitive, offset, count)` (index range unused).
- Markers: iOS EXT_debug_marker (glPushGroupMarkerEXT/glPopGroupMarkerEXT/glInsertEventMarkerEXT); Android no-op; desktop GL4.3 glPushDebugGroup/glPopDebugGroup/glDebugMessageInsert guarded by function-pointer presence.

## Usage

Owned by DeviceGL; obtained each frame from `beginFrame()`. All higher-layer draws flow through this class via the abstract DeviceContext interface. Global constants live in one CPU shadow whose version counter lets programs detect stale uploads.

## Gotchas

- Clear operations mutate blend/depth/stencil state through the same setters — a clear changes your cached state (by design, but callers should re-set states after clearing if they relied on prior state).
- `clearStates()` rebinds FBO 0 and program 0 — called by beginFrame every frame.
- Stencil_UpdateZFail semantics are mirrored relative to D3D11 (front=DECR_WRAP, back=INCR_WRAP here).
- copyFramebuffer requires exact size match and 2D type (asserts); it also invalidates texture stage 0 because it hijacks that unit.
- Debug markers on desktop silently require GL 4.3 core functions; ARB extension variants are deliberately not used.
- discardFramebuffer is effectively dead code unless both ext3 and the flag are on.
- `setWorldTransforms4x3`/`setConstant` dereference `cachedProgram` without a null check (unlike the D3D11 context, there is not even an assert) — calling them before any `bindProgram`, or after `clearStates()`/`invalidateCachedProgram()` zeroed the cache, is a null-pointer dereference; correctness depends on the renderer always binding a program first.
