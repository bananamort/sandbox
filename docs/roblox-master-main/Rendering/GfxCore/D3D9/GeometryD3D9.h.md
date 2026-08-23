# Rendering/GfxCore/D3D9/GeometryD3D9.h

## Purpose

Class declarations for D3D9 geometry resources: `VertexLayoutD3D9` (`IDirect3DVertexDeclaration9` wrapper), `VertexBufferD3D9`/`IndexBufferD3D9` (lockable/uploadable D3D9 buffers with device-lost handling), and `GeometryD3D9` (vertex-stream bundle whose `draw` performs the actual DrawPrimitive call).

## API

- `class VertexLayoutD3D9 : public VertexLayout`
  - `VertexLayoutD3D9(Device*, const std::vector<Element>& elements)` / destructor.
  - `IDirect3DVertexDeclaration9* getObject()`.
- `class VertexBufferD3D9 : public VertexBuffer`
  - `VertexBufferD3D9(Device*, size_t elementSize, size_t elementCount, Usage usage)` / destructor.
  - `void* lock(GeometryBuffer::LockMode mode)`; `void unlock()`.
  - `void upload(unsigned int offset, const void* data, unsigned int size)`.
  - `onDeviceLost()` / `onDeviceRestored()`.
  - `IDirect3DVertexBuffer9* getObject()`.
- `class IndexBufferD3D9 : public IndexBuffer` — identical surface to VertexBufferD3D9 but wraps `IDirect3DIndexBuffer9*`.
- `class GeometryD3D9 : public Geometry`
  - `GeometryD3D9(Device*, const shared_ptr<VertexLayout>& layout, const std::vector<shared_ptr<VertexBuffer>>& vertexBuffers, const shared_ptr<IndexBuffer>& indexBuffer, unsigned int baseVertexIndex)` / destructor.
  - `void draw(Geometry::Primitive primitive, unsigned int offset, unsigned int count, unsigned int indexRangeBegin, unsigned int indexRangeEnd, VertexLayoutD3D9** layoutCache, GeometryD3D9** geometryCache)`.
  - No extra data members (state lives in the base Geometry).

## Usage

Buffers are created by DeviceD3D9 factories, filled via lock/unlock or upload, then bundled into a GeometryD3D9. DeviceContextD3D9::drawImpl calls `GeometryD3D9::draw`, passing pointers to the context's cached-layout/cached-geometry slots so the draw can skip redundant SetVertexDeclaration/SetStreamSource calls.

## Gotchas

- The `layoutCache`/`geometryCache` in-out pointers are the context's cache — callers must pass the same slots every frame or redundant state changes occur.
- `indexRangeBegin/indexRangeEnd` are consumed by the indexed draw on this backend: they are passed straight into `DrawIndexedPrimitive` as MinVertexIndex and NumVertices (= end − begin). GL and D3D11 ignore them; D3D9 is the reason the parameters exist.
- Buffers created with dynamic usage behave differently under lock (discard/no-overwrite semantics resolved in the .cpp); locking static buffers is a slow path.
- Device-lost restore recreates the underlying COM objects — any raw `getObject()` pointer captured before a reset is stale.
