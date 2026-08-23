# AppDraw/ — Module Index

## Module purpose

AppDraw is the renderer-independent "application drawing" layer: all Studio 3D-viewport UI adornments (selection boxes, hover highlights, drag handles, ground grid, axis widget, surface indicators, chat bubbles) plus legacy ray-picking for primitive shapes. It sits above `GfxBase` (the abstract `Adorn` interface) and below Studio tool code; nothing here talks to a specific graphics API.

## File roster

| File | Lines | Doc | One-line summary |
|---|---|---|---|
| Draw.cpp | 196 | [Draw.cpp.md](Draw.cpp.md) | RBX::Draw — selection/hover boxes with far-field line LOD, rotate-surface constraint widgets. |
| DrawAdorn.cpp | 1299 | [DrawAdorn.cpp.md](DrawAdorn.cpp.md) | RBX::DrawAdorn — handles3d/2d, zeroPlaneGrid, tori/cylinders, chatBubble2d, axis widget, outline/star boxes. |
| HitTest.cpp | 75 | [HitTest.cpp.md](HitTest.cpp.md) | RBX::HitTest — G3D ray-vs-box/ball/capsule picks in part space. |
| include/appdraw/Draw.h | 76 | [Draw.h.md](include/appdraw/Draw.h.md) | Draw class decl + select/hover color state. |
| include/appdraw/DrawAdorn.h | 293 | [DrawAdorn.h.md](include/appdraw/DrawAdorn.h.md) | DrawAdorn decl incl. handle/grid/text APIs and named color palette. |
| include/appdraw/DrawPrimitives.h | 48 | [DrawPrimitives.h.md](include/appdraw/DrawPrimitives.h.md) | Raw RenderDevice geometry helpers (impl lives outside this dir). |
| include/appdraw/HandleType.h | 10 | [HandleType.h.md](include/appdraw/HandleType.h.md) | enum HandleType {RESIZE, MOVE, ROTATE, VELOCITY}. |
| include/appdraw/HitTest.h | 27 | [HitTest.h.md](include/appdraw/HitTest.h.md) | HitTest class decl. |
| ReadMe.txt | 21 | [ReadMe.txt.md](ReadMe.txt.md) | AppWizard boilerplate stub. |
| CMakeLists.txt | 18 | [CMakeLists.txt.md](CMakeLists.txt.md) | CMake OBJECT library `AppDraw` of the 3 cpps + 5 headers. |
| AppDraw.vcxproj | 395 | [AppDraw.vcxproj.md](AppDraw.vcxproj.md) | MSBuild static lib (Debug/NoOpt/ReleaseTest/Release × Win32/Durango), v143. |
| AppDraw.vcxproj.filters | 44 | [AppDraw.vcxproj.filters.md](AppDraw.vcxproj.filters.md) | VS display filters. |
| AppDraw.xcodeproj/project.pbxproj | 584 | [project.pbxproj.md](AppDraw.xcodeproj/project.pbxproj.md) | macOS i386 + iOS armv7/arm64 static-lib targets. |

REMAINING: none — all 13 files under Rendering/AppDraw/ are documented.
