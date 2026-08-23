# boostlibs/ — Module Index

## Module purpose

A one-project directory: `boost.static.vcxproj` compiles the only Boost libraries in the tree that ship compiled sources (chrono, filesystem v3, iostreams' file/gzip/zlib wrappers, system, thread win32 backend, plus cpp-netlib's URI parser) into a **single static library**, GUID `{5423BFB6-D3EB-4B00-A82B-38001EB8745F}`. All other Boost usage is header-only, consumed directly from `../Library/boost/include`. This is the engine's substitute for prebuilt `libboost_*` binaries — the solution links zero standalone boost libs; consumers link this one `.lib`.

Configurations: Debug/Release × Win32/Durango, StaticLibrary, PlatformToolset v143 (retargeted), WindowsTargetPlatformVersion 10.0.

## File roster

| File | Lines | Doc | One-line summary |
|---|---|---|---|
| boost.static.vcxproj | 199 | [boost.static.vcxproj.md](boost.static.vcxproj.md) | Builds 22 boost .cpp + 1 cpp-netlib .cpp into one static lib; includes `../Library/boost/include`, zlib, cpp-netlib. |
| boost.static.vcxproj.filters | ~30 | [boost.static.vcxproj.filters.md](boost.static.vcxproj.filters.md) | Display-only filter metadata; stale `$(CONTRIB_PATH)/boost_1_56_0` paths. |

REMAINING: none — both files in the directory are documented.

## Cross-references

- Source trees compiled: `../Library/boost/libs/{chrono,filesystem,iostreams,system,thread}` and `../Library/cpp-netlib/libs/network/src/uri/uri.cpp` — these live under `Library/`, not here.
- CI note (workstream 3): because this project compiles boost sources directly and headers are already vendored in-tree, no b2/Boost-build step is needed anywhere in the pipeline.
