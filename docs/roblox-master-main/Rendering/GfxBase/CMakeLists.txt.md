# CMakeLists.txt (GfxBase)

Source: `roblox-sandbox/Rendering/GfxBase/CMakeLists.txt` (47 lines)

## Purpose

CMake build for GfxBase as an **OBJECT library** named `GfxBase` — the Mac/Linux path mirroring `GfxBase.vcxproj` on Windows. Object libraries emit no `.a`/`.so`; their objects are absorbed by the linking target.

## API

```cmake
include(App)
include_directories(include)
include_directories(../g3d/include)
include_directories(../RbxG3d/include)     # note lowercase 'd' in RbxG3d here
include_directories(../AppDraw/include)
# HEADERS: all 23 include/GfxBase/*.h listed explicitly
# SOURCES: 14 cpp files:
add_library(GfxBase OBJECT ${SOURCES} ${HEADERS})
```

SOURCES list (order as written): IAdornableCollector, RenderSettings, Adorn, RenderCaps, GfxPart, RenderStats, FileMeshData, PartIdentifier, AdornSurface, FrameRateManager, ViewBase, AdornBillboarder, AdornBillboarder2D, ViewportBillboarder (.cpp).

HEADERS list: FrameRateManager, MeshGen, Adorn, Type, AdornSurface, RenderStats, MeshFileStructs, FileMeshData, RenderCaps, Part, IAdornable, GfxPart, ViewBase, RenderSettings, IAdornableCollector, Typesetter, TextureProxyBase, Image, AdornBillboarder, AdornBillboarder2D, ViewportBillboarder, PartIdentifier, AsyncResult (.h).

## Usage

Pulled in from the parent Rendering CMake super-build; the explicit header list exists so IDE generators show headers.

## Gotchas

- The vcxproj compiles the same set; keep both lists in sync when adding files.
- Include path is spelled `../RbxG3d/include` (lowercase d) — case-insensitive filesystems tolerate it; a strict Linux build would not.
- Headers are passed to `add_library` only for IDE visibility; they do not get compiled standalone.
