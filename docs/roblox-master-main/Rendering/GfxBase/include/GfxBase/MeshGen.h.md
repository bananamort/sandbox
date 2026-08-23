# GfxBase/include/GfxBase/MeshGen.h

## Purpose

Declares `RBX::I3DLinearFunc`, the abstract parametric curve interface used by the `Adorn::extrusion` sweep API: a trajectory or profile is any object that can evaluate position, tangent, normal, and binormal at parameter t∈[0,1], plus provide a unique hash string.

## API

```cpp
namespace RBX {
class I3DLinearFunc {
public:
    virtual Vector3 eval(float t) = 0;
    virtual Vector3 evalTangent(float t)  = 0; // tangent/normal/binormal must form a right-handed space
    virtual Vector3 evalNormal(float t)   = 0;
    virtual Vector3 evalBinormal(float t) = 0;
    virtual std::string hashString() = 0;      // unique encoding of this function
};
}
```

Header-only (`#pragma once`); no .cpp needed — pure interface.

## Lua globals and events

None — internal geometry abstraction, not Lua-visible.

## Usage (who loads it)

- Consumed by `Adorn::extrusion(I3DLinearFunc* trajectory, int trajectorysegments, I3DLinearFunc* profile, int profilesegments, ...)` (Adorn.h:325) and its overrides in `AdornBillboarder.h/.cpp`, `AdornBillboarder2D.h`, `AdornSurface.h` (no-op there), and the real renderer implementation `GfxRender/AdornRender.cpp:527`.
- Sole first-party concrete subclass: `CircleRadialNormal` in `AppDraw/DrawAdorn.cpp:913` (used for rotate-handle tori).

## Gotchas

- The contract comment requires (tangent, normal, binormal) to be right-handed; implementations that violate it get inside-out extrusions.
- `hashString()` exists for render-geometry caching; two distinct curves returning the same string would collide in any cache keyed by it.
