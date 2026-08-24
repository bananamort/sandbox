# util/Region3.h

## Purpose
Oriented 3D region: a CoordinateFrame (position + rotation) plus an axis-aligned-in-local-space size. Constructible from min/max corners or from an Extents; exposes the CFrame/size pair used by the Lua `Region3` datatype.

## Declared API
```cpp
class Region3 {
public:
    Region3();                                   // presumably identity at origin, zero size
    Region3(const Vector3& min, const Vector3& max);
    explicit Region3(const Extents& extents);    // explicit on purpose
    ~Region3();

    const G3D::CoordinateFrame& getCFrame() const;
    const Vector3& getSize() const;

    Vector3 minPos() const;      // world-space min corner
    Vector3 maxPos() const;

    bool operator==(const Region3& other) const;   // size AND cframe equality
    bool operator!=(const Region3& other) const;
private:
    G3D::CoordinateFrame cframe;
    Vector3 size;
    void init(const Extents& extents);
};
```

## Gotchas
- From-min/max construction produces an axis-aligned region (identity rotation); the header exposes **no mutator** for `cframe` (`getCFrame()` returns a const reference), so how callers obtain rotated regions is not visible from this header (UNKNOWN).
- `minPos`/`maxPos` of a ROTATED region are the world AABB bounds of the oriented box (computed in .cpp).
- Equality includes full CFrame comparison — float-exact.

## UNKNOWN
- Default-constructed state and whether any API mutates the cframe after construction (.cpp-side).
