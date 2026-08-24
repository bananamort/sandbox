# util/Region3int32.h

## Purpose
Integer (Vector3int32) axis-aligned 3D region — 32-bit counterpart of Region3Int16, used for wider-range voxel/region bookkeeping.

## Declared API
```cpp
class Region3int32 {
public:
    Region3int32();                                   // init state .cpp-side
    Region3int32(const Vector3int32& min, const Vector3int32& max);
    ~Region3int32();

    Vector3int32 getMinPos() const;                   // by value (unlike Int16 version)
    Vector3int32 getMaxPos() const;

    bool operator==(const Region3int32& other) const;
    bool operator!=(const Region3int32& other) const;
private:
    Vector3int32 minPos, maxPos;
};
```

## Gotchas
- Getters return by value here vs by const-ref in Region3Int16 — minor API asymmetry.
- No `contains`/`empty` helpers (unlike the int16 flavor) — callers roll their own.

## UNKNOWN
- Default-ctor initialization values (.cpp-side).
