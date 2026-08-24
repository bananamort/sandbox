# util/Rect.h

## Purpose
2D float rectangle (screen-space/UI): low = **top-left**, high = **bottom-right** (y-down convention), with construction helpers, union, containment, border hit-testing, child positioning by 9-point anchors, and insetting. Header itself notes "TODO: Replace with G3D::Rect2D".

## Declared API
```cpp
class Rect {
public:
    typedef enum { TOP, BOTTOM, LEFT, RIGHT, CENTER, NONE } Location;

    static bool legalX(Location loc);   // not TOP/BOTTOM
    static bool legalY(Location loc);   // not LEFT/RIGHT

    Vector2 low;     // top left      (public)
    Vector2 high;    // bottom right  (public)

    Rect();                                        // both corners zero
    Rect(Rect2D r);                                // from G3D rect
    Rect2D toRect2D() const;
    Rect(float left, float top, float right, float bottom);
    Rect(const Vector2& _high);                    // low = origin
    Rect(const Vector2& _low, const Vector2& _high);

    static Rect fromLowSize(const Vector2& _low, const Vector2& _size);
    static Rect xywh(float x, float y, float w, float h);
    static Rect fromCenterSize(const Vector2& _center, const Vector2& _size);
    static Rect fromCenterSize(const Vector2& _center, float _size);

    void unionWith(const Rect& other);
    void unionWith(const Vector2& point);

    bool operator==(const Rect&) const;  bool operator!= /* likewise */;
    bool contains(const Vector2& xz) const;        // inclusive bounds
    bool pointInRect(int x, int y) const;
    bool pointInRect(Vector2int16 point) const;

    Vector2 size() const;      // high - low
    Vector2 center() const;

    Location pointInBorder(const Vector2& point, float borderRatio);
    Vector2 positionPoint(Location xLoc, Location yLoc) const;
    Vector2 positionPoint(const Vector2& point, Location xLoc, Location yLoc) const;
    Rect positionChild(const Rect& child, Location xLoc, Location yLoc) const;

    Rect inset(int dx);                        // returns inset copy
    Rect inset(const Vector2int16& dd);

    Vector2 clamp(const Vector2& point);

    static const float BORDER_RATIO;         // default border hit width
    static const float BORDER_RATIO_DRAG;
    static const float BORDER_RATIO_THIN;
};
```

## Gotchas
- Y is DOWN: `low` is the TOP-left. Mixing with G3D's y-up conventions requires care (`toRect2D`/ctor conversions provided).
- `inset` with negative values grows the rect; no validity checks.
- `contains` uses >= / <= (boundary counts as inside).
- `pointInBorder` semantics (which Location returned for corner overlaps) are .cpp-side.
- Non-const `inset`/`clamp` return-by-value but aren't marked const.

## UNKNOWN
- Exact border-ratio defaults' numeric values (.cpp).
