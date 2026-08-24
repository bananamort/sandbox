# util/TouchType.h

## Purpose
Result record for touch/intersection queries against a PVInstance: independent statuses for "world extents" and "objects", each NOTHING / TOUCH_ONLY / INTERSECT, with derived boolean queries (touching vs intersecting combinations).

## Declared API
```cpp
class TouchType {
private:
    friend class PVInstance;
    typedef enum { NOTHING, TOUCH_ONLY, INTERSECT } Status;
    Status worldExtents;   // vs the world boundary/extents
    Status objects;        // vs other objects
public:
    TouchType();           // both NOTHING

    bool intersectingWorldExtents();
    bool intersectingObject();
    bool intersecting();               // either
    bool touchingWorldExtents();
    bool touchingObject();
    bool touching();                   // either
    bool touchingOnlyWorldExtents();   // world touch && !object touch
    bool nothingFound();
    bool touchingNotIntersecting();
    bool somethingFound();
    bool intersectsOtherOnly();        // objects INTERSECT && worldExtents NOTHING
};
```

## Gotchas
- Mutation is private (`friend class PVInstance`) — consumers can only read via queries.
- Query methods are non-const.
- TOUCH_ONLY vs INTERSECT distinction is set by PVInstance's collision logic.

## UNKNOWN
- Exact semantics of TOUCH_ONLY vs INTERSECT in world-extents terms (.cpp of PVInstance).
