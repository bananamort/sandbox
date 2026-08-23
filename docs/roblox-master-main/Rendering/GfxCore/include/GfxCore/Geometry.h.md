# Rendering/GfxCore/include/GfxCore/Geometry.h

## Purpose

Vertex-data abstraction: `VertexLayout` (declarative element list), `GeometryBuffer`/`VertexBuffer`/`IndexBuffer` (lockable/uploadable GPU buffers), `Geometry` (layout + one or more vertex streams + optional index buffer + base-vertex offset), and the by-value draw descriptor `GeometryBatch`.

## API

- `class VertexLayout : public Resource`
  - `enum Semantic { Semantic_Position, Semantic_Normal, Semantic_Color, Semantic_Texture, Semantic_Count }`.
  - `enum Format { Format_Float1..Float4, Format_Short2, Format_Short4, Format_UByte4, Format_Color, Format_Count }`.
  - `struct Element { unsigned int stream; unsigned int offset; Format format; Semantic semantic; unsigned int semanticIndex; Element(stream, offset, format, semantic, semanticIndex=0); }`.
  - ctor `VertexLayout(Device*, const std::vector<Element>&)`; getter `getElements()`.
- `class GeometryBuffer : public Resource`
  - `enum Usage { Usage_Static, Usage_Dynamic }`; `enum LockMode { Lock_Normal, Lock_Discard }`.
  - `virtual void* lock(LockMode mode = Lock_Normal) = 0`; `virtual void unlock() = 0`; `virtual void upload(unsigned int offset, const void* data, unsigned int size) = 0`.
  - `getElementSize()/getElementCount()`; ctor stores both.
- `VertexBuffer`, `IndexBuffer` — thin typed subclasses of GeometryBuffer (ctor passthrough).
- `class Geometry : public Resource`
  - `enum Primitive { Primitive_Triangles, Primitive_Lines, Primitive_Points, Primitive_TriangleStrip }`.
  - ctor `Geometry(Device*, layout, std::vector<shared_ptr<VertexBuffer>>, indexBuffer, baseVertexIndex)`; holds them as members.
- `class GeometryBatch` (value type)
  - ctors: `(geometry, primitive, count, indexRangeSize)` and `(geometry, primitive, offset, count, indexRangeBegin, indexRangeEnd)`.
  - getters: `getGeometry/getPrimitive/getOffset/getCount/getIndexRangeBegin/getIndexRangeEnd`.

## Usage

Renderers fill VertexBuffers via `lock(Lock_Discard)` for dynamic geometry or `upload()` for static; a `VertexLayout` maps those bytes onto shader inputs (`Semantic_*` is translated per-backend: D3D `D3DDECLUSAGE`/input-layout semantics, GL attribute locations). Draws are issued as `GeometryBatch` through `DeviceContext::draw`.

## Gotchas

- Multi-stream support exists (`Element::stream`, multi-buffer `createGeometry` overload) but most call sites use a single interleaved stream.
- `baseVertexIndex` shifts all indices at draw time (used to pack multiple meshes into one buffer).
- The two-arg GeometryBatch ctor computes an implicit index range from `count`/`indexRangeSize` — UNKNOWN exact formula here (defined in Geometry.cpp); it feeds D3D9's min/max index.
- IndexBuffer element size is caller-chosen (16 vs 32 bit) via `createIndexBuffer(elementSize,...)`; backends map it to D3DFMT_INDEX16/32 or GL_UNSIGNED_SHORT/INT.
