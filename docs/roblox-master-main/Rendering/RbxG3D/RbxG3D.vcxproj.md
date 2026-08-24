# RbxG3D/RbxG3D.vcxproj

## Purpose

MSBuild project compiling the three RbxG3D translation units (`Frustum.cpp`, `RbxCamera.cpp`, `RbxRay.cpp`) into a static library. GUID `{7D55BDAB-C90B-4B36-9B2C-AF8EF3E9129F}`, RootNamespace `RenderLib`; output is literally named **RenderLib.lib** (`<TargetName>RenderLib</TargetName>` on Durango; `<Lib><OutputFile>$(OutDir)RenderLib.lib` on Win32) despite the project being called RbxG3D. Configurations: Debug/Release × Win32/Durango, `StaticLibrary`, PlatformToolset v143, WindowsTargetPlatformVersion 10.0, CharacterSet MultiByte in all four.

## API

N/A (project file). Key facts:

- **Sources** (ClCompile): `Frustum.cpp`, `RbxCamera.cpp`, `RbxRay.cpp`. **Headers** (ClInclude): `include\RbxG3D\{Frustum,RbxCamera,RbxRay}.h` — note **RbxTime.h is absent** from this project even though it sits in the same include dir.
- **Includes**: `.\include;..\..\Base\include;..\RbxG3D\include;..\GfxBase;..\GfxBase\include;..\RenderLibNew\include;..\G3D\png;..\g3d\include;..\..\Library\zlib\include;..\..\Library\boost\include;..\..\TBB_4_1\include;..\..\app\include;..\..\Rendering\AppDraw;..\..\Rendering\AppDraw\include;..\..\log\include` plus `..\..\Library\SDK\include` on Win32 only — except Release|Durango, which also drops `..\..\TBB_4_1\include`.
- **Defines**: `WIN32;_DEBUG|NDEBUG;_LIB` (+ `RBX_PLATFORM_DURANGO` on Durango); Release adds `/D "_SECURE_SCL=0"` via AdditionalOptions.
- ISA: SSE2 on Win32, AVX on Durango; FloatingPointModel Fast everywhere; MultiThreaded{Debug}DLL runtime.
- Durango configs carry the usual Xbox `Console_Sdk*` path overrides and output to `bin\$(Configuration)$(Platform)\` (Win32 uses `bin\$(Configuration)\`).
- All four configs import the legacy `Microsoft.CPP.UpgradeFromVC71.props` sheet.

## Usage

Referenced by `Roblox.sln`; renderer modules (GfxRender, GfxBase consumers) link RenderLib.lib for the camera/ray/frustum math. Include paths show it compiles against GfxBase, AppDraw, Base, g3d and App headers even though its own sources don't obviously need them all — inherited from a shared property template.

## Gotchas

- Name mismatch: project RbxG3D → artifact RenderLib.lib; searching the tree for "RbxG3D.lib" finds nothing because that file is never produced.
- Include list references `..\RenderLibNew\include` and `..\..\TBB_4_1\include` — sibling trees that may not exist in pruned checkouts; harmless unless something actually includes their headers.
- Perforce SCC blocks are stale placeholders (`SAK`).
- No warnings-as-errors (`TreatWarningAsError false`) unlike the Mac target of the same code.
