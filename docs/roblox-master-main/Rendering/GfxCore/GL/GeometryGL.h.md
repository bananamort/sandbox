# Rendering/GfxCore/GL/GeometryGL.h

## Purpose

Class declarations for the GL geometry stack: `VertexLayoutGL` (fixed attribute-name table), templated `GeometryBufferGL<Base>` over GL buffer objects, `VertexBufferGL`/`IndexBufferGL` specializations, and `GeometryGL` (VAO-or-manual attribute binding + draw).

## API

- `class VertexLayoutGL : public VertexLayout`
  - `static const char* getShaderAttributeName(unsigned int id)` — canonical attribute names used for source scraping and glBindAttribLocation.
  - `VertexLayoutGL(Device*, const std::vector<Element>&)` / `~`.
- `template<typename Base> class GeometryBufferGL : public Base`
  - `GeometryBufferGL(Device*, size_t elementSize, size_t elementCount, GeometryBuffer::Usage usage, unsigned int target)`.
  - `void* lock(GeometryBuffer::LockMode mode)` / `void unlock()` / `void upload(unsigned int offset, const void* data, unsigned int size)`.
  - `unsigned int getId() const`; protected `void create()`; members `unsigned int target; unsigned int id; void* locked;`.
- `class VertexBufferGL : public GeometryBufferGL<VertexBuffer>` — ctor passes GL_ARRAY_BUFFER target.
- `class IndexBufferGL : public GeometryBufferGL<IndexBuffer>` — ctor passes GL_ELEMENT_ARRAY_BUFFER target.
- `class GeometryGL : public Geometry`
  - `GeometryGL(Device*, layout, vector<shared_ptr<VertexBuffer>>, shared_ptr<IndexBuffer>, baseVertexIndex)` / `~`.
  - `void draw(Primitive primitive, unsigned int offset, unsigned int count)`.
  - `unsigned int getId()` — VAO id (0 when VAOs unavailable/unused).
  - private: `unsigned int indexElementSize; unsigned int bindArrays(); void unbindArrays(unsigned int mask);`.

## Usage

Constructed via the abstract Device factories. DeviceContextGL::drawImpl forwards to `GeometryGL::draw(primitive, offset, count)` — note the GL draw signature has no index range and no cache-pointer plumbing (unlike D3D11).

## Gotchas

- Attribute binding relies on the fixed name↔slot mapping shared with ShaderGL's source parser (`getShaderAttributeName`, slots 0..15); custom names will not bind.
- Whether draw uses a real VAO or manual re-binding each call depends on caps.extVertexArrayObject at construction time.
