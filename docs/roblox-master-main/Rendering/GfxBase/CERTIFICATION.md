# CERTIFICATION — Rendering/GfxBase group review

Independent re-verification pass (every source read in full; every concrete doc claim checked against source). Scope: `roblox-sandbox/Rendering/GfxBase/` (41 files) ↔ `docs/roblox-master-main/Rendering/GfxBase/` (41 docs + INDEX). Coverage 1:1 confirmed.

| File | Source | Verdict |
|---|---|---|
| include/GfxBase/Adorn.h | Adorn.h.md | FIXED — "9 rect2d overloads" → **6** (3 color + 3 tex variants; counted in header and Adorn.cpp definitions). All other claims verified (defaults, Material enum, maximumZIndex=10, useFontSmoothScalling [sic], 75%-tall Canvas convention, quotes verbatim). |
| Adorn.cpp | Adorn.cpp.md | FIXED — outline-rect gotcha rewritten: all four bands are fully OUTSIDE the border with pinwheel corner coverage; doc's "left/top inset by thick" was geometrically wrong. Clip-path UV analysis verified. |
| include/GfxBase/AdornSurface.h | AdornSurface.h.md | FIXED — ctor transform is NOT stored on the decorator (no such member); it is pushed once onto the parent adorn. Gotcha corrected. No-op list, getCamera()=0, includes verified. |
| AdornSurface.cpp | AdornSurface.cpp.md | PASS — one-shot parent matrix, y-flips, quad zIndex 0, text bypass — all match source. |
| include/GfxBase/AdornBillboarder.h | AdornBillboarder.h.md | PASS — pass-throughs, throw list, convexPolygon2d implemented w/ alloca, differences vs 2D variant — all verified. |
| AdornBillboarder.cpp | AdornBillboarder.cpp.md | PASS — ctors, conversions, alloca hazard verified. |
| include/GfxBase/AdornBillboarder2D.h | AdornBillboarder2D.h.md | PASS — throw list incl. "Invalid ooperation" typo noted, screenOffset semantics verified. |
| AdornBillboarder2D.cpp | AdornBillboarder2D.cpp.md | PASS. |
| include/GfxBase/ViewportBillboarder.h | ViewportBillboarder.h.md | PASS. |
| ViewportBillboarder.cpp | ViewportBillboarder.cpp.md | PASS — 8-corner bit loop, z∈(0,1000) gate, pixelsPerStud=z, alwaysOnTop-only offset caching, windowSize ignored, 2048-ray occlusion — all verified. |
| include/GfxBase/IAdornable.h | IAdornable.h.md | PASS — hooks/defaults/inverted operator< verified. |
| include/GfxBase/IAdornableCollector.h | IAdornableCollector.h.md | PASS. |
| IAdornableCollector.cpp | IAdornableCollector.cpp.md | PASS — DFFlag stable-remove for 2D bucket only, fastRemove instability, debug-only empty asserts verified. |
| include/GfxBase/GfxPart.h | GfxPart.h.md | PASS. |
| GfxPart.cpp | GfxPart.cpp.md | PASS — dispatch table, Anchored dead branch, child-removed disconnect TODOs, GfxAttachment::unbind skipping base — all verified; 16 includes counted. |
| include/GfxBase/ViewBase.h | ViewBase.h.md | PASS. |
| ViewBase.cpp | ViewBase.cpp.md | PASS — 6-slot registry, stub (0,0), externs verified. |
| include/GfxBase/FrameRateManager.h | FrameRateManager.h.md | PASS — incl. GetAvarageQuality [sic], ≥1000ms frame skip. |
| FrameRateManager.cpp | FrameRateManager.cpp.md | PASS — both 22-row tables spot-verified row-by-row (L20 ssaoFullBlank StepHill 6, L21 ssaoFull 2/2 & 14/25), mQualityDelayUp init to LockStepDelayDown gotcha verified at line 160, fast-backoff level−1 indexing hazard analysis correct, /22 particle throttle note correct, GA >100 samples, StepHill runtime mutation of static tables. |
| include/GfxBase/RenderSettings.h | RenderSettings.h.md | FIXED — resolved UNKNOWN: `CRenderSettings::setGraphicsMode` is declared but never defined on the base class anywhere; sole implementation is subclass `CRenderSettingsItem::setGraphicsMode` (ClientBase/RenderSettingsItem.cpp:222, derives from CRenderSettings) — plain-base calls fail at link time. minGameWindowSize (816,638), hardcoded 300/30, KB-comment-vs-32MB caches verified. |
| RenderSettings.cpp | RenderSettings.cpp.md | PASS — 18-entry table exact, ctor defaults exact. |
| include/GfxBase/RenderCaps.h + RenderCaps.cpp | .md ×2 | PASS ×2. |
| include/GfxBase/RenderStats.h | RenderStats.h.md | PASS — correctly says 16 profilers. |
| RenderStats.cpp | RenderStats.cpp.md | FIXED — "15 CodeProfilers" → **16** (ctor has 16 initializers); member name `adorn2d` → `adorn2D`. |
| include/GfxBase/FileMeshData.h | FileMeshData.h.md | PASS — MeshContentProvider.cpp:22 call site verified exactly. |
| FileMeshData.cpp | FileMeshData.cpp.md | PASS — v1.00 scaler 0.5f confirmed (line 305), tv flip, stride checks, index validation, position-only hash dedup, WriteFileMesh UB on empty vectors. |
| include/GfxBase/MeshFileStructs.h | MeshFileStructs.h.md | PASS. |
| include/GfxBase/MeshGen.h | MeshGen.h.md | PASS — AdornRender.cpp:527 and sole-subclass CircleRadialNormal (DrawAdorn.cpp:913) re-proven by grep. |
| include/GfxBase/Image.h | Image.h.md | PASS — TextureContentProvider.h include verified. |
| include/GfxBase/Type.h | Type.h.md | PASS — enums exact; TextService/VisualEngine/Adorn.h refs spot-checked at cited lines. |
| include/GfxBase/Typesetter.h | Typesetter.h.md | PASS. |
| include/GfxBase/TextureProxyBase.h | TextureProxyBase.h.md | PASS. |
| include/GfxBase/AsyncResult.h | AsyncResult.h.md | PASS — fold logic matches switch exactly. |
| include/GfxBase/Part.h | Part.h.md | PASS — stale "alpha order" comment gotcha confirmed. |
| include/GfxBase/PartIdentifier.h + PartIdentifier.cpp | .md ×2 | PASS ×2 — name scan, first-wins clothing, compositing ladder incl. 0.015 threshold, scales table. |
| GfxBase.vcxproj | GfxBase.vcxproj.md | FIXED — cleaned editing artifact in ClInclude bullet (21 headers; omits AsyncResult.h + PartIdentifier.h vs CMake's 23 — facts were right, prose wasn't). GUID/RootNamespace/RenderLibBase.lib/config matrix/defines/NoOpt _CRASH_RBXASSERT profile all verified against file. |
| GfxBase.vcxproj.filters | GfxBase.vcxproj.filters.md | PASS — 14+21 mappings, 125 lines, BOM, Resource Files empty. |
| GfxBase.xcodeproj/project.pbxproj | project.pbxproj.md | FIXED — HEADER_SEARCH_PATHS qualified: ../../Log/include + SDL2 appear in project-level AND iOS-target rows, absent only from macOS target-level overrides. "(null)" corrupt PBXBuildFile (1F2845EA) re-verified in iOS Headers phase; 14-cpp Sources phases counted; RBXG3D casing, -v flag, defines verified. |
| INDEX.md | — | FIXED — RenderStats row "News 15 profilers" → 16; four roster rows pointed at literal "pre-existing" instead of their existing doc links (FileMeshData.h, MeshGen.h, Image.h, Type.h) — links restored. Roster complete at 41 files; line counts consistent within trailing-newline tolerance (Type.h 13 wc vs 14 editor). |

**Totals**: 42 docs reviewed — 8 FIXED, 34 PASS, 0 FAIL.
