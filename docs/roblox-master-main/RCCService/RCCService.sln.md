# RCCService.sln

Source: `roblox-sandbox/RCCService/RCCService.sln` (165 lines)

## Purpose

Visual Studio 2015 (Format Version 12.00, `# Visual Studio 14`) solution for building RCCService and its full dependency closure. The service project is `{6DD8FDCA-DB72-4886-AF4A-4A85611EDF37}` (`RCCService.vcxproj`).

## API (structure)

Projects referenced (all paths relative to this folder):

| Project | Path | Notes |
| --- | --- | --- |
| RCCService | `RCCService.vcxproj` | the service exe |
| App | `..\App\App.vcxproj` | core engine/data model |
| AppDraw | `..\Rendering\AppDraw\AppDraw.vcxproj` | |
| GLG3D | `..\Rendering\g3d\GLG3D.vcproj` | legacy `.vcproj` format |
| graphics3D | `..\Rendering\g3d\graphics3D.vcxproj` | |
| Network | `..\Network\Network.vcxproj` | |
| RenderLib | `..\Rendering\RenderLib\RenderLib.vcproj` | legacy format |
| RBXGSSetup | `..\..\RBXGS\RBXGSSetup\WebServiceSetup.vdproj` | **setup/deployment project** (type `{54435603-DBB4-11D2-8724-00A0C9A8B90C}`); lives outside `roblox-sandbox/` |
| ContentFonts / ContentSky / ContentTextures | content projects | legacy `.vcproj` |
| RbxViewNew | `..\RbxViewNew\RbxViewNew.vcproj` | |
| RenderLibBase / RenderLibNew | Rendering | |
| RbxGraphics | `..\RbxGraphics\RbxGraphics.vcproj` | |

Configurations: `Debug|Win32`, `NoOpt|Win32`, `Release|Win32`, `ReleaseAssert|Win32`. Mapping quirks:
- App + Network map solution `ReleaseAssert` → project config **`ReleaseRcc`** (the RCC-flavored release; lines 58–59, 90–91) — this is where CI's "ReleaseRcc" name comes from.
- GLG3D, graphics3D, RenderLib, ContentFonts/Sky/Textures have no NoOpt/ReleaseAssert of their own → mapped to plain Release.
- RBXGSSetup uses deployment-config names without platform suffix.

## Usage

Open/build in Visual Studio or msbuild: `msbuild RCCService.sln /p:Configuration=ReleaseRcc` (via solution ReleaseAssert) — matches the repo's CI build invocation.

## Gotchas

- Several dependencies are still old-style `.vcproj`; VS upgrades them on first open.
- `RBXGSSetup.vdproj` path escapes the sandbox root (`..\..\RBXGS\...`) — that subtree is absent here, so building the *whole* solution fails at the setup project; build individual vcxprojs instead.
- All configurations are Win32-only (matches `_WIN32_WINNT` XP targeting and 32-bit PE assumptions in OperationalSecurity.cpp).
