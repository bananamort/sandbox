# Rendering/GfxCore/GL/GeometryGL.cpp

## Purpose

Implementation of the GL geometry stack: fixed attribute-slot mapping and shader attribute names, GL buffer object creation/lock/upload with three capability tiers (MapBufferRange / MapBuffer / CPU-shadow fallback), VAO-based or manual per-draw attribute binding, and draw dispatch.

## API

- Tables: `gBufferUsageGL[Usage_Count]` → STATIC_DRAW/DYNAMIC_DRAW; `gBufferLockGL[Lock_Count]` → MAP_WRITE_BIT / MAP_WRITE_BIT|MAP_INVALIDATE_BUFFER_BIT; `gVertexFormatGL[Format_Count]` → (count, type, normalized) for 8 abstract formats; `gGeometryPrimitiveGL[Primitive_Count]` → TRIANGLES/LINES/POINTS/TRIANGLE_STRIP.
- `static unsigned getVertexAttributeGL(Semantic, index)` — Position→0, Normal→1, Color→2+index (<2), Texture→4+index (<8); asserts otherwise.
- `static const char* VertexLayoutGL::getShaderAttributeName(unsigned id)` — "vertex","normal","colour","secondary_colour","uv0".."uv7", NULL beyond.
- `VertexLayoutGL` — trivial ctor/dtor over base (no GPU state).
- `template<Base> void create()` — glGenBuffers + glBufferData(size, NULL, usage).
- `template<Base> void* lock(LockMode)` — extMapBuffer: bind + glMapBufferRange (or glMapBuffer WRITE_ONLY, with orphaning glBufferData(NULL) for Lock_Discard when no range ext); else `new char[size]` shadow.
- `template<Base> void unlock()` — glUnmapBuffer, or glBufferSubData full-size + delete shadow.
- `template<Base> void upload(offset, data, size)` — glBufferSubData partial (asserts not locked).
- `VertexBufferGL(...)` — creates on GL_ARRAY_BUFFER. `IndexBufferGL(...)` — throws on elementSize not 2/4 and on 4 without caps.supportsIndex32; binds GL_ELEMENT_ARRAY_BUFFER.
- `GeometryGL(...)` — if extVertexArrayObject: gen+bind VAO, record bindings via bindArrays(), unbind; caches indexElementSize.
- `~GeometryGL()` — deletes VAO if any.
- `void draw(Primitive, offset, count)` — bind VAO or bindArrays(); glDrawElements (type from cached indexElementSize; offset*elementSize as pointer) or glDrawArrays; unbind afterwards ("to prevent draw call interference").
- `unsigned int bindArrays()` — per element: slot from semantic map, stride=elementSize, pointer offset includes `stride * baseVertexIndex`; glEnableVertexAttribArray + glVertexAttribPointer; binds index buffer; returns enabled mask.
- `void unbindArrays(mask)` — glDisableVertexAttribArray per set bit.

## Usage

Created through Device factories; driven solely by DeviceContextGL::drawImpl → draw(). Works identically on desktop GL and GLES2 phones thanks to the three-tier lock path and optional VAOs.

## Gotchas

- Attribute slots are hardwired (position 0, normal 1, colors 2–3, uvs 4–11) and must match ShaderGL's name table exactly ("colour"/"secondary_colour" British spelling included).
- Without VAO support every draw re-specifies all attributes and disables them after — measurable overhead on old GLES2 devices.
- baseVertexIndex is emulated by offsetting the attribute pointers, not a GL draw parameter.
- The no-mapbuffer fallback allocates a full-buffer shadow even for small locks; unlock always uploads the whole buffer.
- Draw unbinds the VAO/buffers every call — deliberate defensive choice, not an oversight.
