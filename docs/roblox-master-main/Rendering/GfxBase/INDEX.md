# Rendering/GfxBase/ — Module Index

## Module purpose

Renderer-agnostic base layer for the render engine: the `Adorn` 2D/3D overlay-drawing interface and its decorators (`AdornSurface`, `AdornBillboarder`, `AdornBillboarder2D`), the billboard placement machinery (`ViewportBillboarder`), the data-model↔graphics binding contract (`GfxBinding`/`GfxPart`/`GfxAttachment`), adornable registration (`IAdornable`/`IAdornableCollector`), render configuration (`CRenderSettings`, `RenderCaps`), the adaptive-quality controller (`FrameRateManager` + its lockstep tables), view abstraction (`ViewBase` factory), mesh-file parsing (`FileMeshData`, `MeshFileStructs`), text layout interface (`Typesetter`), stats (`RenderStats`) and part-value structs (`Part`, `PartType`). No graphics API appears anywhere in this directory — backends live in GfxCore/RenderView.

Builds as static lib **RenderLibBase.lib** (vcxproj, Win32/Durango), OBJECT lib (CMake), or libGfxBase.a / libGfxBaseiOS.a (Xcode).

## File roster

| File | Lines | Doc | One-line summary |
|---|---|---|---|
| include/GfxBase/Adorn.h | 341 | [Adorn.h.md](include/GfxBase/Adorn.h.md) | THE overlay-drawing interface: lines/rects/text/boxes/spheres/quads/extrusions + Canvas, Material enum, userGuiInset hack. |
| Adorn.cpp | 105 | [Adorn.cpp.md](Adorn.cpp.md) | rect2d overload family (rotation/software-clip UV math) + outlineRect2d from 4 rects; drawFont2D forward. |
| include/GfxBase/AdornSurface.h | 56 | [AdornSurface.h.md](include/GfxBase/AdornSurface.h.md) | Decorator drawing 2D onto a world-plane; all direct 3D prims stubbed no-op; getCamera() returns 0. |
| AdornSurface.cpp | 67 | [AdornSurface.cpp.md](AdornSurface.cpp.md) | line2d→line3d / rect→quad via parent matrix set once in ctor (never restored); y-flip UI→math. |
| include/GfxBase/AdornBillboarder.h | 186 | [AdornBillboarder.h.md](include/GfxBase/AdornBillboarder.h.md) | Billboard decorator: 2D re-projected to plane, direct 3D throws; ViewportBillboarder-taking ctor. |
| AdornBillboarder.cpp | 75 | [AdornBillboarder.cpp.md](AdornBillboarder.cpp.md) | Ctor applies billboard cframe to parent; line2d/rect2dImpl/convexPolygon2d conversions (alloca!). |
| include/GfxBase/AdornBillboarder2D.h | 185 | [AdornBillboarder2D.h.md](include/GfxBase/AdornBillboarder2D.h.md) | Strict-2D decorator: every 3D primitive THROWS runtime_error; screenOffset applied to line/rect only. |
| AdornBillboarder2D.cpp | 29 | [AdornBillboarder2D.cpp.md](AdornBillboarder2D.cpp.md) | Offset-forwarding of line2d/rect2dImpl to parent; viewport passthrough. |
| include/GfxBase/ViewportBillboarder.h | 58 | [ViewportBillboarder.h.md](ViewportBillboarder.h.md) | Billboard GUI screen-rect tracker: extents-relative+studs offset, UDim2 sizing, hitTest API. |
| ViewportBillboarder.cpp | 152 | [ViewportBillboarder.cpp.md](ViewportBillboarder.cpp.md) | 8-corner camera-space extents, z∈(0,1000) visibility gate, pixelsPerStud math, occlusion-aware hitTest. |
| include/GfxBase/IAdornable.h | 71 | [IAdornable.h.md](include/GfxBase/IAdornable.h.md) | Interface for drawable Instances: 3 index buckets, shouldRender* gates, render hooks; AdornableDepth far-first sort record. |
| include/GfxBase/IAdornableCollector.h | 37 | [IAdornableCollector.h.md](include/GfxBase/IAdornableCollector.h.md) | Owner of three IndexArrays of IAdornables; render2dItems/render3dAdornItems/append3dSortedAdornItems. LOGGROUP(AdornRenderStats). |
| IAdornableCollector.cpp | 169 | [IAdornableCollector.cpp.md](IAdornableCollector.cpp.md) | Bucket add/remove/recompute lifecycle; fastRemove swap-order instability + DFFlag DontReorderScreenGuisWhenDescendantRemoving stable path; defines IAdornable dtor/calculateDepth. DYNAMIC_FASTFLAGVARIABLE here. |
| include/GfxBase/GfxPart.h | 121 | [GfxPart.h.md](include/GfxBase/GfxPart.h.md) | GfxBinding event-binding base (+zombify two-phase teardown), GfxPart (=binding+spatial hash), GfxAttachment. |
| GfxPart.cpp | 313 | [GfxPart.cpp.md](GfxPart.cpp.md) | combinedSignal fan-out: property descriptor dispatch table, child mesh/decal subscription, cookie refresh; child-removed disconnect TODO leaks connections. |
| include/GfxBase/ViewBase.h | 116 | [ViewBase.h.md](include/GfxBase/ViewBase.h.md) | Abstract render-view: OSContext, IViewBaseFactory, export enums, ~25 virtuals incl VR/thumb/export JSON. |
| ViewBase.cpp | 81 | [ViewBase.cpp.md](ViewBase.cpp.md) | Static 6-slot factory registry keyed by GraphicsMode; InitPluginModules → RenderView_InitModule externs; setFrameDataCallback stub (0,0). |
| include/GfxBase/FrameRateManager.h | 201 | [FrameRateManager.h.md](include/GfxBase/FrameRateManager.h.md) | Adaptive-quality controller decl: SSAOLevel enum, Metrics, WindowAverages, AvgFpsCounter, quality knobs getters. |
| FrameRateManager.cpp | 743 | [FrameRateManager.cpp.md](FrameRateManager.cpp.md) | 60/30 FPS lockstep tables L0–L21 (SSAO at 20/21, StepHill mutation), hysteresis step machine, fast-backoff, GA quality reporting. |
| include/GfxBase/RenderSettings.h | 200 | [RenderSettings.h.md](include/GfxBase/RenderSettings.h.md) | CRenderSettings enums: GraphicsMode(D3D11/D3D9/GL/None), AASamples, QualityLevel 1–21, ResolutionPreset; hardcoded 300/30 fps bounds. |
| RenderSettings.cpp | 72 | [RenderSettings.cpp.md](RenderSettings.cpp.md) | Defaults ctor (800×600 failsafe, 32MB caches), 18-entry ResolutionTable, latchedGraphicsMode/aaSamples statics. |
| include/GfxBase/RenderCaps.h | 32 | [RenderCaps.h.md](include/GfxBase/RenderCaps.h.md) | GPU capability value class: vidMem, card name, NPOT-only, GBuffer, skinningBoneCount. |
| RenderCaps.cpp | 15 | [RenderCaps.cpp.md](RenderCaps.cpp.md) | Ctor defaults: NPOT allowed(false flag), GBuffer off, bones 0 — backends must probe+set. |
| include/GfxBase/RenderStats.h | 101 | [RenderStats.h.md](include/GfxBase/RenderStats.h.md) | RenderPassStats/ClusterStats aggregates + 16 scoped_ptr CodeProfiler slots per pipeline stage. |
| RenderStats.cpp | 34 | [RenderStats.cpp.md](RenderStats.cpp.md) | News 15 named profilers ("3D CPU Total" etc.), never frees them (process-lifetime by design). |
| include/GfxBase/FileMeshData.h | 24 | pre-existing | FileMeshData struct + ReadFileMesh/WriteFileMesh/computeAABB/optimizeMesh decls. |
| FileMeshData.cpp | 333 | [FileMeshData.cpp.md](FileMeshData.cpp.md) | Mesh parser v1.00(×0.5 scale!)/1.01/v2.00 binary, hand-rolled atofFast/atouFast, vertex dedup hash-on-position, index validation. |
| include/GfxBase/MeshFileStructs.h | 36 | [MeshFileStructs.h.md](include/GfxBase/MeshFileStructs.h.md) | pack(1) on-disk structs FileMeshHeader/FileMeshVertexNormalTexture3d/FileMeshFace; append-only compat contract. |
| include/GfxBase/MeshGen.h | 18 | pre-existing | Mesh generation entry decl. |
| include/GfxBase/Image.h | 20 | pre-existing | Image helper decl. |
| include/GfxBase/Type.h | 13 | pre-existing | Text::Font/XAlign/YAlign enums used across adorn text APIs. |
| include/GfxBase/Typesetter.h | 85 | [Typesetter.h.md](include/GfxBase/Typesetter.h.md) | Abstract text layout: draw/measure/getCursorPositionInText + glyph-atlas resource lifecycle; ASCII-only charset helpers. |
| include/GfxBase/TextureProxyBase.h | 28 | [TextureProxyBase.h.md](include/GfxBase/TextureProxyBase.h.md) | Minimal texture-proxy base: getOriginalSize() pure virtual, numStrips=32 slicing constants. |
| include/GfxBase/AsyncResult.h | 45 | [AsyncResult.h.md](include/GfxBase/AsyncResult.h.md) | Monotonic Succeeded<Waiting<Failed fold + waitingFor content-id list (header-only, sticky Failed). |
| include/GfxBase/Part.h | 67 | [Part.h.md](include/GfxBase/Part.h.md) | PartType enum (BALL..OPERATION) + plain-value Part record; default ctor leaves members uninitialized. |
| include/GfxBase/PartIdentifier.h | 61 | [PartIdentifier.h.md](include/GfxBase/PartIdentifier.h.md) | HumanoidIdentifier snapshot decl: limbs/clothing/meshes pointers + isBodyPart*/compositing queries + BodyPartType/scales. |
| PartIdentifier.cpp | 230 | [PartIdentifier.cpp.md](PartIdentifier.cpp.md) | Name-string limb scan ("Head"/"Torso"...), clothing first-wins, compositing decision ladder (plastic batching trade-off documented). |
| GfxBase.vcxproj | 406 | [GfxBase.vcxproj.md](GfxBase.vcxproj.md) | StaticLibrary RenderLibBase.lib {857DE167-…}, 8 configs, v143, SSE2/AVX, includes absent ..\..\Log\include. |
| GfxBase.vcxproj.filters | 125 | [GfxBase.vcxproj.filters.md](GfxBase.vcxproj.filters.md) | VS display filters; header list omits AsyncResult.h + PartIdentifier.h like its vcxproj. |
| GfxBase.xcodeproj/project.pbxproj | 729 | [GfxBase.xcodeproj/project.pbxproj.md](GfxBase.xcodeproj/project.pbxproj.md) | Xcode mac-i386 libGfxBase.a + iOS armv7/arm64 libGfxBaseiOS.a; corrupt "(null)" header entry; boost_1_55_0 CONTRIB. |
| CMakeLists.txt | 47 | [CMakeLists.txt.md](CMakeLists.txt.md) | CMake OBJECT library; explicit 23-header + 14-cpp lists; lowercase ../RbxG3d include quirk. |

REMAINING: none — all 41 files under Rendering/GfxBase/ are documented.

## Cross-references

- Consumers: Rendering/AppDraw (draws THROUGH Adorn), Rendering/GfxCore + RenderView (implement Adorn/ViewBase backends), VisualEngine (owns FrameRateManager + RenderStats instances).
- `..\..\Log\include` referenced by vcxproj/pbxproj points into the pruned Log/ project — FastLog.h now lives reconstructed under Base/include (CI workstream note).
