# util/Face.h

## Purpose
Planar quad (4 corner Vector3s) on a box/part face, with UV axes, normal, grid snapping, coordinate-frame transforms, and overlap/alignment tests against other faces. Built from an `Extents` side via `fromExtentsSide`.

## Declared API
```cpp
class Face {
public:
    Face();                                        // uninitialized corners
    Face(const Face& other);
    static Face fromExtentsSide(const Extents& e, NormalId faceId);

    void snapToGrid(float grid);

    Vector3& operator[](int i);                    // 0..3 corner access (c0..c3)
    const Vector3& operator[](int i) const;

    Vector3 getU() const;          // direction of c1-c0
    Vector3 getV() const;          // direction of c3-c0
    Vector3 getNormal() const;     // U x V, normalized
    Vector2 size() const;          // |c1-c0| x |c3-c0|
    Vector3 center() const;        // 0.5*(c0+c2)

    Face toWorldSpace(const CoordinateFrame& objectCoord) const;
    Face toObjectSpace(const CoordinateFrame& objectCoord) const;
    Face projectOverlapOnMe(const Face& other) const;

    bool fuzzyContainsInExtrusion(const Vector3& point, float tolerance) const;
    static bool cornersAligned(const Face& f0, const Face& f1, float tolerance);
    static bool hasOverlap(const Face& f0, const Face& f1, float byAtLeast);
    static bool overlapWithinPlanes(const Face& f0, const Face& f1, float tolerance);
private:
    Vector3 c0, c1, c2, c3;
    Face(const Vector3& c0, const Vector3& c1, const Vector3& c2, const Vector3& c3);
    Vector3 getAxis(int i) const;                  // asserts i in {0,1}; U or V
    void minMax(const Vector3& point, const Vector3& normal, float& min, float& max) const;
    Face operator*(float fScalar) const;           // private scalar scale
    Face operator*(const Vector3& vector3) const;  // private component-wise scale
};
```

## Gotchas
- Default-constructed `Face()` leaves all four corners uninitialized — always use `fromExtentsSide` or copy.
- Assumes corners form a proper quad: `getU`/`getV` derive directions from c1-c0 / c3-c0 and `center()` averages only c0+c2 — a non-planar or reordered quad yields garbage.
- `operator[]` non-const returns mutable references to corners (index bounds unchecked in header; RBXASSERT likely in .cpp).
- Scaling operators are private implementation helpers.

## UNKNOWN
- Semantics details of `projectOverlapOnMe` and `fuzzyContainsInExtrusion` (.cpp outside App/include).
