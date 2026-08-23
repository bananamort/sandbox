# Rendering/GfxCore/D3D9/GeometryD3D9.cpp

## Purpose

Implementation of D3D9 geometry resources: vertex declaration creation with FFP fallbacks, managed/dynamic vertex and index buffers (lock/unlock/upload, device-lost recreation), and the cached draw path that issues SetVertexDeclaration/SetStreamSource/SetIndices plus Draw(Indexed)Primitive.

## API

Implements VertexLayoutD3D9, VertexBufferD3D9, IndexBufferD3D9, GeometryD3D9 as declared in GeometryD3D9.h.

- Lookup tables:
  - `gVertexLayoutFormatD3D9` — FLOAT1..4, SHORT2/4, UBYTE4, D3DCOLOR.
  - `gVertexLayoutSemanticD3D9` — POSITION, NORMAL, COLOR, TEXCOORD.
  - `gBufferUsageD3D9` — Static→(MANAGED, 0); Dynamic→(DEFAULT, DYNAMIC|WRITEONLY).
  - `gBufferLockD3D9[usage][mode]` — dynamic+Lock_Discard → D3DLOCK_DISCARD; everything else 0.
  - `gGeometryPrimitiveD3D9` — TRIANGLELIST, LINELIST, POINTLIST, TRIANGLESTRIP.
- Helpers: `createVertexBuffer` / `createIndexBuffer` (index format INDEX16 vs INDEX32 from elementSize; throw on failure); `getPrimitiveCount(primitive, count)` — /3 triangles, /2 lines, points as-is, strip count−2.
- `VertexLayoutD3D9` — maps elements to D3DVERTEXELEMENT9 (stream/offset/type/method DEFAULT/semantic/usageIndex), appends D3DDECL_END, CreateVertexDeclaration. FFP quirk: UBYTE4 converted to FLOAT1 when caps.supportsFFP (asserts semantic is TEXCOORD). Destructor invalidates context's cached layout then releases.
- Buffers:
  - Ctor creates the COM object (IndexBuffer ctor throws on elementSize ∉ {2,4}); dtor releases + (layout only) cache invalidation is NOT done for buffers — see Gotchas.
  - `lock(mode)` — Lock whole buffer with table flags; returns NULL on failure (logged).
  - `upload(offset, data, size)` — full-buffer Lock_Normal, memcpy at offset, unlock; bounds assert-only.
  - `onDeviceLost/onDeviceRestored` — DEFAULT-pool buffers released/recreated empty; MANAGED survives.
- `GeometryD3D9` — plain passthrough ctor; destructor invalidates context's cached geometry.
- `draw(primitive, offset, count, indexRangeBegin, indexRangeEnd, layoutCache, geometryCache)`:
  - When `*geometryCache != this`: update it, then rebind declaration (only if `*layoutCache` differs) and ALL stream sources (SetStreamSource i, offset 0, stride elementSize) and SetIndices when indexed.
  - Draw: indexed path uses baseVertexIndex, MinVertexIndex=indexRangeBegin, NumVertices=indexRangeEnd−indexRangeBegin, StartIndex=offset, primCount from getPrimitiveCount; non-indexed path DrawPrimitive.

## Usage

Buffers are filled via lock/unlock or upload before first use. The renderer calls DeviceContextD3D9::drawImpl → this draw, passing the context's two cache slots so consecutive draws of the same geometry skip stream setup entirely.

## Gotchas

- Buffer destruction does NOT invalidate the context caches — GeometryD3D9's dtor clears cachedGeometry but a destroyed VertexLayout/VertexBuffer referenced by a still-alive geometry leaves stale COM pointers in cachedVertexLayout/stream slots until the next different-geometry bind.
- Dynamic buffers are created WRITEONLY: reading via lock() on them is illegal by D3D semantics despite returning a pointer.
- Lock failure returns NULL silently (log only); upload() would memcpy to NULL+offset if unchecked by callers.
- Stream rebinding always uses offset 0 and assumes each vertex buffer holds exactly one attribute stream laid out per the declaration — no interleaved-offset support here.
- `upload()` locks the ENTIRE buffer for any partial write — on DISCARD-managed dynamic buffers a partial upload through lock(Lock_Normal) doesn't discard but stalls; prefer lock/unlock with explicit mode for streaming.
- Non-indexed draw ignores indexRange params; indexed draw requires indexRangeEnd ≥ indexRangeBegin (NumVertices = difference) — degenerate ranges produce driver errors.
- FFP UBYTE4→FLOAT1 rewrite assumes such attributes are normalized floats in TEXCOORD slots; raw integer data would be misinterpreted under FFP.
