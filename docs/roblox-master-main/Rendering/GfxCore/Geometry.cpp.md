# Rendering/GfxCore/Geometry.cpp

## Purpose

Constructors for the geometry value types, GPU-memory profiler counters for buffers, draw-count validation, and the `GeometryBatch` index-range conventions.

## API

- `VertexLayout::Element::Element(stream, offset, format, semantic, semanticIndex)` / `VertexLayout::VertexLayout(device, elements)`.
- `GeometryBuffer::GeometryBuffer(device, elementSize, elementCount, usage)`.
- `VertexBuffer/IndexBuffer` ctors — add/subtract `elementSize*elementCount` bytes to profiler counters `memory/gpu/vertexbuffer` / `memory/gpu/indexbuffer`.
- `Geometry::Geometry(device, layout, vector<VertexBuffer>, indexBuffer, baseVertexIndex)`.
- `static inline bool isCountValid(Primitive primitive, unsigned int count)` — Triangles: count%3==0; Lines: count%2==0; Points: always; TriangleStrip: **not** 1 and not 2.
- `GeometryBatch(geometry, primitive, count, indexRangeSize)` — offset=0, indexRangeBegin=0, indexRangeEnd=indexRangeSize; asserts valid count.
- `GeometryBatch(geometry, primitive, offset, count, indexRangeBegin, indexRangeEnd)` — asserts `indexRangeBegin <= indexRangeEnd`.

## Usage

Renderers construct batches per draw call; the index range fields exist so D3D9 can compute the min/maxIndex parameters of DrawIndexedPrimitive while other backends ignore them.

## Gotchas

- TriangleStrip with counts 1–2 is rejected by assert (degenerate strips).
- The index range in the short ctor is [0, indexRangeSize), i.e. callers must pass total index span, not vertex count.
- Buffer memory accounting happens at this abstract level (not backend), so counters measure logical buffer bytes regardless of backend padding.
