# App/include/v8world/SnapJoint.h

## Purpose

Snap joint (`SNAP_JOINT`) — a rigid joint created when compatible stud/inlet-style surfaces meet; the auto-join counterpart of welds with its own surface-compatibility rule.

## Declared API

- `class SnapJoint : public RigidJoint`
  - Ctors: default; `(Primitive* prim0, Primitive* prim1, const CoordinateFrame& c0, const CoordinateFrame& c1);` inline dtor.
  - `getJointType() → SNAP_JOINT` (unqualified name from Joint's enum scope).
  - Static factory: `static SnapJoint* canBuildJoint(Primitive* p0, Primitive* p1, NormalId nId0, NormalId nId1);` using private `compatibleSurfaces(p0, p1, nId0, nId1)`.

## Gotchas

- Header comment block says "// WeldJoint" over `compatibleSurfaces` — copy-paste artifact; the logic is snap-specific.
- Rigid semantics inherited: never breaks (`isBroken → false` via [RigidJoint.md](RigidJoint.md)).

## Cross-links

- Base: [RigidJoint.md](RigidJoint.md), [Joint.md](Joint.md) (classification `isRigidJoint` includes SNAP). Weld sibling: [WeldJoint.md](WeldJoint.md).
