# Rendering/GfxCore/GL/HeadersGL.h

## Purpose

Single GL include point for all GfxCore GL backend TUs. Selects the platform header set (iOS OpenGLES ES2, Android GLES2, desktop GLEW) and back-fills missing extension declarations so one source line works across GLES2 phones and desktop GL.

## API

- Platform selection: `RBX_PLATFORM_IOS` → `<OpenGLES/ES2/gl.h>+glext.h` (+EAGL under `__OBJC__`), defines `GLES`; `__ANDROID__` → `<GLES2/gl2.h>+gl2ext.h`, defines `GLES`, plus `GLsync`/`GLuint64` typedefs; otherwise `<GL/glew.h>` and declares `void glewInitRBX()` (defined in the glew/ subtree).
- Under `GLES`: `#define glClearDepth glClearDepthf`; extern declarations for OES_vertex_array_object (`glBindVertexArray/glDeleteVertexArrays/glGenVertexArrays`), OES_mapbuffer (`glMapBuffer/glUnmapBuffer` + GL_WRITE_ONLY), EXT_map_buffer_range (`glMapBufferRange` + 6 access-bit defines), EXT_texture_storage (`glTexStorage2D`), OES_packed_depth_stencil constants, OES_rgb8_rgba8 (GL_RGBA8), half float constants, OES_texture_3D (`glTexImage3D/glTexSubImage3D/glTexStorage3D`), GLES3 format enums (GL_RED/GL_RG/GL_R8/GL_RG8/GL_RG16), buffer enums (GL_DYNAMIC_COPY/GL_PIXEL_UNPACK_BUFFER), sync objects (`glFenceSync/glDeleteSync/glClientWaitSync/glWaitSync` + enums), MSAA (`glBlitFramebuffer/glRenderbufferStorageMultisample` + READ/DRAW_FRAMEBUFFER + MAX_SAMPLES), `glInvalidateFramebuffer`.
- Format-extension blocks for all platforms: EXT_texture_compression_s3tc (DXT1/3/5), IMG_texture_compression_pvrtc (4 variants), GL_ETC1_RGB8_OES, APPLE_texture_max_level / GLES3 GL_TEXTURE_MAX_LEVEL.

## Usage

Included by every file under GL/ (Device*, Shader/Texture/Geometry/Framebuffer GL, Context*). Desktop builds additionally require a call to `glewInitRBX()` once before any GL entry point is used.

## Gotchas

- The GLES extension functions are declared but never defined in this header — they are resolved at runtime by DeviceContextGL.cpp via eglGetProcAddress-style lookup; linking against these names directly would fail on iOS/Android.
- Enum values are hardcoded hex mirrors of the extension specs — safe only because they match upstream; do not "fix" them to different aliases.
- On Android the header manually typedefs GLsync/GLuint64, assuming an ES2-era system header lacking them.
- Desktop path depends on the vendored glew/ directory (excluded from docs scope); GLEW must be initialized before use.
