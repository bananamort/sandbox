# GfxBase/include/GfxBase/FileMeshData.h

## Purpose

Declares `RBX::FileMeshData` — the in-memory form of a Roblox FileMesh asset (`Vector3` positions + normals + UVs, triangle list, AABB) and the two entry points that convert it to/from the on-the-wire mesh format: `ReadFileMesh(data)` and `WriteFileMesh(f, mesh)`.

## API

```cpp
struct FileMeshData {
    std::vector<FileMeshVertexNormalTexture3d> vnts;  // interleaved pos/normal/uv
    std::vector<FileMeshFace> faces;                  // triangle indices a,b,c
    AABox aabb;
};
shared_ptr<FileMeshData> ReadFileMesh(const std::string& data);
void WriteFileMesh(std::ostream& f, const FileMeshData& mesh); // "writes the newest version always"; ostream must be binary
```

Implementation: FileMeshData.cpp. Struct layouts come from MeshFileStructs.h.

## Lua globals and events

None directly, but this is the decode path behind every Lua-visible `SpecialMesh`/`MeshPart`-era mesh asset: `App/util/MeshContentProvider.cpp:22` calls `ReadFileMesh(*data)` when a `rbxasset://...mesh` or user-mesh Content completes loading; `GfxRender/GeometryGenerator.cpp` (`fetchMesh`, `addFileMesh`) and `TextureCompositor.cpp` consume the result to build render geometry.

## Usage (who loads it)

Included by App/util/MeshContentProvider.cpp, Rendering/GfxRender/{GeometryGenerator.cpp, TextureCompositor.cpp}. Compiled into the GfxBase static lib by all three build systems.

## Gotchas

- Header comment on WriteFileMesh: "remember: set ostream to binary!" — text-mode streams corrupt the payload.
- `WriteFileMesh` writes raw vectors without empty-vector guards: writing a mesh with zero vertices/faces dereferences `&data.vnts[0]` on an empty vector (UB) even though `ReadFileMesh` rejects empty meshes on input.
