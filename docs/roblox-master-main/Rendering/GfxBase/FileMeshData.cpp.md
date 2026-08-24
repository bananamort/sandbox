# FileMeshData.cpp

Source: `roblox-sandbox/Rendering/GfxBase/FileMeshData.cpp` (333 lines)

## Purpose

The `.mesh` asset parser/writer: reads Roblox FileMesh versions 1.00/1.01 (ASCII text format) and 2.00 (binary), dedups vertices, computes AABBs, and writes back as v2.00 binary. Home of hand-rolled fast number parsers.

## API

### Internal helpers
- `struct MeshVertexHasher` — equality via memcmp over the whole struct; hash over POSITION ONLY (vx,vy,vz via boost::hash_combine).
- `void optimizeMesh(FileMeshData&)` — dedups vertices with `DenseHashMap` (sentinel: vx=FLT_MAX); remap table rebuilt, faces reindexed.
- `unsigned int atouFast(const char*, const char** end)` — skip ws, read digits, no overflow guard.
- `double atofFast(const char*, const char** end)` — sign/int/fraction/exponent parse via lookup tables (`digits[]`, `powers[]` 1e0..1e22); falls back to powf beyond table; NO NaN/inf handling.
- `const char* readToken(data, terminator)` / `readFloatToken(...)` — expect a specific char after ws else throw `RBX::runtime_error("Error reading mesh data: expected %c", ...)`.
- `static void readData(const std::string&, size_t& offset, void*, size)` — bounds-checked memcpy; throws on overrun.

### Readers
- `shared_ptr<FileMeshData> readMeshFromV1(const std::string& data, size_t offset_, float scaler)` — ASCII: face count then per face 3× `[vx,vy,vz][nx,ny,nz][tu,tv,tw]`; normal unit-normalized (non-finite → zero); positions ×scaler; **tv flipped to `1-tv`**; faces sequential i*3+{0,1,2}; ends with optimizeMesh().
- `static shared_ptr<FileMeshData> readMeshFromV2(const std::string&, size_t offset)` — binary: FileMeshHeader; THROWS unless cbSize/cbVerticesStride/cbFaceStride exactly match sizeof of the three structs; rejects empty meshes; requires offset==data.size() at end; validates every face index < num_vertices ("validate indices to avoid buffer overruns later").

### Public
- `FileMeshData* computeAABB(FileMeshData*)` — position AABB; empty mesh → degenerate zero box.
- `shared_ptr<FileMeshData> ReadFileMesh(const std::string& data)` — sniffs first line: "version 1.00"→V1 scaler **0.5f**; "version 1.01"→V1 scaler 1.0f; "version 2.00"→V2; else throw. Always computeAABB afterwards.
- `void WriteFileMesh(std::ostream& f, const FileMeshData& data)` — emits "version 2.00\n" + header + raw vertex/face arrays.

## Usage

Paired with FileMeshData.h (struct decl) and MeshFileStructs.h (disk structs). Entry point for all SpecialShape/FileMesh content loading.

## Gotchas
- V1 1.00 meshes are HALF-SCALE (scaler 0.5) — legacy unit quirk preserved deliberately.
- Hash-on-position-only means vertices sharing position but differing normal/UV COLLAPSE in optimizeMesh — intentional dedup with lossy corners.
- atouFast/atofFast accept malformed input silently (stop at first bad char) and can't represent exponents > ±22 precisely.
- WriteFileMesh dereferences `data.vnts[0]`/`faces[0]` — UB on empty vectors (readers reject empty, writers don't).
