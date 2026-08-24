# CERTIFICATION — Rendering/AppDraw group review

Independent re-verification pass (every source read in full; every concrete doc claim checked against source). Scope: `roblox-sandbox/Rendering/AppDraw/` (13 files) ↔ `docs/roblox-master-main/Rendering/AppDraw/` (13 docs + INDEX). Coverage 1:1 confirmed.

| File | Source | Verdict | Notes |
|---|---|---|---|
| Draw.cpp | Draw.cpp.md | PASS | All verified: static color values, 1500·thickness LOD switch, 12 edge-box corner compensation, orange non-normal path, selectionSquare dead-declaration claim re-verified by grep. |
| DrawAdorn.cpp | DrawAdorn.cpp.md | PASS | All constants (400/8 base grid, handle angles/radii, transparency 0.65/0.28, torus 32×8), usedaxes dedup, +0.08 highlight radius, todo-marked pointer extension, no-default switch hazard — all match source. |
| HitTest.cpp | HitTest.cpp.md | FIXED | Usage corrected: includes list completed (AdvRotateTool.cpp and App/util/HitTest.cpp also include it); HandleHitTest header path corrected to `App/include/util/HitTest.h`. Sole-call-site claim (PartInstance.cpp:1286, gridToReal=1.0) re-verified by grep. |
| include/appdraw/Draw.h | Draw.h.md | PASS | Dead `frameBox`+`selectionSquare` claims re-verified by tree-wide grep (declaration-only); caller list matches grep exactly; vcxproj case-mismatch gotcha verified (vcxproj lists include\AppDraw\Draw.h). |
| include/appdraw/DrawAdorn.h | DrawAdorn.h.md | PASS | All defaults (cap=true, partSurface orange/0.2, star white/1.0, fontSize=18, cornflowerblue highlight), private statics, magicParam naming, appDraw casing — verified. |
| include/appdraw/DrawPrimitives.h | DrawPrimitives.h.md | PASS | "Zero definitions / zero call sites / 11 include sites" all re-verified by grep; listed TU set matches exactly. |
| include/appdraw/HandleType.h | HandleType.h.md | FIXED | Gotcha corrected: three casings exist tree-wide (`AppDraw/` majority ×8, `appDraw/` in DrawAdorn.h, `appdraw/` in util/HitTest.h) — doc previously listed only two. |
| ReadMe.txt | ReadMe.txt.md | PASS | Boilerplate stub accurately described. |
| CMakeLists.txt | CMakeLists.txt.md | PASS | OBJECT library, 4 include dirs, 5 headers + 3 sources — exact. |
| AppDraw.vcxproj | AppDraw.vcxproj.md | FIXED | Enriched include-dir gotcha with exact asymmetry: SDL2 dropped from 3 of 4 Durango configs; Release\|Durango additionally drops TBB_4_1. All other facts (GUID, config matrix, defines incl. NoOpt's __NEW_GRAPHICS__-only oddity, property-sheet split, MinimalRebuild Debug-only) verified. |
| AppDraw.vcxproj.filters | AppDraw.vcxproj.filters.md | PASS | 3 cpps / 5 headers mixed-case / Text item — verified. |
| AppDraw.xcodeproj/project.pbxproj | project.pbxproj.md | PASS | Dual-target (macOS i386 libAppDraw.a @ SDK 10.8/depl 10.6; iOS armv7/arm64 libAppDrawiOS.a @ 5.1.1, RBX_PLATFORM_IOS), RBXG3D legacy path name, warnings-as-errors, -v flag, NoOpt NDEBUG+_NOOPT — all verified against source. |
| INDEX.md | — | FIXED | Roster line for DrawPrimitives.h claimed impl "lives outside this dir" — refuted: no definition exists anywhere in-tree; corrected. Line counts verified (394/43 wc-newline counts for the two XMLs vs editor-count 395/44 = trailing-newline convention, not an error). |

**Totals**: 14 docs reviewed — 4 FIXED, 10 PASS, 0 FAIL.
