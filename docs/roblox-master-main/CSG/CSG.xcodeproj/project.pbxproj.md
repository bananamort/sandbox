# CSG.xcodeproj/project.pbxproj

## Purpose

Xcode project (objectVersion 46, `compatibilityVersion = "Xcode 3.2"`, `LastUpgradeCheck = 0510` ≈ Xcode 5) that builds the macOS/i386 static library `libCSG.a` from exactly one translation unit: `CSGKernel.cpp`. It is the Mac counterpart of `CSG.vcxproj`; same sources, same vendored-sgCore dependency model.

## API

N/A (project file). Key facts:

- **Target**: single `PBXNativeTarget` named `CSG`, `productType = "com.apple.product-type.library.static"`, product `libCSG.a`. Build phases: Sources (`CSGKernel.cpp`), Headers (`CSGKernel.h`), Frameworks (**empty** — no system frameworks linked).
- **Configurations**: project-level and target-level each have Debug / Release / NoOpt (NoOpt GUIDs prefixed `D0D04FC7…`, added later than the original `C8C1B6…` set).
- **Project-level settings** (all three configs): `CLANG_CXX_LANGUAGE_STANDARD = gnu++0x`, `CLANG_CXX_LIBRARY = libc++`, `SDKROOT = macosx`, `MACOSX_DEPLOYMENT_TARGET = 10.9`. Debug adds `GCC_OPTIMIZATION_LEVEL = 0`, `DEBUG=1`, `_DEBUG=1`, `ONLY_ACTIVE_ARCH = YES`; Release sets `COPY_PHASE_STRIP = YES`, `DEBUG_INFORMATION_FORMAT = dwarf-with-dsym`, `NDEBUG=1`; NoOpt combines optimization-level 0 with `NDEBUG=1` and `_NOOPT=1`.
- **Target-level settings** (override project): `ARCHS = i386`, `MACOSX_DEPLOYMENT_TARGET = 10.6`, `GCC_PREPROCESSOR_DEFINITIONS = $(inherited) RBX_PLATFORM_MAC`, `EXECUTABLE_PREFIX = lib`, `GCC_SYMBOLS_PRIVATE_EXTERN = YES`, `GCC_INLINES_ARE_PRIVATE_EXTERN = YES`, modules and ARC **disabled**.
- **HEADER_SEARCH_PATHS**: `../Rendering/g3d/include`, `../Rendering/RbxG3D/include`, `../Rendering/g3d/zlib`, `"$(CONTRIB_PATH)/boost_1_55_0/include"`, `../App/include`, `./sgCore`, `../Log/include`, `../Base/include`.

## Usage

Built only by developers on macOS producing the i386 `libCSG.a` consumed by a Mac engine link. The Windows CI/build path (`Roblox.sln` → `CSG.vcxproj`) never reads this file. Header search paths mirror the vcxproj's include list except Boost: here it comes from an external `$(CONTRIB_PATH)/boost_1_55_0` checkout rather than an in-tree copy.

## Gotchas

- **i386-only** (`ARCHS = i386`, no x86_64 arm64) — cannot build on current Xcode without architecture changes; effectively dead tooling kept for history.
- Deployment-target split: 10.9 at project level vs 10.6 at target level; the target value wins for compiled code, which is why the older number matters.
- ARC and modules are ON in the project configs but explicitly OFF in the target configs — the target wins, so C++/Objective-C mixing assumptions at project level are inert.
- Boost dependency is resolved outside the repo via `CONTRIB_PATH`; building this project requires that environment variable to point at a boost_1_55_0 checkout.
- `ORGANIZATIONNAME = "___FULLUSERNAME___"` — unexpanded template placeholder left by whoever created the project.
- `CSGKernel.h` is typed `sourcecode.c.h` (cosmetic Xcode-5-era artifact).
