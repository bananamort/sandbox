# AdornBillboarder2D.h

Source: `roblox-sandbox/Rendering/GfxBase/include/GfxBase/AdornBillboarder2D.h` (185 lines)

## Purpose

A strict 2D-only `Adorn` decorator: delegates the 2D subset (lines, rects, text, textures) to a parent with a screen offset, and makes EVERY 3D primitive throw `std::runtime_error("Invalid operation")`. Compile-time contract enforcement at runtime — using box/sphere/etc. through this wrapper is a programming error.

## API

```cpp
class RBX::AdornBillboarder2D : public Adorn {
protected:
    Adorn* parent; Rect2D viewport; Vector2 screenOffset;
public:
    AdornBillboarder2D(Adorn* parent, const Rect2D& viewport, const Vector2& screenOffset);

    // pass-throughs (inline):
    createTextureProxy(id, waiting, bBlocking=false, context="") -> parent
    getUnbindResourcesSignal() -> parent
    getCamera() -> NULL (virtual)
    setTexture(id, texture) / getTextureSize(texture) -> parent
    useFontSmoothScalling() -> true   // [sic]
    get2DStringBounds(...) -> parent
    drawFont2DImpl(target, s, position, size, autoScale, color, outline,
                   font, xalign, yalign, availableSpace, clippingRect, rotation)
        -> parent verbatim
    // overridden in .cpp:
    getViewport() const; line2d(p0,p1,color); rect2dImpl(...);

    // ALL of these THROW std::runtime_error("Invalid operation"):
    setObjectToWorldMatrix, box(AABox), box(CFrame), sphere(Sphere),
    sphere(CFrame,...) [note typo "Invalid ooperation"], explosion, cylinder,
    cylinderAlongX, cone, ray, line3d, line3dAA, axes, quad, convexPolygon2d,
    convexPolygon, extrusion(trajectory, trajSegs, profile, profSegs, color,
                             closeTrajectory=true, closeProfile=true)
};
```

The extrusion comment documents domain semantics: funcs evaluated on [0..1]; closed funcs reuse f(0) for f(1).

## Usage

Includes only `GfxBase/Adorn.h`. Wrap a real adorn when rendering pure screen-space UI so accidental 3D calls fail loudly instead of silently drawing wrong.

## Gotchas
- Throws are in headers, inline — exceptions propagate from call sites directly.
- Text path does NOT apply `screenOffset` (unlike line2d/rect2dImpl) — offset text manually.
- `getCamera()` NULL like other decorators.
