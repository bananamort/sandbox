# util/IHasLocation.h

## Purpose
Minimal interface for "this object has a world location": returns a `CoordinateFrame`. Deliberately a **virtual base class** — descendants must inherit it with the `virtual` keyword so only one subobject exists under diamond inheritance (header cites the C++ FAQ multiple-inheritance entry).

## Declared API
```cpp
class RBXInterface IHasLocation {
public:
    virtual const CoordinateFrame getLocation() = 0;
    virtual ~IHasLocation() {}
};
```

## Gotchas
- Inherit VIRTUALLY (`class X : public virtual IHasLocation`) or you defeat its purpose — CameraSubject.md shows the pattern.
- Pure-virtual `getLocation()`: every concrete descendant must implement it.
- Returns by value wrapped in const — cheap CFrame copy, no reference lifetime concerns.

## UNKNOWN
- Full list of implementers (CameraSubject, camera targets, etc.).
