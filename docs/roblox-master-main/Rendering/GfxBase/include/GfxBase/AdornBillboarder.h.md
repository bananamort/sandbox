# AdornBillboarder.h

Source: `roblox-sandbox/Rendering/GfxBase/include/GfxBase/AdornBillboarder.h` (186 lines)

## Purpose

The 3D-billboard `Adorn` decorator: 2D primitives are re-projected onto a billboard plane in world space (via parent's object-to-world matrix set at construction), while direct 3D primitives throw. Nearly line-identical to `AdornBillboarder2D.h`; the differences are the ctor set (ViewportBillboarder-aware) and `convexPolygon2d`, which is IMPLEMENTED (converts to 3D) instead of throwing.

## API

```cpp
class RBX::AdornBillboarder : public Adorn {
    Adorn* parent; Rect2D viewport; bool alwaysOnTop;
public:
    AdornBillboarder(Adorn* parent, const ViewportBillboarder& viewportBillboarder);
    AdornBillboarder(Adorn* parent, const Rect2D& viewport,
                     const CoordinateFrame& transform, bool alwaysOnTop = false);

    // inline pass-throughs to parent:
    createTextureProxy(id, waiting, bBlocking=false, context="");
    getUnbindResourcesSignal();
    getCamera() -> NULL (virtual);
    setTexture(id, texture); getTextureSize(texture);
    useFontSmoothScalling() -> true;   // [sic]
    get2DStringBounds(s, size, font, availableSpace);
    drawFont2DImpl(target, s, position, size, autoScale, color, outline,
                   font, xalign, yalign, availableSpace, clippingRect, rotation);
    // implemented in .cpp:
    getViewport(); line2d(p0,p1,color); rect2dImpl(...); convexPolygon2d(v,countv,color);

    // THROW std::runtime_error("Invalid operation"):
    setObjectToWorldMatrix, box×2, sphere×2, explosion, cylinder,
    cylinderAlongX, cone, ray, line3d, line3dAA, axes, quad, convexPolygon,
    extrusion(trajectory, trajectorysegments, profile, profilesegments,
              color, closeTrajectory=true, closeProfile=true)
};
```

Extrusion comment: funcs evaluated on [0..1]; closed funcs reuse f(0) as f(1).

## Usage

Includes only `GfxBase/Adorn.h`; forward-declares ViewportBillboarder. Standard usage pairs with an updated ViewportBillboarder for name-tags/billboard GUIs.

## Gotchas
- Unlike AdornBillboarder2D: text still passes through untransformed by the offset machinery.
- `convexPolygon2d` uses alloca — stack risk on large vertex counts.
- Same one-shot matrix side effect on parent at construction (see AdornBillboarder.cpp doc).
