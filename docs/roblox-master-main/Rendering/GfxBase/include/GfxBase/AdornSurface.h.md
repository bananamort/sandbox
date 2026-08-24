# AdornSurface.h

Source: `roblox-sandbox/Rendering/GfxBase/include/GfxBase/AdornSurface.h` (56 lines)

## Purpose

An `Adorn` decorator that renders 2D content (lines, rects, text) as if painted on a plane anchored in 3D space — a "surface" transform applied to 2D drawing. All the pure-3D Adorn primitives (box, sphere, cylinder, etc.) are deliberately stubbed to no-ops; only 2D paths delegate to the parent adorn with transformed coordinates.

## API

```cpp
class RBX::AdornSurface : public Adorn {
    Adorn* parent;
    Rect2D viewport;
    bool alwaysOnTop;
public:
    AdornSurface(Adorn* parent, const Rect2D& viewport,
                 const CoordinateFrame& transform, bool alwaysOnTop = false);
    virtual bool useFontSmoothScalling() { return false; }   // [sic] typo preserved
    void setTexture(int id, const RBX::TextureProxyBaseRef& texture);
    Rect2D getTextureSize(const RBX::TextureProxyBaseRef& texture) const;
    void line2d(const Vector2& p0, const Vector2& p1, const Color4& color);
    void rect2dImpl(const Vector2& x0y0, ..., const Color4& color);
    Vector2 get2DStringBounds(const std::string& s, float size, Text::Font font,
                              const Vector2& availableSpace) const;
    Vector2 drawFont2DImpl(Adorn* target, const std::string& s, const Vector2& pos2D,
        float size, bool autoScale, const Color4& color, const Color4& outline,
        Text::Font font, Text::XAlign xalign, Text::YAlign yalign,
        const Vector2& availableSpace, const Rect2D& clippingRect,
        const Rotation2D& rotation);
    // delegating pass-throughs:
    const Camera* getCamera() const;                       // returns 0 always
    TextureProxyBaseRef createTextureProxy(...);           // -> parent
    rbx::signal<void()>& getUnbindResourcesSignal();       // -> parent
    Rect2D getViewport() const;
    // ALL of these are empty no-op overrides:
    setObjectToWorldMatrix, line3d, line3dAA, box(AABox), box(CFrame,...),
    sphere(Sphere), sphere(CFrame,...), explosion, cylinder, cylinderAlongX,
    cone, ray, axes, quad, convexPolygon, convexPolygon2d, extrusion
};
```

## Usage

Implemented in `AdornSurface.cpp` (same dir). Includes `GfxBase/Adorn.h`, `V8DataModel/Workspace.h`, `util/UDim.h`.

## Gotchas

- `getCamera()` hardcodes `return 0` — any callee dereferencing it through this decorator will null-deref.
- `useFontSmoothScalling` misspelling is part of the virtual contract (matches base `Adorn`).
- The ctor's `transform` CoordinateFrame is NOT stored on this object — it is pushed onto the *parent* adorn once (`parent->setObjectToWorldMatrix(transform)` in AdornSurface.cpp's ctor) and this decorator keeps no copy; subsequent 2D→3D mapping relies entirely on that one-shot parent state.
