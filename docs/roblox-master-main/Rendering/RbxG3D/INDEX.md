# Rendering/RbxG3D/ — Module Index

## Module purpose

Roblox's forked G3D math/camera library: the **pre-G3D-8.0** camera and ray classes Roblox modified and kept ("This is not the G3D 8.0 GCamera"), plus a plane-list view frustum for culling. Three small translation units providing: `RBX::RbxCamera` (FOV/projection/pixel-ray math wrapped by `V8DataModel::Camera`), `RBX::RbxRay` (non-unit-direction ray; storage type of the Lua `Ray` datatype), `RBX::Frustum` (plane-list culling frustum built by Camera each frame), and a dead one-declaration time header. The modern G3D 8.0 tree it diverged from lives separately in `Rendering/g3d/`.

## File roster

| File | Lines | Doc | One-line summary |
|---|---|---|---|
| include/RbxG3D/RbxCamera.h | 272 | [RbxCamera.h.md](RbxG3D/RbxCamera.h.md) | RbxCamera class + nested vertex/face Frustum; project/inverseProject/worldRay/clip planes. |
| RbxCamera.cpp | 486 | [RbxCamera.cpp.md](RbxG3D/RbxCamera.cpp.md) | FOV/image-plane math, projection, world rays, frustum construction; nested-Frustum OOB gotcha. |
| include/RbxG3D/RbxRay.h | 371 | [RbxRay.h.md](RbxG3D/RbxRay.h.md) | Non-unit-direction ray; inline Möller–Trumbore triangle intersection; backs Lua Ray. |
| RbxRay.cpp | 115 | [RbxRay.cpp.md](RbxG3D/RbxRay.cpp.md) | reflect/refract, side-agnostic ray-plane, CollisionDetection delegates. |
| include/RbxG3D/Frustum.h | 52 | [Frustum.h.md](RbxG3D/Frustum.h.md) | Plane-list frustum API with AABB/sphere tests. |
| Frustum.cpp | 148 | [Frustum.cpp.md](RbxG3D/Frustum.cpp.md) | Local-space frustum construction (FP-error mitigation); containment tests; hardcoded-6-plane OOB note. |
| include/RbxG3D/RbxTime.h | 17 | [RbxTime.h.md](RbxG3D/RbxTime.h.md) | DEAD declaration — getTick()/m_startTime defined nowhere; distinct from Base's rbxTime.h. |
| RbxG3D.vcxproj | 207 | [RbxG3D.vcxproj.md](RbxG3D/RbxG3D.vcxproj.md) | Win32/Durango static lib — output named RenderLib.lib, v143. |
| RbxG3D.vcxproj.filters | 39 | [RbxG3D.vcxproj.filters.md](RbxG3D/RbxG3D.vcxproj.filters.md) | VS display-only filter metadata. |
| CMakeLists.txt | 18 | [CMakeLists.txt.md](RbxG3D/CMakeLists.txt.md) | CMake OBJECT library for Mac/Linux path. |
| RbxG3D.xcodeproj/project.pbxproj | 566 | [project.pbxproj.md](RbxG3D.xcodeproj/project.pbxproj.md) | Xcode mac (i386 libRbxG3D.a) + iOS (armv7/arm64 libRbxG3DiOS.a) targets. |

REMAINING: none — all 11 files documented.

## Build topology

Same code, three build systems: vcxproj (Windows/Xbox, artifact `RenderLib.lib`), CMake OBJECT lib (Mac/Linux), Xcode static libs (Mac i386 / iOS arm). All compile exactly {Frustum, RbxCamera, RbxRay}.cpp.
