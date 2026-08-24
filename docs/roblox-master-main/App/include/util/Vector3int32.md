# util/Vector3int32.h

## Purpose
32-bit integer 3-vector with the full bitwise/shift arithmetic needed by voxel-region math (see StreamRegion.md, SpatialRegion.md, Region3int32.md): per-component `>>`/`<<` (by vector or scalar), masking, modulo, min/max, conversions to/from float Vector3 and Vector3int16, plus canonical zero/one/maxInt/minInt statics.

## Declared API
```cpp
class Vector3int32 {
public:
    int x, y, z;    // public

    Vector3int32();                                  // 0,0,0
    Vector3int32(int _x, int _y, int _z);
    explicit Vector3int32(const Vector3int16& v);

    const int& operator[](int i) const;              // raw array access via cast
    int& operator[](int i);                          // NO bounds check

    Vector3int32 operator-() const;
    Vector3int32 operator+(const Vector3int32&) const;
    Vector3int32 operator-(const Vector3int32&) const;
    Vector3int32 operator*(int) const;               // scalar
    Vector3int32 operator*(const Vector3int16&) const;   // component-wise
    Vector3int32 operator*(const Vector3int32&) const;

    Vector3int32 operator>>(const Vector3int32&) const;  // per-component shifts!
    Vector3int32 operator>>(const Vector3int16&) const;
    Vector3int32 operator>>(unsigned int shift) const;   // asserts shift < 32 (slow)
    Vector3int32 operator<<(const Vector3int32&) const;
    Vector3int32 operator<<(const Vector3int16&) const;
    Vector3int32 operator<<(unsigned int shift) const;

    Vector3int32 operator&(const Vector3int32&) const;   // component mask
    Vector3int32 operator%(const Vector3int32&) const;   // component modulo

    void shiftRight(int shift);                      // in-place

    bool operator==(const Vector3int32&) const;
    bool operator!=(const Vector3int32&) const;
    bool operator<(const Vector3int32&) const;       // x-then-y-then-z lexicographic

    float squaredMagnitude() const;                  // returned as FLOAT

    static Vector3int32 floor(const G3D::Vector3& v);   // via Math::iFloor
    Vector3int32 min(const Vector3int32&) const;
    Vector3int32 max(const Vector3int32&) const;
    G3D::Vector3 toVector3() const;
    G3D::Vector3int16 toVector3int16() const;        // silent narrowing!
    int sum() const;

    static const Vector3int32& zero();
    static const Vector3int32& one();
    static const Vector3int32& maxInt();             // INT_MAX triple
    static const Vector3int32& minInt();
};

std::ostream& operator<<(std::ostream&, const Vector3int32&);
std::size_t hash_value(const RBX::Vector3int32& v);

inline RBX::Vector3int32 fastFloorInt32(const RBX::Vector3& v);   // fastFloorInt per axis
```

## Gotchas
- `operator>>`/`<<` with a VECTOR argument shifts each component by a DIFFERENT amount — unusual semantics, heavily relied upon by region code.
- Shift counts ≥ 32 are UB; only slow-path asserted.
- `toVector3int16` narrows silently — values outside ±32767 wrap.
- Negative-number `>>` is implementation-defined pre-C++20 (arithmetic shift on all real compilers).
- `operator%` on negatives yields implementation-defined sign (C++03 truncation).
- No division operators.

## UNKNOWN
- Nothing notable beyond .cpp-side stream/hash definitions.
