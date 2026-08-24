# GfxBase.vcxproj

Source: `roblox-sandbox/Rendering/GfxBase/GfxBase.vcxproj` (406 lines)

## Purpose

MSBuild project building GfxBase as a **static library** named `RenderLibBase.lib`, GUID `{857DE167-1ED8-4E4D-955A-5CC5CC3944C1}`, RootNamespace `RenderLibBase`. Eight configurations: {Debug, NoOpt, ReleaseTest, Release} × {Win32, Durango(Xbox One)}.

## API

- Configurations: all `StaticLibrary`, `PlatformToolset v143` (retargeted), `WindowsTargetPlatformVersion 10.0`, CharacterSet MultiByte, `_ProjectFileVersion` 11.0.50727.1 (VC71 upgrade sheet imported).
- Durango rows set Console_Sdk paths (`$(Console_SdkRoot)bin`, xdk\fxc, SdkIncludeRoot um/shared/winrt) and output to `bin\$(Configuration)$(Platform)\`; Win32 rows use plain `bin\$(Configuration)\`.
- Includes (all configs): SDL2 include, TBB_4_1\include (×2 on some rows), ..\G3D\png, ..\g3d\include, .\include, ..\..\Base\include, Library zlib + boost include, ..\..\app\include, ..\App\include, ..\GfxBase\include, ..\AppDraw\include, ..\RbxG3D\include, **..\..\Log\include** (FastLog.h home — absent from drop; see CI notes), ..\..\App.BulletPhysics.
- Defines: Debug `WIN32;_DEBUG;_LIB`; Release/ReleaseTest add `NDEBUG;RBX_TEST_BUILD`; NoOpt adds `_CRASH_RBXASSERT;__NEW_GRAPHICS__;NDEBUG;_NOOPT`; Durango adds `RBX_PLATFORM_DURANGO` everywhere.
- ISA: Win32 SSE2; Durango AVX. `/D "_SECURE_SCL=0"` on every config. Release: /AnySuitable inline, Fast FP, BufferSecurityCheck off. Warnings: Level3, not-as-error; Durango disables 4267.
- ClCompile list = the 14 .cpp (Adorn, AdornBillboarder, AdornBillboarder2D, AdornSurface, FileMeshData, FrameRateManager, GfxPart, IAdornableCollector, PartIdentifier, RenderCaps, RenderSettings, RenderStats, ViewBase, ViewportBillboarder).
- ClInclude list = **21 headers** — note it does NOT include AsyncResult.h or PartIdentifier.h... wait, PartIdentifier.cpp is compiled but PartIdentifier.h is absent from ClInclude; also missing vs CMakeLists: AsyncResult.h, PartIdentifier.h.

## Usage

Referenced by Roblox.sln; artifact consumed by RenderView/App links as RenderLibBase.lib.

## Gotchas
- Include path `..\..\Log\include` points at a directory that no longer exists in the pruned tree → FastLog.h had to be RECONSTRUCTED into Base/include for CI (workstream-3 fact).
- Header list drift vs CMakeLists.txt (23 there): vcxproj omits AsyncResult.h and PartIdentifier.h (both still compile fine — headers don't build).
- `_SECURE_SCL=0` is a VS2010-era macro — dead with v143 but harmless.
- NoOpt defines NDEBUG yet _CRASH_RBXASSERT — assert-crash profile without optimization.
