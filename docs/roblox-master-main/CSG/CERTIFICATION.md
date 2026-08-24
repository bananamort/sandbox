# CERTIFICATION — CSG/ group review

Independent re-verification pass (every source read in full; every concrete doc claim checked against source). Scope: `roblox-sandbox/CSG/` minus `sgCore/` ↔ `docs/roblox-master-main/CSG/*.md`. Coverage 1:1 confirmed (5 sources ↔ 5 source docs + INDEX).

| File | Source | Verdict | Notes |
|---|---|---|---|
| CSGKernel.h | CSGKernel.h.md | FIXED | Resolved the "UNKNOWN exact include site": tree-wide grep proves no consumer of `CSGMeshFactorySgCore` / no caller of `CSGMeshFactory::set()` — sgCore factory never installed in-tree. Corrected `-1 = none` to apply to ctor-initialized `oppEdge`; exact clamp constant 1048574 (0xFFFFE). |
| CSGKernel.cpp | CSGKernel.cpp.md | FIXED | Removed nonexistent `V8DataModel::CSGService` reference; corrected Factory bullet ("plugged into" → no in-tree installer, default factory returns base CSGMesh per CSGMesh.cpp:40-46); corrected BRep claim (asset MeshData round-trips via base `CSGMesh::toBinaryString/fromBinaryString`, SolidModelContentProvider.cpp:35-37 — not this BRep form); corrected Usage paragraph; replaced unverifiable intersection-emulation claim with dead-in-tree fact; ADDED gotcha: `operator=` drops decal remaps that the copy ctor copies (cpp:167-171 vs 178-186). All remaining claims verified against source (errcode semantics 2/4/>1, 45° buildBRep angle, makeKey packing li<<60\|z<<40\|y<<20\|x @20bits each, O(V²) smoothing, DXF Windows-only dumps). |
| CSG.vcxproj | CSG.vcxproj.md | FIXED | Minor: `_WIN32_WINNT=0x0501` is Debug-config-only (Release/NoOpt define only `WIN32;NDEBUG/_RELEASE;_LIB[;_NOOPT]`). All other facts verified: GUID, v143+SDK 10.0 retarget, include list verbatim, SSE2/AVX split, BufferSecurityCheck off in Release, Common.props NoOpt/Release-only import, file roster, stale Perforce SCC blocks. |
| CSG.vcxproj.filters | CSG.vcxproj.filters.md | PASS | Two stock-GUID filters, mappings, BOM all verified. |
| CSG.xcodeproj/project.pbxproj | project.pbxproj.md | PASS | All verified: objectVersion 46, i386-only target configs, deployment-target split 10.9/10.6, empty Frameworks phase, header search paths verbatim, RBX_PLATFORM_MAC, ORGANIZATIONNAME placeholder, sourcecode.c.h artifact. |
| INDEX.md | — | PASS | Line counts match actual files (150/1518/311/23/358); roster complete; sgCore exclusion note accurate. |

**Totals**: 6 docs reviewed — 3 FIXED, 3 PASS, 0 FAIL.
