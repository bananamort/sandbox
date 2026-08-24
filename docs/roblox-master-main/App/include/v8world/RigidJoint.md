# App/include/v8world/RigidJoint.h

## Purpose

Base for all rigid joints (weld, snap, manual weld): alignment queries and the shared face→coordinate-frame placement math used when building joints between two faces. Not directly instantiable as a specific joint type — `getJointType()` asserts.

## Declared API

- `class RigidJoint : public Joint`
  - Ctors: default; `(Primitive* prim0, Primitive* prim1, const CoordinateFrame& c0, const CoordinateFrame& c1);` inline dtor.
  - Joint overrides: `getJointType() → {RBXASSERT(0); return NO_JOINT;}` — subclasses must override; `isBroken() → false`.
  - Alignment: `bool isAligned();` `CoordinateFrame align(Primitive* pMove, Primitive* pStay);` `CoordinateFrame getChildInParent(Primitive* parent, Primitive* child);`
  - Protected static: `faceIdToCoords(Primitive* p0, Primitive* p1, NormalId nId0, NormalId nId1, CoordinateFrame& c0, CoordinateFrame& c1)` — computes the two object-space joint frames from opposing face normals.
  - Private static: `jointIsRigid(Joint*)` = WELD ∪ SNAP ∪ MANUAL_WELD with in-header TODO: "This assumes two function (one virtual) calls are way better than a dynamic cast?..."

## Gotchas

- Instantiating/using a bare RigidJoint's `getJointType()` asserts — it exists for shared code, classification goes through subclasses.
- `jointIsRigid` duplicates [Joint.md](Joint.md)'s `isRigidJoint` logic (enum-range style vs explicit list) — keep both in sync mentally.

## Cross-links

- Subclasses: [WeldJoint.md](WeldJoint.md), [SnapJoint.md](SnapJoint.md); base: [Joint.md](Joint.md); consumers: [GroundStage.md](GroundStage.md) (`heaviestRigidToGround`), [Assembly.md](Assembly.md) (`computeIsGroundingPrimitive`).
