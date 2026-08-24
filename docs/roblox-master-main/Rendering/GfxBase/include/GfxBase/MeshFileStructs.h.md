# MeshFileStructs.h

Source: `roblox-sandbox/Rendering/GfxBase/include/GfxBase/MeshFileStructs.h` (36 lines)

## Purpose

The on-disk binary structs for Roblox `.mesh` files (the `FileMesh` format consumed by `FileMeshData`): a header plus vertex/face records, byte-packed so the file can be read directly into these layouts.

## API

All inside `#pragma pack(push, 1)` (no padding):

```cpp
struct FileMeshHeader {
    unsigned short cbSize;             // size of this header on disk
    unsigned char  cbVerticesStride;   // bytes per vertex record
    unsigned char  cbFaceStride;       // bytes per face record
    unsigned int   num_vertices;
    unsigned int   num_faces;
};
struct FileMeshVertexNormalTexture3d {
    float vx, vy, vz;    // position
    float nx, ny, nz;    // normal
    float tu, tv, tw;    // uv (+ w slot)
};
struct FileMeshFace {
    unsigned int a, b, c;  // vertex indices
};
```

In-file comment: *"keep backward/forward compatibility by only appending to these structs — stride information will keep this working."*

## Usage

Consumed by `FileMeshData.cpp` (same dir) which parses mesh assets into renderable data; the stride fields (`cbVerticesStride`/`cbFaceStride`) let readers skip over appended future fields.

## Gotchas

- The comment is a hard versioning contract: NEVER insert fields or reorder — only append, and bump/keep strides consistent.
- `tw` exists in storage but most consumers use only `tu/tv`.
- Little-endian assumption throughout (x86/x64/Durango targets only).
