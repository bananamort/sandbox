# AppDraw.xcodeproj/project.pbxproj

## Purpose

Xcode 3.2-format project building AppDraw as a static library on Apple platforms: two native targets — `AppDraw` (macOS, product `libAppDraw.a`, i386, SDK macosx10.8, deployment 10.6) and `AppDraw iOS` (product `libAppDrawiOS.a`, `RBX_PLATFORM_IOS`, deployment 5.1.1, armv7/arm64). Configurations Debug/Release/NoOpt on project + both targets.

## Key facts

- Sources: Draw.cpp, DrawAdorn.cpp, HitTest.cpp; headers from include/appdraw.
- Header search paths reference `$(CONTRIB_PATH)/boost_1_55_0/include`, `$(CONTRIB_PATH)/SDL2.0.4/include` (macOS/iOS only), plus relative engine includes (`../../App/include`, `../RBXG3D/include`, `../GfxBase/include[/GfxBase]`, `../G3D/include`, `../../Log/include`, `../../App.BulletPhysics`). Note the legacy dir name **RBXG3D** (project was later renamed RbxG3D).
- Warnings-as-errors ON (`GCC_TREAT_WARNINGS_AS_ERRORS=YES`); Debug has GCC_ENABLE_FIX_AND_CONTINUE; NoOpt defines NDEBUG+_NOOPT (mac) — mirrors the vcxproj's NoOpt weirdness.

## Gotchas

- i386-only macOS archs: this tree predates the 64-bit Mac client; unusable unmodified today.
- `OTHER_CPLUSPLUSFLAGS = "-v"` (verbose compiler output) left enabled on macOS/iOS targets.
