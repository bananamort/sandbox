# util/Extents.h

## Purpose
Axis-aligned 3D bounding box (`low`/`high` Vector3 pair) with the full geometry toolkit: construction from center/radius, corners/faces, transforms, unions, containment, overlap, clamping, and canonical static boxes. Core spatial primitive used across physics/rendering/streaming.

## Declared API
```cpp
class Extents {
public:
    Extents();                                   // "negative infinite" (min=+maxFinite, high=-maxFinite)
    Extents(const Vector3& _min, const Vector3& _max);   // slow-asserts min<=max

    static Extents fromCenterCorner(const Vector3& center, const Vector3& corner);
    static Extents fromCenterRadius(const Vector3& center, float radius);
    static Extents vv(const Vector3& v0, const Vector3& v1);   // from any two points

    bool isNanInf() const;
    bool operator==(const Extents&) const;  bool operator!= /* likewise */;

    const Vector3& min() const;   const Vector3& max() const;
    Vector3int16 getCornerIndex(int i) const;
    Vector3 getCorner(int i) const;
    Vector3 size() const;        // high - low
    Vector3 center() const;
    Vector3 bottomCenter() const;  Vector3 topCenter() const;
    float longestSide() const;     float volume() const;    float areaXZ() const;
    bool isNull() const;           // any low > high

    Extents toWorldSpace(const CoordinateFrame& offset) const;
    Extents express(const CoordinateFrame& myFrame, const CoordinateFrame& expressInFrame) const;

    // faceId's are in order of x, y, z, -x, -y, -z
    Vector3 faceCenter(NormalId faceId) const;
    void getFaceCorners(NormalId faceId, Vector3& v0, Vector3& v1, Vector3& v2, Vector3& v3) const;
        // 4 corners of a face, counter-clockwise quad facing outwards
    Plane getPlane(NormalId normalId) const;

    Vector3 clip(const Vector3& clipVector) const;         // clamp point into box
    float computeClosestSqDistanceToPoint(const Vector3& point) const;
    Vector3 clamp(const Extents& innerExtents) const;      // move inner to stay inside
    NormalId closestFace(const Vector3& point);

    void unionWith(const Extents& other);
    Extents clampInsideOf(const Extents& other) const;
    void shift(const Vector3& shiftVector);
    void scale(float x);
    void expand(float x);
    void expand(const Vector3& p);
    void expandToContain(const Vector3& p);
    void expandToContain(const Extents& e);
    bool contains(const Vector3& point) const;
    bool fuzzyContains(const Vector3& point, float slop) const;
    bool overlapsOrTouches(const Extents& other) const;    // touching counts
    static bool overlapsOrTouches(const Extents& e0, const Extents& e1);
    bool clampToOverlap(const Extents& other);             // mutates to intersection; false if none
    bool separatedByMoreThan(const Extents& other, float distance) const;

    static const Extents& zero();              // degenerate at origin
    static const Extents& unit();              // (-1,-1,-1)..(1,1,1)
    static const Extents& negativeMaxExtents();// == default ctor state
    static const Extents& maxExtents();        // (-maxFinite)..(+maxFinite)
private:
    Vector3 low, high;
};
```

## Gotchas
- Default ctor produces an *empty/inverted* box (for accumulation via `expandToContain`), NOT a zero box — `isNull()` tests for that inverted state.
- `overlapsOrTouches` treats exactly-touching boxes as overlapping.
- `clampToOverlap` **mutates** this box to the intersection and returns false (leaving it in a partially-clamped state? no — returns false before mutating when disjoint).
- Face order convention: NormalIds ordered x, y, z, -x, -y, -z (see NormalId.md).
- `scale(float)` scales corner positions about the origin, not the center — scaling a non-centered box also moves it.

## UNKNOWN
- `closestFace` tie-breaking behavior at equidistant faces (.cpp-side).
