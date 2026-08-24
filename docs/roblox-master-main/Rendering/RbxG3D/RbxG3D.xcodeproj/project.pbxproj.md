# RbxG3D/RbxG3D.xcodeproj/project.pbxproj

## Purpose

Xcode project (objectVersion 46, `compatibilityVersion = "Xcode 3.2"`, `hasScannedForEncodings = 1`, knownRegions English/Japanese/French/German) building the RbxG3D math library on Apple platforms. **Two native targets**, both `com.apple.product-type.library.static`:

- **RbxG3D** → `libRbxG3D.a` — macOS, i386-only (`ARCHS = i386`), target-level `SDKROOT = macosx10.8`, `MACOSX_DEPLOYMENT_TARGET 10.6`, warnings-as-errors ON.
- **RbxG3D iOS** → `libRbxG3DiOS.a` — `SDKROOT = iphoneos`, `IPHONEOS_DEPLOYMENT_TARGET = 5.1.1`, `ARCHS = "$(ARCHS_STANDARD)"` with `VALID_ARCHS = "armv7 arm64"`, defines `RBX_PLATFORM_IOS`.

Each target has Debug/Release/NoOpt configurations (three configuration lists; the NoOpt GUIDs `D0D04F…1C761479` were bolted on later, same vintage as CSG's NoOpt additions).

## API

N/A (project file). Key facts:

- **Sources** (both targets): `RbxCamera.cpp`, `RbxRay.cpp`, `Frustum.cpp`. **Headers**: all four including `RbxTime.h`.
- **HEADER_SEARCH_PATHS** (shared shape): `include`, `../../App/include`, `../../Base/include`, `../AppDraw/include`, `../GfxBase/include`, `../GfxBase/include/GfxBase` (both nested and doubled), `../G3D/include`, `"$(CONTRIB_PATH)/boost_1_55_0/include"`, `"$(CONTRIB_PATH)/GeekInfo/geekinfo-2.1.4/include"`, `../../log/include`, and the odd trailing entry `../../App.BulletPhysics`. (`../../log/include` appears in the three *project-level* configs and all three iOS-target configs but is absent from the macOS **target-level** Debug/Release/NoOpt overrides.)
- Mac target: `_DEBUG=1` / `NDEBUG=1` / NoOpt `NDEBUG=1 + _NOOPT=1`; `GCC_SYMBOLS_PRIVATE_EXTERN = NO`, `STRIP_INSTALLED_PRODUCT = NO`, `DEAD_CODE_STRIPPING = YES` (Release/NoOpt), leftover `OTHER_CPLUSPLUSFLAGS = "-v"` on Debug.
- iOS target: hidden-symbols defaults flipped (`GCC_SYMBOLS_PRIVATE_EXTERN = YES`), per-arch override `"GCC_WARN_64_TO_32_BIT_CONVERSION[arch=*64]" = NO`, `SKIP_INSTALL = YES`.
- Empty Frameworks phases; empty `Documentation` group.

## Usage

Developer-facing Mac/iOS builds only; Windows CI (Roblox.sln) never touches it. The GeekInfo search path corroborates the engine's `HardwareInfo` geekinfo dependency (the same contrib checkout HardwareInfo.cpp includes headers from).

## Gotchas

- i386-only Mac architecture — unbuildable on modern Xcode; kept for history like CSG's xcodeproj.
- Boost comes from an external `$(CONTRIB_PATH)/boost_1_55_0` checkout, not any in-tree copy.
- `../../App.BulletPhysics` as a header search path is a directory-shaped include that only works if a sibling folder of exactly that name exists — fragile copy-paste artifact.
- Warnings-as-errors is set at the Mac target level but not in the vcxproj: the same code has different warning strictness per platform.
