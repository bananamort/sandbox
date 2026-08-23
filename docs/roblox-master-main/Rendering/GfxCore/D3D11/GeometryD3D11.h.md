# Rendering/GfxCore/D3D11/GeometryD3D11.h

## Purpose

D3D11 vertex data objects: `VertexLayoutD3D11` (element descriptors + registered shader list for input-layout creation), templated `GeometryBufferD3D11<Base>` (ID3D11Buffer with lock/upload), concrete Vertex/Index buffers, and `GeometryD3D11` whose `draw` performs the actual IA/Draw calls with three-way caching.

## API

- `class VertexLayoutD3D11 : public VertexLayout`
  - ctor converts GfxCore elements to `std::vector<D3D11_INPUT_ELEMENT_DESC> elements11`; getters `getElements11()/getElementsCount()`.
  - `void registerShader(const shared_ptr<VertexShaderD3D11>& shader)` — tracks shaders using this layout (`std::vector<weak_ptr<VertexShaderD3D11>> shaders`) so they can rebuild their per-layout input layouts when the layout changes.
- `template <typename Base> class GeometryBufferD3D11 : public Base`
  - `lock(LockMode)/unlock()/upload(offset,data,size)`; `ID3D11Buffer* getObject()`; protected `create(unsigned bindFlags)` (VERTEX_BUFFER vs INDEX_BUFFER); private `void* locked` staging pointer.
- `VertexBufferD3D11`, `IndexBufferD3D11` — instantiations of the template.
- `class GeometryD3D11 : public Geometry`
  - `void draw(Geometry::Primitive, offset, count, indexRangeBegin, indexRangeEnd, VertexLayoutD3D11** layoutCache, GeometryD3D11** geometryCache, ShaderProgramD3D11** programCache)` — binds IA state and issues Draw/DrawIndexed, using caller-supplied cache slots to skip redundant binds.

## Usage

DeviceContextD3D11::drawImpl resolves the program's cached input layout and calls GeometryD3D11::draw. Dynamic buffers use Map with DISCARD; static ones use UpdateSubresource via upload.

## Gotchas

- The draw signature takes raw double-pointer caches owned by the context — an unusual inversion that keeps bind-state on the context while draw logic lives in the geometry object.
- Input layouts are created lazily per (vertex layout, vertex shader) pair and must be invalidated when either changes (see context invalidate hooks).
