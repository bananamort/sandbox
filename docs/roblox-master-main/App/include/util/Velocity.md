# util/Velocity.h

## Purpose
Rigid-body velocity: linear + angular (rotational) Vector3 pair with vector-space arithmetic, frame rotation, point-offset velocity queries, lerp, and a shared zero instance. The velocity half of PV.md.

## Declared API
```cpp
class Velocity {
public:
    Vector3 linear;      // public
    Vector3 rotational;  // public (angular velocity)

    Velocity();                                        // zero/zero
    explicit-ish Velocity(const Vector3& _linear);     // rotational = 0 (implicit from Vector3)
    Velocity(const Vector3& _linear, const Vector3& _rotational);
    Velocity(const Velocity& other);

    bool operator==(const Velocity&) const;   bool operator!= /* likewise */;

    Velocity operator+(const Velocity& rhs) const;
    Velocity operator-(const Velocity& rhs) const;
    Velocity operator*(float f) const;
    Velocity operator-() const;

    Velocity rotateBy(const Matrix3& m) const;         // rotate both components

    static Velocity toObjectSpace(const Velocity& vWorld, const CoordinateFrame& c);
    static Velocity toWorldSpace(const Velocity& vInObject, const CoordinateFrame& c);

    Vector3  linearVelocityAtOffset(const Vector3& offset) const;  // v + ω × offset
    Velocity velocityAtOffset(const Vector3& offset) const;

    static const Velocity& zero();

    Velocity lerp(const Velocity& other, float alpha) const;
};
```

## Gotchas
- `Velocity(const Vector3&)` is implicit — easy accidental construction from a bare linear vector.
- `linearVelocityAtOffset` is the classic `v + ω × r`; offset is from the body origin (world-aligned unless pre-transformed).
- Angular component uses radians/sec convention (consistent with physics code).
- Exact float equality operators.

## UNKNOWN
- Nothing notable; all members inline.
