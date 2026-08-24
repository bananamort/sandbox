# util/Region2.h

## Purpose
2D pick-region helper: an "owner" weighted point (position + radius) plus a set of "other" weighted points; answers whether a screen-space point is inside the owner's region and not closer to any other — used for click-target disambiguation (e.g., GUI/adornment hit tests).

## Declared API
```cpp
class Region2 {
public:
    class WeightedPoint {
    public:
        Vector2 point;
        float radius;
        WeightedPoint();                                  // zero point, radius 0
        WeightedPoint(const Vector2& point, const float radius);
    };

    Region2();
    ~Region2();

    void clearEmpty();                                    // reset owner + others
    bool isEmpty() const;                                 // owner.radius <= 0

    void setOwner(const WeightedPoint& _owner);
    void appendOther(const WeightedPoint& _other);

    bool contains(const Vector2& pos2d, const float slop) const;

    static float getRelativeError(const Vector2& pos2d, const WeightedPoint& owner);
        // "go through all owner points - find best one" (comment inherited)
    static bool pointInRange(const Vector2& pos2d, const WeightedPoint& owner, const float slop);
    static bool closerToOtherPoint(const Vector2& pos2d,
                                   const WeightedPoint& owner,
                                   const WeightedPoint& other,
                                   float slop);
private:
    WeightedPoint owner;
    G3D::Array<WeightedPoint> others;
    bool findCloserOther(const Vector2& point, const float slop) const;
};
```

## Gotchas
- `isEmpty()` is defined by owner radius <= 0 — an owner with zero radius is "no region".
- `contains` = in-range of owner AND not closer to any other (slop widens both checks).
- Default-constructed Region2 has an uninitialized-ish owner? No — `WeightedPoint()` default ctor zeroes it, so it starts empty.
- Others list grows via G3D::Array; no dedup.

## UNKNOWN
- Exact metric used by getRelativeError / pointInRange (distance minus radius? .cpp-side).
