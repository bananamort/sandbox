# App/include/v8world/GlueJoint.h

## Purpose

Surface-glue joints: `GlueJoint` welds two primitives across a shared quad face (`Face` in joint space) and is breakable under force; `ManualGlueJoint` is the explicit-surface variant. When the PGS solver is active, glue is expressed as kernel `Constraint`s.

## Declared API

- `class GlueJoint : public MultiJoint`
  - Members: `Face faceInJointSpace;` (4 points, "in joint space (common to both P0 and P1)"); `std::vector<Constraint*> constraints;` — "Used when PGS is on".
  - Ctors: default; full `GlueJoint(Primitive* p0, Primitive* p1, const CoordinateFrame& jointCoord0, const CoordinateFrame& jointCoord1, const Face& faceInJointSpace);`
  - Face points: `const Vector3& getFacePoint(int i)` / `setFacePoint(int, const Vector3&)` — assert 0 ≤ i < 4.
  - Joint overrides: `getJointType() → GLUE_JOINT`; `isBreakable() → true`; `bool isBroken() const` (impl-only).
  - Edge overrides: `putInKernel(Kernel*)`, `removeFromKernel()` — build/tear down the PGS constraint set.
  - Static factory: `static GlueJoint* canBuildJoint(Primitive* p0, Primitive* p1, NormalId nId0, NormalId nId1);` using private `compatibleSurfaces(...)`.
  - Private: `float getMaxForce();`
- `class ManualGlueJoint : public GlueJoint`
  - Members: `size_t surface0/surface1` ("surface from primitive N"), default ctor sets both to `(size_t)-1`.
  - Ctor: `(size_t s0, size_t s1, Primitive*, Primitive*, const CoordinateFrame& c0, const CoordinateFrame& c1, const Face&)`.
  - Accessors: `get/setSurface0`, `get/setSurface1`.
  - Overrides: `getJointType() → MANUAL_GLUE_JOINT` (unqualified name from Joint's enum), `putInKernel(Kernel*)`, `void computeIntersectingSurfacePoints(void);`

## Gotchas

- Two kernel paths exist: legacy glue vs PGS `Constraint`s — `putInKernel` behavior differs depending on solver mode ([../solver/Solver.md](../solver/Solver.md)).
- `canBuildJoint` returns NULL when surfaces aren't compatible — it's a query+build in one.
- Breakable by design: `isBroken()` consults accumulated force vs `getMaxForce()` (implementation detail).

## UNKNOWN

- Exact break force formula and whether `constraints` are owned or referenced.

## Cross-links

- Base: [MultiJoint.md](MultiJoint.md), [Joint.md](Joint.md), [Edge.md](Edge.md). Solver constraints: [../solver/Constraint.md](../solver/Constraint.md), [../solver/SolverKernel.md](../solver/SolverKernel.md).
