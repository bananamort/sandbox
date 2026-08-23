# AppDraw/CMakeLists.txt

## Purpose

CMake build for AppDraw: includes the engine's `App` cmake module, adds include dirs (`include`, `../g3d/include`, `../RbxG3D/include`, `../GfxBase/include`), appends 5 headers + 3 sources, and declares `add_library(AppDraw OBJECT ...)` — an **OBJECT library**, so it contributes object files directly to whatever links it (no standalone .a/.lib artifact).

## Gotchas

- Mirrors the vcxproj file list exactly (Draw/DrawAdorn/HitTest cpps; Draw, HitTest, DrawAdorn, HandleType, DrawPrimitives headers).
- Does not add SDL2/boost/TBB include dirs that the vcxproj has — those presumably come from the `App` include module or parent scope.
