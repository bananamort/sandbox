# CSG/ — Module Index

## Module purpose

The CSG (Constructive Solid Geometry) kernel adapter: implements Roblox's solid-modeling operations (Studio Union/Negate → mesh output) by wrapping the vendored third-party **sgCore** SDK. The abstract interface it implements lives elsewhere (`V8DataModel/CSGMesh.h`); this directory holds only the concrete sgCore-backed realization plus its MSBuild project.

**Scope note**: `CSG/sgCore/` is a vendored external SDK (Simplicitas/sgCore geometry kernel headers+libs). It is intentionally NOT documented here — treat it as an opaque dependency exposing `sgCObject`, `sgBoolean::Union/Sub`, `sgFileManager::ObjectFromTriangles/ObjectToBitArray/BitArrayToObject`, `sgInitKernel`, DXF export, etc.

## File roster

| File | Lines | Doc | One-line summary |
|---|---|---|---|
| CSGKernel.h | 150 | [CSGKernel.h.md](CSGKernel.h.md) | Declares CSGMeshSgCore (sgCore-backed CSGMesh impl), factory, half-edge + crease structs, vertex clustering. |
| CSGKernel.cpp | 1518 | [CSGKernel.cpp.md](CSGKernel.cpp.md) | sgCore boolean ops, legacy + crease-aware triangulation paths, BRep binary serialization, DXF failure dumps. |
| CSG.vcxproj | 311 | [CSG.vcxproj.md](CSG.vcxproj.md) | Static-lib build of CSGKernel for Win32/Durango, v143, includes `.\sgCore`. |
| CSG.vcxproj.filters | 23 | [CSG.vcxproj.filters.md](CSG.vcxproj.filters.md) | VS filter metadata only. |
| CSG.xcodeproj/project.pbxproj | 358 | [project.pbxproj.md](CSG.xcodeproj/project.pbxproj.md) | macOS Xcode build of the same kernel: i386-only `libCSG.a`, boost via `$(CONTRIB_PATH)/boost_1_55_0`. |

REMAINING: none — both kernel sources and all three project files are documented; only `sgCore/` is excluded per the scope note above.
