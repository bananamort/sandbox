# App/include/v8world/WeldJoint.h

## Purpose

Weld joints — the canonical rigid connection. `WeldJoint` (`WELD_JOINT`) is the auto-joinable weld; `ManualWeldJoint` (`MANUAL_WELD_JOINT`) records the two explicit surface ids and supports terrain cell welds.

## Declared API

- `class WeldJoint : public RigidJoint`
  - Ctors: default; `(Primitive* prim0, Primitive* prim1, const CoordinateFrame& c0, const CoordinateFrame& c1);` virtual inline dtor.
  - `getJointType() → WELD_JOINT` (unqualified enum name).
  - Static factory: `static WeldJoint* canBuildJoint(Primitive*, Primitive*, NormalId nId0, NormalId nId1);` using private `compatibleSurfaces(...)`.
- `class ManualWeldJoint : public WeldJoint`
  - Members: `size_t surface0/surface1` ("surface from primitive N"), default ctor sets both `(size_t)-1`.
  - Ctor `(size_t s0, size_t s1, Primitive*, Primitive*, const CoordinateFrame& c0, const CoordinateFrame& c1);`
  - Accessors: `get/setSurface0`, `get/setSurface1`.
  - Terrain support: `Vector3int16 getCell() const;` / `void setCell(const Vector3int16& pos);` static `bool isTouchingTerrain(Primitive* terrain, Primitive* prim);`
  - `getJointType() → MANUAL_WELD_JOINT`.

## Gotchas

- `ManualWeldJoint::getCell/setCell` implies some manual welds bind a part to a **terrain cell** — World exposes dedicated cleanup paths for these ([World.md](World.md) `destroyTerrainWeldJointsWithEmptyCells/NoTouch`).
- Rigid semantics inherited: never breaks via `isBroken` (breakage of rigid structures happens at the joint-destruction level, not force breaking).

## Cross-links

- Base: [RigidJoint.md](RigidJoint.md), [Joint.md](Joint.md) (classification: `isRigidJoint` = WELD ∪ SNAP ∪ MANUAL_WELD; `isManualJoint`). Snap sibling: [SnapJoint.md](SnapJoint.md). Glue counterpart with PGS constraints: [GlueJoint.md](GlueJoint.md).
