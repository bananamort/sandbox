# AdornSurface.cpp

Source: `roblox-sandbox/Rendering/GfxBase/AdornSurface.cpp` (67 lines)

## Purpose

Implements `RBX::AdornSurface`: pushes a world transform onto the parent adorn at construction, then re-expresses 2D primitives as 3D ones on that plane — `line2d` → parent `line3d`, `rect2dImpl` → parent `quad`. Y coordinates are negated because UI space has (0,0) top-left while math space is bottom-up.

## API

- `AdornSurface::AdornSurface(Adorn* parent, const Rect2D& viewport, const CoordinateFrame& transform, bool alwaysOnTop)` — stores members and calls `parent->setObjectToWorldMatrix(transform)`.
- `Rect2D getViewport() const` — stored viewport verbatim.
- `void setTexture(int id, const RBX::TextureProxyBaseRef& t)` / `Rect2D getTextureSize(...)` — straight delegation to `parent`.
- `void line2d(const Vector2& p0, const Vector2& p1, const Color4&)` — builds `Vector3(p,0)`, negates `.y`, calls `parent->line3d`.
- `void rect2dImpl(x0y0, x1y0, x0y1, x1y1, tex0, tex1, color)` — all four corners to `Vector3(·,·,0)` with negated y, then `parent->quad(px0y0, px1y0, px0y1, px1y1, color, tex0, tex1, /*zIndex*/0, alwaysOnTop)`.
- `Vector2 drawFont2DImpl(target, s, pos2D, size, autoScale, color, outline, font, xalign, yalign, availableSpace, clippingRect, rotation)` — pure pass-through to parent (no transform applied!).
- `Vector2 get2DStringBounds(s, size, font, availableSpace) const` — pass-through.

## Usage

Only includes its own header. Consumers draw UI onto in-world surfaces via this wrapper.

## Gotchas

- The object-to-world transform is set ONCE on the parent at ctor time and never restored — the parent adorn keeps that matrix afterwards unless someone resets it.
- Text drawing (`drawFont2DImpl`) bypasses the surface transform entirely — text will NOT land on the transformed plane.
- `alwaysOnTop` from ctor feeds only the quad path.
