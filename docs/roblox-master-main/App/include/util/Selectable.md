# util/Selectable.h

## Purpose
Marker base class for 3D-selection support: "Base class to control all selection functionality" — a single virtual query telling the selection system whether an object is selectable in 3D.

## Declared API
```cpp
class RBXBaseClass Selectable {
public:
    virtual bool isSelectable3d() { return true; }   // default: selectable
};
```

## Gotchas
- Non-virtual destructor in a polymorphic base — delete only through owning/derived pointers.
- Default is selectable=true; subclasses override to opt out.
- RBXBaseClass marker implies shared-library visibility conventions.

## UNKNOWN
- Full consumer list (studio selection code).
