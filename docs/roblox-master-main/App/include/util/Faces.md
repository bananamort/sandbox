# util/Faces.h

## Purpose
Bitmask utility for "which of the 6 box faces are enabled" keyed by `NormalId` (top, bottom, left, right, front, back) — e.g., SurfaceGui/Decal face selection and joint attachment faces.

## Declared API
```cpp
class Faces {
public:
    Faces(int normalIdMask = 0);
    void clear();                                    // mask = NORM_NONE_MASK
    void setNormalId(NormalId normalId, bool value);
    bool getNormalId(NormalId normalId) const;

    bool operator==(const Faces& other) const;
    bool operator!=(const Faces& other) const;

    int normalIdMask;   // public data member
};
```

## Gotchas
- `normalIdMask` is public — direct manipulation bypasses the helpers.
- Sibling of `Axes.h` (which keys by `Vector3::Axis`); both wrap an int mask but with different bit conventions.
- `NORM_NONE_MASK` constant comes from NormalId.h.

## UNKNOWN
- Bit-per-NormalId assignment table lives in the .cpp / NormalId.h (see NormalId.md).
