# util/Rotation2d.h

## Purpose
2D rotation primitives: `RotationAngle` caches an angle (degrees) together with its sin/cos, and `Rotation2D` is an angle + pivot center that rotates Vector2 points about that pivot.

## Declared API
```cpp
// "Represents rotations in angles"
class RotationAngle {
public:
    RotationAngle();                       // value=0, sin=0, cos=1
    explicit RotationAngle(float angle);   // angle in DEGREES; precomputes sin/cos

    bool empty() const;                    // value == 0.f exactly
    float getValue() const;                // degrees
    float getSin() const;
    float getCos() const;

    bool operator==(const RotationAngle&) const;   // value equality only
    bool operator!=(const RotationAngle&) const;

    RotationAngle inverse() const;         // negated angle & sin
    RotationAngle combine(const RotationAngle& other) const;  // angle addition w/ trig identities
private:
    float value, sin, cos;
};

class Rotation2D {
public:
    Rotation2D();                          // default: empty angle + default-constructed center
    Rotation2D(const RotationAngle& angle, const Vector2& center);

    const RotationAngle& getAngle() const;
    const Vector2& getCenter() const;
    bool empty() const;                    // angle.empty()

    bool operator==(const Rotation2D&) const;
    bool operator!=(const Rotation2D&) const;

    Vector2 rotate(const Vector2& p) const;   // fast path when empty; rotate about center
    Rotation2D inverse() const;
private:
    RotationAngle angle;
    Vector2 center;
};
```

## Gotchas
- Angles are **degrees** in the API (`getValue`), converted to radians internally for sin/cos.
- `empty()` is exact `== 0.f` — a rotation of 1e-9 degrees is not "empty" and takes the full trig path.
- Equality on `RotationAngle` compares only the stored angle value, not the cached sin/cos; `Rotation2D` equality additionally compares centers.
- `combine` accumulates angle without normalization to [-180,180].

## UNKNOWN
- Consumers (2D UI/terrain editing rotations presumably).
