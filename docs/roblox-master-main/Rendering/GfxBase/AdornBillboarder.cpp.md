# AdornBillboarder.cpp

Source: `roblox-sandbox/Rendering/GfxBase/AdornBillboarder.cpp` (75 lines)

## Purpose

Implements `RBX::AdornBillboarder`, the 3D-billboard flavor of the 2D-adorn decorators: takes a transform (from a `ViewportBillboarder` or directly), sets it as the parent adorn's object-to-world matrix, and converts 2D primitives to billboard-plane 3D primitives with the UI→math y-flip.

## API

- `AdornBillboarder::AdornBillboarder(Adorn* parent, const ViewportBillboarder& viewportBillboarder)` — copies viewport + alwaysOnTop from the billboarder, applies `parent->setObjectToWorldMatrix(viewportBillboarder.getCoordinateFrame())`.
- `AdornBillboarder::AdornBillboarder(Adorn* parent, const Rect2D& viewport, const CoordinateFrame& transform, bool alwaysOnTop)` — explicit-transform variant.
- `Rect2D getViewport() const` — stored viewport.
- `void line2d(const Vector2&, const Vector2&, const Color4&)` → `parent->line3d` with `Vector3(p.x, -p.y, 0)`.
- `void rect2dImpl(x0y0, x1y0, x0y1, x1y1, tex0, tex1, color)` → `parent->quad(..., /*zIndex*/0, alwaysOnTop)` after y-negation of all corners.
- `void convexPolygon2d(const Vector2* v, int countv, const Color4&)` — stack-allocates (`_alloca` on `_WIN32`, `alloca` elsewhere) an array of `countv` Vector3s, converts each `(x, -y, 0)` — in-code comment: *"neg y : convert from ui space (0,0 top left) to math space"* — then `parent->convexPolygon(v3d, countv, color)`.

Includes: `GfxBase/AdornBillboarder.h`, `GfxBase/ViewportBillboarder.h`, `V8DataModel/Camera.h`.

## Usage

The ViewportBillboarder-taking ctor is the usual entry: update the billboarder each frame, then construct this decorator around it for drawing name-tags/billboards.

## Gotchas

- Same one-shot matrix hazard as AdornSurface: parent's object-to-world matrix is set in ctor, never restored.
- `_alloca`/`alloca` inside `convexPolygon2d`: no overflow guard on `countv`; huge counts can blow the stack.
- Unlike AdornSurface, text is not overridden here — base Adorn's text path applies.
