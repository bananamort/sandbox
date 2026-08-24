# boostlibs/boost.static.vcxproj

## Purpose

Builds the handful of Boost libraries that ship compiled sources as ONE static library, GUID `{5423BFB6-D3EB-4B00-A82B-38001EB8745F}` (RootNamespace misleadingly `boostfile_system`). This is how the engine avoids prebuilt boost .lib binaries: header-only boost parts are consumed straight from `Library/boost/include`, and only these translation units are ever compiled. Configurations: Debug/Release × Win32/Durango, StaticLibrary, v143, WinSDK 10.0.

## What it compiles (vendored Boost 1.74 tree under `../Library/boost/libs` — `BOOST_LIB_VERSION "1_74"` per Library/boost/include/boost/version.hpp:30; the `boost_1_56_0` strings in the .filters sibling are stale display noise, not the vendored version)

- **chrono**: `chrono.cpp`, `process_cpu_clocks.cpp`, `thread_clock.cpp`
- **filesystem** (v3): codecvt_error_category, operations, path, path_traits, portability, unique_path, utf8_codecvt_facet, windows_file_codecvt
- **iostreams**: file_descriptor, gzip, zlib (+`mapped_file.cpp` **excluded on Durango**)
- **system**: `error_code.cpp`
- **thread** (win32 backend): thread.cpp, tss_dll.cpp, tss_pe.cpp, tss_null.cpp, future.cpp
- **cpp-netlib** (0.11-era): just the URI parser `libs/network/src/uri/uri.cpp`

Headers listed for IntelliSense: `windows_file_codecvt.hpp`, `boost/thread/win32/thread_primitives.hpp`.

## Settings that matter downstream

- Includes: `..\Library\boost\include;..\Library\zlib\include\zlib;..\Library\cpp-netlib` — so consumers of this lib must add the same include dirs (or rely on Common.props).
- Defines: `ZLIB_WINAPI` always; Durango adds `RBX_PLATFORM_WIN_DURANGO` and `BOOST_CXX11_NO_DELETED_FUNCTIONS` in both configs plus `_CRT_SECURE_NO_WARNINGS` in Release|Durango only; Release adds `/D "_SECURE_SCL=0"`; SSE2 (Win32) / AVX (Durango); MultiThreaded{Debug}DLL runtime — matches the rest of the solution. All configs also pin `_WIN32_WINNT=0x0501` / `NTDDI_VERSION=0x05010100`.
- OutDir/IntDir: `bin|obj\$(Configuration)\$(ProjectName)\` on Win32.

## Usage

Referenced by engine projects that need boost.filesystem/thread/iostreams gzip/zlib etc.; because everything lands in one static lib, link-order/duplicate-symbol risk is centralized here. The zlib symbols come from the separate `Library/zlib` import at link time of final binaries (this project only compiles iostreams' zlib.cpp wrappers).

## Gotchas

- `.filters` sibling references a nonexistent `$(CONTRIB_PATH)\boost_1_56_0` layout — display noise only (see its doc).
- Release|Durango sets CharacterSet Unicode while every other config is MultiByte — inherited upstream inconsistency, no effect on these C++ sources.
- No warnings-as-errors, no PCH; minimal-rebuild on Debug.
