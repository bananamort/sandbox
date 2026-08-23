# RbxG3D/include/RbxG3D/RbxRay.h

## Purpose

Declares `RBX::RbxRay`, Roblox's fork of the old (pre-8.0) G3D `Ray`. Header comment states the point of the fork: this version **does not require unit-length direction vectors** ("It doesn't requires to have unit() vectors… We should fix this and remove the need of these files in the future and use the G3D ones"). It is the ray type used across the engine for picking, mouse→world casting, humanoid ledge checks, and the Lua `Ray` datatype.

## API

State: `Vector3 m_origin`; `Vector3 m_direction` — **not necessarily unit length** (`length()` returns its magnitude).

Inline (header-defined):
- Ctors `(origin, direction)` / default zero; `operator==`, `operator!=`.
- Accessors: `origin()`, `direction()` (const and non-const), `length()`, `unit()`.
- `static fromOriginAndDirection(point, direction)`.
- `closestPoint(point)` — clamps t<0 to the origin; `distance(point)`.
- Triangle intersection, Möller–Trumbore (JGT 97 cite): inline `intersectionTime(vert0..2, edge01, edge02[, w0,w1,w2])` — one-sided (miss when determinant < EPSILON 1e-6 or barycentrics outside); convenience overloads computing edges from vertices and `Triangle` wrappers. Barycentric weights returned via doubles.
- Macros `EPSILON/CROSS/DOT/SUB` are file-local and `#undef`'d at the end.

Declared here, defined in RbxRay.cpp:
- `intersectionPlane(plane)` — hits regardless of which side the ray approaches from (explicitly "modified from G3D").
- `intersectionTime(const Sphere&)`, `(const Plane&)`, `(const Box&)`, `(const AABox&)`.
- `refract(newOrigin, normal, iInside, iOutside)`, `reflect(newOrigin, normal)`.

## Lua globals and events

This C++ class backs the Lua **`Ray`** datatype: `App/script/LuaAtomicClasses.cpp:196` pushes `RBX::RbxRay::fromOriginAndDirection(origin, direction)` for `Ray.new(origin, direction)`. All Lua-facing behavior (Unit, ClosestPoint, FindPartOnRay machinery upstream) rides on this class.

## Usage (who loads it)

Pervasive: mouse picking (`MouseCommand.cpp`, `ViewportBillboarder.cpp:128–129`, `BillboardGui.cpp:115`), tools (`RunDragger/AdvRunDragger/ResizeTool/AxisMoveTool/MoveResizeJoinTool/HandlesBase`), humanoid ground/ledge probes (`HumanoidState.cpp:1337,1741`, `Jumping.cpp:119`), collision helpers (`v8world/Mesh.cpp:843`, `ContactManager.cpp:833`), `Camera::worldRay` return type (`v8datamodel/Camera.cpp:1458–1482`), adorn debug rays (`PartInstance.cpp:1190+`), and math utilities (`App/util/Math.cpp:1467–1483`). Also `g3d/g3dcpp/CoordinateFrame.cpp:332` transforms an `RBX::RbxRay`.

## Gotchas

- Because directions may be non-unit, `intersectionTime` results scale with direction length (the header spells out distance = time × length). Callers that multiply a unit ray's direction by a search range (e.g. `* 2048`) get times in that scaled space.
- One-sided triangles only: back-face hits return `inf()`.
- The fast no-weights variant skips normalizing by det (returns `t/det`), while the barycentric variant normalizes u,v,t by `1/det` — same hit set, different scales.
