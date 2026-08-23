# RbxG3D/CMakeLists.txt

## Purpose

CMake build recipe for the RbxG3D math library, used by the non-Windows (Mac/Linux) build path. Declares the module as an **OBJECT library** — its objects are linked directly into whatever consumes it rather than archived into a standalone `.a` first.

## API

N/A (build script). Contents:

- `include(Boost)` and `include(App)` — repo-local CMake helpers (custom modules, not stock FindBoost).
- `include_project_files(RbxG3D "*")` — custom macro that globs the directory's files into the project (repo-specific convention).
- `include_directories(include)` and `include_directories(../g3d/include)` — the only two include roots.
- Explicit `HEADERS`: `include/RbxG3D/{RbxRay,RbxTime,Frustum,RbxCamera}.h`; explicit `SOURCES`: `RbxCamera.cpp`, `Frustum.cpp`, `RbxRay.cpp`.
- `add_library(RbxG3D OBJECT ${SOURCES} ${HEADERS})`.

## Usage

Pulled in by the parent Rendering CMake tree on Mac/Linux builds. Windows CI uses the vcxproj instead; the two lists must be kept in sync by hand.

## Gotchas

- **Includes RbxTime.h in HEADERS** even though that header declares symbols with no definition anywhere (`RbxTime::getTick()` is dead — see RbxTime.h.md). Harmless for an OBJECT lib (headers aren't compiled), but it perpetuates the illusion that RbxTime is live.
- Listing headers in `add_library` sources only matters for IDE generators.
- `include_project_files(... "*")` plus the explicit lists is redundant belt-and-suspenders typical of this tree's CMake style.
