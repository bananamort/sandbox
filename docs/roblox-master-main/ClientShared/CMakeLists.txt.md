# CMakeLists.txt

Source: `roblox-sandbox/ClientShared/CMakeLists.txt` (30 lines)

## Purpose

IDE-organizational build metadata for the ClientShared directory. It appends 16 headers and 10 sources into two lists and registers them on a CMake custom target that is never compiled — the trailing comment states it plainly: "Will not be built, but it will list all project files in the IDE." Actual compilation of ClientShared code happens inside other projects (App, WindowsClient, RCCService) that pull these files by relative include path.

## API

CMake, no functions:

```cmake
list(APPEND HEADERS rapidjson/{prettywriter,stringbuffer,reader,rapidjson,writer,document}.h
                    rapidjson/internal/{stack,pow10,strfunc}.h rapidjson/filestream.h
                    format_string.h SimpleJSON.h CountersClient.h CookiesEngine.h
                    StringConv.h RobloxServicesTools.h)
list(APPEND SOURCES format_string.cpp Win/CookiesEngine.cpp RobloxServicesTools.cpp
                    CountersClient.cpp Mobile/CookiesEngine.cpp DataModelSerialize.cpp
                    StringConv.cpp DataModelEmptySerialize.cpp SimpleJSON.cpp
                    Mac/CookiesEngine.cpp)
add_custom_target(ClientShared_unbuilt SOURCES ${SOURCES} ${HEADERS})
```

## Usage

No other file consumes this target; it exists so ClientShared sources appear in CMake-generating IDEs (Qt Creator, CLion, Xcode via cmake). The real build wiring lives in per-project vcxproj/xcodeproj files — e.g. WindowsClient.vcxproj compiles SDLGameController.cpp and App.vcxproj lists ClientShared headers as `ClInclude` items.

## Gotchas

- The lists are incomplete and partially stale: `InfluxDbHelper.h`/`InfluxDbHelper.cpp` and `SDLGameController.h`/`SDLGameController.cpp` are absent entirely despite being first-party files in this directory (they get compiled via other projects' file lists instead).
- Platform CookiesEngine selection is fake here: Win/, Mac/, AND Mobile/ variants are all listed together; real builds pick exactly one.
- Editing this file changes nothing about compilation — do not "fix" a missing source here expecting link errors to disappear.
