# CSG.vcxproj

## Purpose

MSBuild project that compiles `CSGKernel.cpp` into a static library (ConfigurationType `StaticLibrary`), GUID `{9B6C66F7-6887-44D3-AC5E-3C2BD94661FC}`, RootNamespace `Base`. Configurations: Debug/NoOpt/Release × Win32/Durango (Xbox One). Already retargeted to PlatformToolset v143 with WindowsTargetPlatformVersion 10.0.

## API

N/A (project file). Key facts:

- Includes: `..\ClientBase;..\Win;..\Base\include;..\Network;..\Network\include;include;..\Library\boost\include;..\Log\include;..\Rendering\g3d\include;.\sgCore;..\App\include;..\Rendering\RbxG3D\include`.
- Defines: `_LIB` everywhere; `_WIN32_WINNT=0x0501`/`NTDDI_VERSION=0x05010100` in the Debug configs only; `RBX_PLATFORM_DURANGO` on Durango, `/D "_SECURE_SCL=0"` everywhere, `NDEBUG/_RELEASE/_NOOPT` per config.
- SSE2 on Win32; AVX on Durango. FloatingPointModel Fast. Release has BufferSecurityCheck off.
- Imports `..\PropertySheets\Common.props` for NoOpt/Release configs only.
- File list: ClCompile `CSGKernel.cpp`; ClInclude `CSGKernel.h`. Nothing from `sgCore/` is compiled here — the SDK is consumed via headers + import lib linked downstream.

## Usage

Referenced by the master solution; consumers of the CSG factory link the produced `.lib`. Durango paths reference the Xbox `Console_Sdk*` properties (inert on a PC-only build).

## Gotchas

- Debug config lacks the Common.props import the other configs have (asymmetry inherited from upstream).
- Perforce SCC metadata blocks are stale leftovers.
- `_SECURE_SCL=0` is a VS2010-era macro — harmless but meaningless under v143.
