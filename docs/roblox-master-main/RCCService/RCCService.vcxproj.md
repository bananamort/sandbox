# RCCService.vcxproj

Source: `roblox-sandbox/RCCService/RCCService.vcxproj` (479 lines)

## Purpose

MSBuild project for the **RCCService.exe** Win32 console application. Defines four configurations, the include/library surface, cross-folder compilation units, gSOAP WSDL custom build step, and the runtime DLL payload (Mesa software OpenGL, FMOD, VMProtect SDK).

## API (project model)

- ProjectGuid `{6DD8FDCA-DB72-4886-AF4A-4A85611EDF37}`; ToolsVersion 14.0; `ConfigurationType=Application`, `SubSystem=Console`, `TargetMachine=MachineX86` everywhere.
- Configurations: `Debug|Win32`, `NoOpt|Win32`, `Release|Win32`, `ReleaseTest|Win32`. All currently carry `PlatformToolset v143` + `WindowsTargetPlatformVersion 10.0` (retargeted from v140_xp by `tools/retarget_v143.py`; see workstream history) and `UseOfAtl=Static`, `CharacterSet=MultiByte`, `WholeProgramOptimization=false`.
- Preprocessor defines:
  - Always: `BOOST_THREAD_BUILD_LIB WIN32 _CONSOLE RBX_RCC_SECURITY`
  - Debug adds `_DEBUG`; Release adds `NDEBUG /D _SECURE_SCL=0`; NoOpt adds `NDEBUG _NOOPT /D _SECURE_SCL=0`; **ReleaseTest adds `RBX_TEST_BUILD`** (gates `-Md5:`/`-SettingsKey:` flags and settings-key override).
- Include dirs (all configs): fmod, SDL2, boost, Base/include, `.` (this folder), `gSOAP`, App/include, TBB_4_1, Win, Network/include, Rendering (+AppDraw/GfxBase/RbxG3D/g3d subtrees), RobloxInstall/src, Library/SDK/Include, Log/include, ClientShared, App.BulletPhysics. Release also prepends `..\Library\curl\include\curl`.
- Link libs: `dxerr9.lib zlib[d].lib libcurl[-d].lib fmod_vc.lib legacy_stdio_definitions.lib WS2_32.lib Crypt32.lib Wldap32.lib`. Lib dirs: boost stage, TBB, fmod/win32/lib, **Library/Mesa/lib** (software GL), Library/SDK/Lib, **Library/VMProtect/lib**, zlib/curl per-config. Release/ReleaseTest/NoOpt add `.\libraries` fallback dir, `LargeAddressAware=true`, `RandomizedBaseAddress=true` (Release), `/FORCE:MULTIPLE` via `ForceFileOutput=MultiplyDefinedSymbolOnly`.
- Optimization: Debug/NoOpt `Disabled`; Release/ReleaseTest `MaxSpeed` + intrinsics + `FloatingPointModel=Fast`; Release/ReleaseTest set `BufferSecurityCheck=false`; SSE2 instruction set everywhere.
- Post-build: `"$(SolutionDir)buildshaders.bat"` on Debug/NoOpt/ReleaseTest (not plain Release).
- **Compiled TUs span folders** (`ClCompile`): local `DummyWindow.cpp OperationalSecurity.cpp RCCService.cpp RCCServiceSoapServiceImpl.cpp stdafx.cpp ThumbnailGenerator.cpp` plus `..\App\script\LuaVMServer.cpp`, `..\ClientShared\DataModelSerialize.cpp`, `..\Win\{DumpErrorUploader,ErrorUploader,LogManager,Tracer,VersionInfo,VistaTools}.cpp`, `gSOAP\stdsoap2.cpp`, `gSOAP\generated\soapC.cpp`, `gSOAP\generated\soapRCCServiceSoapService.cpp`.
- Headers enumerated include all 27 `gSOAP/import/*.h` (compile-time visibility only — import headers are used by wsdl2h, not by C++ compiles).
- Custom builds: `RCCService.wsdl` (CustomBuild item → binding generation), `AppSettings.xml` (copied to `$(TargetDir)` every config).
- `PublishDLLDependency` payload: `gameserver.txt`, `..\fmod\win32\fmod.dll`, `VMProtectSDK32.dll`, Mesa `GLU32/OPENGL32/OSMESA32 .dll+.lib+.pdb` (Debug variants only in Debug config; Release variants elsewhere), `RbxDebug.dll/.pdb` (debug-only).
- Project references (build-order graph): App.BulletPhysics, App, Base, boost.static, Log, Network, AppDraw, graphics3D, GfxBase, GfxCore, GfxRender, RbxG3D — most with `ReferenceOutputAssembly=false` (ordering only); BulletPhysics/GfxCore/GfxRender link their outputs.

## Usage

Built directly or through `RCCService.sln`; CI builds the App project's `ReleaseRcc` configuration which shares this dependency graph. Output goes to `$(RCCServiceRootBin)$(Platform)\$(Configuration)\` (macro defined outside the project), intermediates to `obj\<config>\`.

## Gotchas

- **Software-GL dependency**: linking against Mesa's `OPENGL32/GLU32/OSMESA32` is why thumbnails render headless — and why `ThumbnailGenerator.cpp` pins all GL use to one thread.
- `dxerr9.lib` is a legacy DirectX SDK library not shipped with modern VS toolsets — a likely breakage point when building under v143 without the old SDK restored.
- Missing third-party trees in this sandbox drop: `fmod/win32/lib` and `TBB_4_1/` are referenced but absent (known workstream-3 gap); `..\CustomBuildRules.props/.targets` must also exist for the WSDL/AppSettings steps.
- `ReleaseTest` is the only configuration compiling `RBX_TEST_BUILD` code paths despite the solution file exposing no `ReleaseTest` mapping (sln maps its four configs to Debug/NoOpt/Release + ReleaseAssert→other projects' ReleaseRcc).
- `PrecompiledHeader` element is empty (`<PrecompiledHeader />`) — PCH usage actually comes from `stdafx.cpp` defaults; VS treats blank as "not set", inheriting whatever props supply.
- `_ProjectFileVersion` 11.0 leftover (line 83) is inert metadata.
