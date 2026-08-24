# GfxBase.xcodeproj/project.pbxproj

Source: `roblox-sandbox/Rendering/GfxBase/GfxBase.xcodeproj/project.pbxproj` (729 lines)

## Purpose

Xcode project (objectVersion 46, compatibility Xcode 3.2) building GfxBase as TWO static libraries: `libGfxBase.a` (macOS i386) and `libGfxBaseiOS.a` (iOS armv7/arm64). Debug/Release/NoOpt configs at project AND target level.

## API

- Targets: `GfxBase` → libGfxBase.a; `GfxBase iOS` → libGfxBaseiOS.a (`RBX_PLATFORM_IOS` defined on iOS rows, IPHONEOS_DEPLOYMENT_TARGET 5.1.1, SKIP_INSTALL YES).
- Sources phase (both targets): the same 14 .cpp — AdornBillboarder, AdornSurface, FrameRateManager, PartIdentifier, Adorn, ViewportBillboarder, GfxPart, IAdornableCollector, RenderCaps, AdornBillboarder2D, RenderSettings, RenderStats, ViewBase, FileMeshData.
- Headers phases: ~20-21 headers each; the iOS list contains a corrupt entry `1F2845EA15E6FF2900120D64 /* (null) in Headers */` with NO fileRef — a broken PBXBuildFile.
- Header search paths: include, ../../App/include, ../../Base/include, ../AppDraw/include, ../G3D/include, **../RBXG3D/include** (capital RBX — actual dir is RbxG3D), $(CONTRIB_PATH)/boost_1_55_0/include, ../../App.BulletPhysics; `../../Log/include` and `$(CONTRIB_PATH)/SDL2.0.4/include` appear in the three project-level rows AND all three iOS-target rows but are absent from the macOS **target-level** Debug/Release/NoOpt overrides.
- macOS target settings: ARCHS=i386, SDK macosx10.8, deployment 10.6, gnu99, warnings-as-errors ON, OTHER_CPLUSPLUSFLAGS "-v" (!), Debug defines _DEBUG=1/DEBUG=1, Release NDEBUG=1 + dead-code-strip, NoOpt NDEBUG=1+_NOOPT=1. ONLY_ACTIVE_ARCH=YES.
- Groups: Source/Documentation(empty)/Products.

## Usage

Legacy Mac/iOS build path; Windows CI uses GfxBase.vcxproj instead. Same compile set as vcxproj/CMakeLists.

## Gotchas
- `(null) in Headers` orphan build-file entry in iOS target — harmless to builds but breaks strict parsers.
- `../RBXG3D/include` case-mismatch vs real directory name (RbxG3D) — works only on case-insensitive FS.
- `-v` in OTHER_CPLUSPLUSFLAGS makes clang VERBOSE on every file — debug leftover shipped in Release too.
- boost pinned to CONTRIB boost_1_55_0 (vs Library/boost elsewhere); Log/include path again points at pruned tree.
