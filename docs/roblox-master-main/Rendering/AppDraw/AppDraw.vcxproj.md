# AppDraw.vcxproj

## Purpose

MSBuild static-library project for AppDraw, GUID `{43AFCF25-5133-4978-8B2C-D02EE0EEE199}`. Configurations: Debug/NoOpt/ReleaseTest/Release × Win32/Durango; StaticLibrary output `AppDraw.lib`; v143 / WinSDK 10.0 (retargeted).

## Key facts

- Sources: Draw.cpp, DrawAdorn.cpp, HitTest.cpp; headers listed under `include\AppDraw\` and `include\appdraw\` (mixed case).
- Includes: `..\..\Library\SDL2\include;..\..\Base\include;..\..\TBB_4_1\include;..\G3D\png;..\g3d\include;.\include;..\g3d\include\zlib;..\GfxBase\include;..\RbxG3D\include;..\..\app\include;..\..\Library\boost\include;..\..\Log\include;..\..\App.BulletPhysics` (SDL2 dropped from three of four Durango variants — kept only in Release|Durango, which instead drops `..\..\TBB_4_1\include`).
- Defines: `_LIB`, `_RELEASE`, `RBX_TEST_BUILD` (Release/ReleaseTest), `RBX_PLATFORM_DURANGO`; **NoOpt defines only `__NEW_GRAPHICS__`** (and NDEBUG on Durango) instead of the usual set — inherited oddity. `/D "_SECURE_SCL=0"` everywhere; SSE2/AVX; MultiThreaded(Dbg)DLL.
- Property sheets: UpgradeFromVC71.props all configs; Common.props only Release/ReleaseTest.
- ReadMe.txt included as a Text item.

## Gotchas

- Release|Win32 sets `_DEBUG`-style MinimalRebuild only in Debug; NoOpt lacks `_NOOPT` define unlike other projects' convention.
- Durango configs reference Xbox `Console_Sdk*` path properties (inert on PC builds).
