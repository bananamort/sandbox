# util/Axes.h

## Purpose
Small bitmask utility for "which of the 6 box faces are enabled" — holds a set of faces/axes (top, bottom, left, right, front, back) in one `int`, with conversions to/from `Vector3::Axis` and `NormalId`.

## Declared API
```cpp
class Axes {
public:
    static int axisToMask(Vector3::Axis axis);
    static Vector3::Axis normalIdToAxis(NormalId normalId);
    static NormalId axisToNormalId(Vector3::Axis axis);

    Axes(int axisMask = 0);
    void clear();                                        // mask = 0
    void setAxisByNormalId(NormalId normalId, bool value);
    bool getAxisByNormalId(NormalId normalId) const;
    void setAxis(Vector3::Axis axis, bool value);
    bool getAxis(Vector3::Axis axis) const;

    bool operator==(const Axes& other) const;
    bool operator!=(const Axes& other) const;

    int axisMask;   // public data member
};
```

## Gotchas
- `axisMask` is public: callers can and do bypass the setters; keep the mask convention consistent (per-axis bits via `axisToMask`).
- Default-constructed `Axes()` is all-clear (mask 0).
- Mapping between `NormalId` face enumeration and `Vector3::Axis` lives in the implementation (with NormalId.h providing the enum) — see NormalId.md.

## UNKNOWN
- Exact bit assignment per axis in `axisToMask` (implementation .cpp not in this slice).
