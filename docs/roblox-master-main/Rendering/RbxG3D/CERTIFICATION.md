# CERTIFICATION — Rendering/RbxG3D group review

Independent re-verification pass (every source read in full; every concrete doc claim checked against source). Scope: `roblox-sandbox/Rendering/RbxG3D/` (11 files) ↔ `docs/roblox-master-main/Rendering/RbxG3D/` (11 docs + INDEX). Coverage 1:1 confirmed (the task brief's "(12)" = 11 source docs + INDEX).

| File | Source | Verdict | Notes |
|---|---|---|---|
| include/RbxG3D/RbxCamera.h | RbxCamera.h.md | PASS | All API/state claims verified; worldRay callers spot-checked at exact lines (MouseCommand.cpp:102, ViewportBillboarder.cpp:128, BillboardGui.cpp:322); stale `// namespace G3D` closer and commented-out getZValue both real. |
| RbxCamera.cpp | RbxCamera.cpp.md | PASS | Defaults (0.1/inf/55°), imagePlaneDepth formula, project ±inf sentinel logic incl. inverted-y gotcha, frustum vertex/face construction with isFinite guard, legacy comment blocks (255–308, 206–241), and the **latent i<6 OOB** in nested Frustum::containsPoint/intersectsSphere with infinite far plane — all verified verbatim against source. |
| include/RbxG3D/RbxRay.h | RbxRay.h.md | PASS | Fork rationale quote, Möller–Trumbore inline bodies (det<EPSILON one-sided; t/det vs 1/det variants), macro #undef block, LuaAtomicClasses.cpp:196 Ray.new binding — verified. |
| RbxRay.cpp | RbxRay.cpp.md | PASS | reflect/refract epsilon bumps, side-agnostic intersectionPlane, CollisionDetection delegates, inside-box→0.0f tweak — verified. |
| include/RbxG3D/Frustum.h | Frustum.h.md | FIXED | Usage quote corrected: Camera.cpp:1511 passes `-farPlaneZ()` (doc omitted the minus sign on far z). All other refs verified (PartInstance.cpp:3110/3116, ModelInstance.cpp:454, LightGrid.cpp:718 intersectsSphere). |
| Frustum.cpp | Frustum.cpp.md | PASS | Constructor math, far-omission at inf(), Plane::fromEquation NaN guard, intersectsAABB first-6-planes latent UB — all verified. |
| include/RbxG3D/RbxTime.h | RbxTime.h.md | PASS | Dead-declaration claim re-proven: zero `RbxTime::` symbols tree-wide; four include sites confirmed at exact lines; CMake/pbxproj list it, vcxproj does not; PartOperationAsset.cpp:12 RBX-cased include resolves to Base's rbxTime.h. |
| RbxG3D.vcxproj | RbxG3D.vcxproj.md | FIXED | Added exact asymmetry: Release\|Durango drops `..\..\TBB_4_1\include` from the shared include list. RenderLib.lib naming mismatch, SAK SCC blocks, no-warnings-as-errors, UpgradeFromVC71 sheets, RbxTime.h absence — all verified. |
| RbxG3D.vcxproj.filters | RbxG3D.vcxproj.filters.md | PASS | 3 buckets, standard GUIDs, BOM, mirrors-vcxproj claims verified. |
| CMakeLists.txt | CMakeLists.txt.md | PASS | OBJECT lib, include(Boost)/include(App), include_project_files glob, 4 headers + 3 sources — exact. |
| RbxG3D.xcodeproj/project.pbxproj | project.pbxproj.md | FIXED | HEADER_SEARCH_PATHS claim qualified: `../../log/include` present in project-level + iOS-target configs but absent from macOS target-level overrides. Two targets/products, i386/10.8/10.6 mac vs armv7-arm64/5.1.1 iOS, GeekInfo path, per-arch 64-bit warning override, D0D04F…1C761479 NoOpt vintage — all verified. |
| INDEX.md | — | FIXED | All 11 roster doc-links were broken (`RbxG3D/...` prefix resolving to nonexistent `RbxG3D/RbxG3D/*.md`); rewritten to correct relative paths. Line counts match wc within trailing-newline convention (±1 on files lacking final newline: vcxproj 207/filters 38-39/RbxTime.h 16-17 — not factual errors). |

**Totals**: 12 docs reviewed — 4 FIXED, 8 PASS, 0 FAIL.
