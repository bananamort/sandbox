# Rendering/GfxCore/D3D11/GeometryD3D11.cpp

## Purpose

Implementation of the D3D11 geometry stack: `VertexLayoutD3D11` (input-layout element descriptors), templated `GeometryBufferD3D11<Base>` (shared vertex/index buffer logic over `ID3D11Buffer`), `VertexBufferD3D11`, `IndexBufferD3D11`, and `GeometryD3D11` (draw with input-layout/IA binding caches).

## API

- Tables: `gBufferUsageD3D11[Usage_Count]` — `Usage_Static`→`D3D11_USAGE_DEFAULT`/no CPU access, dynamic→`D3D11_USAGE_DYNAMIC`+CPU write; `gVertexLayoutFormatD3D11[Format_Count]` → 8 DXGI formats (R32 float through R8G8B8A8 UNORM); `gVertexLayoutSemanticD3D11[Semantic_Count]` → "POSITION"/"NORMAL"/"COLOR"/"TEXCOORD"; `gGeometryPrimitiveD3D11[Primitive_Count]` → TRIANGLELIST/LINELIST/POINTLIST/TRIANGLESTRIP; `gLockModeD3D11[Lock_Count]` → `D3D11_MAP_WRITE`, `D3D11_MAP_WRITE_DISCARD`.
- `VertexLayoutD3D11::VertexLayoutD3D11(Device*, const std::vector<Element>&)` — converts each abstract element to a `D3D11_INPUT_ELEMENT_DESC` (`PER_VERTEX_DATA`, step rate 0).
- `~VertexLayoutD3D11()` — detaches from every registered vertex shader (`removeLayout`) and asks the device context to invalidate its cached layout.
- `void registerShader(const shared_ptr<VertexShaderD3D11>&)` — records weak back-reference; called by shaders that bake an `ID3D11InputLayout` for this layout.
- `template<Base> GeometryBufferD3D11<Base>::GeometryBufferD3D11(Device*, size_t elementSize, size_t elementCount, GeometryBuffer::Usage)`.
- `template<Base> void create(unsigned bindFlags)` — `CreateBuffer`; throws `RBX::runtime_error("Couldn't create geometry buffer: %x", hr)` on failure.
- `template<Base> void* lock(GeometryBuffer::LockMode mode)` — static usage: allocates a CPU shadow (`new char[elementSize*elementCount]`); dynamic: `Map` (WRITE or WRITE_DISCARD), returns NULL + FASTLOG2 on failure.
- `template<Base> void unlock()` — static: `upload(0, shadow, fullsize)` then delete shadow; dynamic: `Unmap`.
- `template<Base> void upload(unsigned int offset, const void* data, unsigned int size)` — `UpdateSubresource` with a 1-row D3D11_BOX at byte offset.
- `VertexBufferD3D11(Device*, elementSize, elementCount, Usage)` — creates with `D3D11_BIND_VERTEX_BUFFER`.
- `IndexBufferD3D11(...)` — validates elementSize is 2 or 4 (throws otherwise), creates with `D3D11_BIND_INDEX_BUFFER`.
- `GeometryD3D11(Device*, layout, vector<shared_ptr<VertexBuffer>>, shared_ptr<IndexBuffer>, baseVertexIndex)`; destructor invalidates context geometry cache.
- `void GeometryD3D11::draw(Geometry::Primitive primitive, unsigned int offset, unsigned int count, unsigned int indexRangeBegin, unsigned int indexRangeEnd, VertexLayoutD3D11** layoutCache, GeometryD3D11** geometryCache, ShaderProgramD3D11** programCache)` — binds input layout on change (fetched from program via `getInputLayout11(vertexLayout)`), VBs one-by-one plus IB (`R16_UINT` for 2-byte elements else `R32_UINT`), calls `programCache->uploadConstantBuffers()`, sets topology, then `DrawIndexed(count, offset, baseVertexIndex)` or `Draw(count, offset)`.

## Usage

Created exclusively through the abstract `Device` factories (`createVertexLayout/createVertexBuffer/createIndexBuffer/createGeometry` in Device.cpp). `DeviceContextD3D11::drawImpl` is the only caller of `GeometryD3D11::draw`, passing pointers into its own cache slots so consecutive draws skip IA rebinds.

## Gotchas

- Static buffers never Map the GPU resource — they use a full-buffer CPU shadow uploaded on `unlock()`; partial updates of static buffers are not possible via lock/unlock.
- `indexRangeBegin/indexRangeEnd` are accepted but unused by D3D11 (they exist for D3D9's min/max index).
- The input layout is owned per vertex shader (`getInputLayout11`); layouts track their shaders weakly so destruction order is safe, but a layout used by a destroyed shader's cached slot relies on `invalidateCachedVertexLayout`.
- Lock/unlock nesting is asserted (`RBXASSERT(!locked)` / `(locked)`); there is no read-back path.
- `upload` box spans only bytes [offset, offset+size) of row 0 — fine for buffers, but no format conversion.
