# util/PV.h

## Purpose
"Position + Velocity": a rigid-body state pair (CoordinateFrame position, Velocity linear+angular) with point/offset velocity queries, local-offset PV composition, and lerp. Core kinematics value type.

## Declared API
```cpp
class PV {
public:
    CoordinateFrame position;
    Velocity        velocity;

    PV();                                   // identity CFrame / zero velocity
    PV(const CoordinateFrame& _position, const Velocity& _velocity);
    PV(const PV& other);
    ~PV();

    bool operator==(const PV& other) const;
    bool operator!=(const PV& other) const;

    Vector3  linearVelocityAtPoint(const Vector3& worldPos) const;
             // v + ω × (worldPos - pos.translation)
    Velocity velocityAtPoint(const Vector3& worldPos) const;
    Velocity velocityAtLocalOffset(const Vector3& localOffset) const;

    PV pvAtLocalOffset(const Vector3& localOffset) const;
    static void pvAtLocalCoord(const PV& base, const CoordinateFrame& localCoord, PV& answer);
    PV pvAtLocalCoord(const CoordinateFrame& localCoord) const;

    PV lerp(const PV& other, float alpha) const;   // position AND velocity lerp
};
```
Commented-out (disabled) members: `operator*` (PV composition), `inverse()`, `toObjectSpace()`, `toWorldSpace()` — the math is preserved in comments but not compiled.

## Gotchas
- Composition/inverse operators exist only as commented-out code — if you need them, note the disabled versions had subtle rotate-by-parent semantics; re-enabling requires review.
- `pvAtLocalCoord(static)` writes into `answer` — aliasing `answer` with `base` is untested.
- Equality compares floats exactly.
- `lerp` on rotation uses CFrame lerp (see G3D semantics); large angle gaps interpolate the short way.

## UNKNOWN
- Nothing major; all live members are inline and self-explanatory. Consumers span physics/replication.
