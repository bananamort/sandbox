# util/ExtentsInt32.h

## Purpose
Integer (Vector3int32) axis-aligned bounding box — the fixed-point/grid counterpart of `Extents`, used for voxel/region bookkeeping where float drift is unacceptable. Public low/high members; supports bit shifts (level-of-detail / mip-style operations), union, containment, and conversion to float `Extents`.

## Declared API
```cpp
class ExtentsInt32 {
public:
    Vector3int32 low;    // public
    Vector3int32 high;   // public

    ExtentsInt32();      // inverted "empty": low=maxInt, high=minInt
    ExtentsInt32(const Vector3int32& _min, const Vector3int32& _max); // slow-asserts ordering

    bool operator==(const ExtentsInt32&) const;   bool operator!= /* likewise */;
    ExtentsInt32& operator=(const ExtentsInt32& other);

    ExtentsInt32 shiftRight(int shift) const;                 // asserts 0<=shift<=32
    ExtentsInt32 shiftRight(const Vector3int32& shift) const; // per-component
    ExtentsInt32 shiftLeft(int shift) const;
    ExtentsInt32 shiftLeft(const Vector3int32& shift) const;

    static ExtentsInt32 vv(const Vector3int32& v0, const Vector3int32& v1);
    static ExtentsInt32 unionExtents(const ExtentsInt32& a, const ExtentsInt32& b);

    const Vector3int32& min() const;   const Vector3int32& max() const;
    Vector3int32 getCorner(int i) const;
    Vector3int32 size() const;         // high - low
    Vector3int32 center() const;       // (low+high)>>1
    Vector3int32 bottomCenter() const;  Vector3int32 topCenter() const;
    int longestSide() const;
    int volume() const;                // 64-bit intermediate, asserts < INT_MAX

    void shift(const Vector3int32& shiftVector);
    void expand(int x);

    Vector3int32& operator[](int i);              // treats object as Vector3int32[2]
    const Vector3int32& operator[](int i) const;
    operator Vector3int32*();                     // implicit cast to array
    operator const Vector3int32*() const;

    bool contains(int x, int y, int z) const;
    bool contains(const Vector3int32& point) const;
    bool overlapsOrTouches(const ExtentsInt32& other) const;   // touching counts
    static bool overlapsOrTouches(const ExtentsInt32&, const ExtentsInt32&);

    Extents toExtents() const;                    // convert to float box

    static const ExtentsInt32& zero();
    static const ExtentsInt32& empty();           // == default ctor state
};
```

## Gotchas
- Default/empty state is **inverted** (low > high) for accumulation semantics — same pattern as `Extents`.
- `center()` uses `>>1` on the sum: arithmetic-shift rounding differs from float `(low+high)*0.5` for negative sums.
- `operator[]` and implicit `Vector3int32*` casts rely on the class being exactly two contiguous Vector3int32s — strict-aliasing/UB-adjacent by design; do not add members.
- `volume()` silently truncates a 64-bit product to int after asserting in slow builds.
- Shifts are value shifts of corner coordinates (box scales by 2^shift), not pixel ops.

## UNKNOWN
- Consumers (voxel cluster bounds likely, outside this slice).
