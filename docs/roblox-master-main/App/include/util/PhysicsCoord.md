# util/PhysicsCoord.h

## Purpose
Vector-space pose type for physics math: translation (Vector3) + rotation as a Quaternion, treated as a flat 7-float vector so physics code can add/subtract/scale poses (e.g., for solver deltas and blending).

## Declared API
```cpp
class PhysicsCoord {
public:
    Vector3    translation;
    Quaternion rotation;

    PhysicsCoord();                                        // zero translation; default quat
    PhysicsCoord(const CoordinateFrame& cframe);           // convert from matrix CFrame
    PhysicsCoord(const Vector3& _translation);
    PhysicsCoord(const Vector3& _translation, const Quaternion& _rotation);
    PhysicsCoord(const PhysicsCoord& other);

    bool operator==(const PhysicsCoord&) const;   bool operator!= /* likewise */;

    PhysicsCoord operator+(const PhysicsCoord& rhs) const; // component-wise
    PhysicsCoord operator-(const PhysicsCoord& rhs) const;
    PhysicsCoord& operator+=(const PhysicsCoord& other);
    PhysicsCoord operator*(float f) const;
    PhysicsCoord operator/(float f) const;
    float squaredMagnitude() const;   // |t|² + quaternion magnitude (see Gotchas)
};
```

## Gotchas
- `squaredMagnitude()` adds `rotation.magnitude()` — the in-header comment itself flags the doubt ("note for quaternion magnitude == squared values?...."). It mixes a squared term with a possibly-unsquared one; verify before trusting comparisons.
- `operator+/-` on quaternions is component-wise — NOT composition. These are solver-space arithmetic ops, not transforms.
- No normalization of the rotation quaternion after arithmetic; drift accumulates if used as an orientation.
- Default ctor leaves `rotation` at Quaternion's default (identity per Quaternion.md, UNKNOWN exact).

## UNKNOWN
- Which physics backend consumes this (solver interpolation/blending outside this slice).
