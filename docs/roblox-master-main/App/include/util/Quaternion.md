# util/Quaternion.h (+ Quaternion.inl)

## Purpose
Float quaternion (x,y,z,w) for rotations: conversion to/from Matrix3, axis-angle extraction, Hamilton product, component arithmetic used by physics blending. `Quaternion.inl` (folded here) supplies the inline `+=` and `*=` compound operators.

## Declared API
```cpp
class Quaternion {
public:
    float x, y, z, w;

    Quaternion();                                   // identity (0,0,0,1)
    Quaternion(float x, float y, float z, float w);
    Quaternion(const G3D::Vector3& v, float _w = 0);  // vector part + scalar
    Quaternion(const G3D::Matrix3& rot);            // from rotation matrix

    Quaternion& operator=(const Quaternion& other);

    const G3D::Vector3& imag() const;               // reinterpret x,y,z as Vector3
    G3D::Vector3& imag();

    void toRotationMatrix(Matrix3& rot) const;
    float dot(const Quaternion& other) const;       // 4-dot
    float magnitude() const;                        // NOTE: sum of squares (NOT sqrt)
    float maxComponent() const;                     // max |component|
    float getAngle() const;                         // 2*acos(w), axis-angle angle
    Vector3 getAxis() const;                        // arbitrary (1,0,0) if degenerate
    Quaternion conjugate() const;

    float& operator[](int i) const;                 // raw float access, no bounds check
    operator float*();                              // implicit casts to array
    operator const float*() const;

    Quaternion operator*(const Quaternion&) const;  // Hamilton product (Watt & Watt p360)
    Quaternion operator+(const Quaternion&) const;  // component-wise
    Quaternion operator-(const Quaternion&) const;
    Quaternion operator*(float s) const;

    Quaternion& operator*=(float fScalar);          // from Quaternion.inl
    Quaternion& operator+=(const Quaternion&);      // from Quaternion.inl

    void normalize() { *this *= 1.0f / sqrtf(magnitude()); }
};
```

## Gotchas
- **`magnitude()` returns the squared magnitude** (x²+y²+z²+w², no sqrt). `normalize()` correctly divides by its square root — but any external use of `magnitude()` expecting a length is wrong. (PhysicsCoord.md's `squaredMagnitude` inherits this ambiguity.)
- `imag()` type-puns the first 12 bytes into a `G3D::Vector3` — relies on layout; fine in practice, technically UB-adjacent.
- `getAngle()` assumes unit quaternion (acos of w).
- `operator[]`/`float*` casts have no bounds checking.
- Component-wise `+`/`-` are solver-space ops (blending), NOT rotations.
- Header includes `Quaternion.inl` at the bottom — the .inl has no include guard of its own; never include it directly.

## UNKNOWN
- Matrix3 ctor / toRotationMatrix / operator= bodies (.cpp outside App/include).
