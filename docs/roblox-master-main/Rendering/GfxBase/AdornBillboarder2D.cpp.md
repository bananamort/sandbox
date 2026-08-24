# AdornBillboarder2D.cpp

Source: `roblox-sandbox/Rendering/GfxBase/AdornBillboarder2D.cpp` (29 lines)

## Purpose

Implements the two screen-space primitives of `RBX::AdornBillboarder2D`: a decorator that draws 2D lines/rects through a parent `Adorn` while offsetting every coordinate by a fixed `screenOffset`. It is how UI drawn in a billboarded/screen-local space lands correctly inside a sub-viewport without each caller adding the offset itself.

## API

- `RBX::AdornBillboarder2D::AdornBillboarder2D(Adorn* parent, const Rect2D& viewport, const Vector2& screenOffset)` — stores all three; `parent` is a raw non-owning pointer.
- `Rect2D AdornBillboarder2D::getViewport() const` — returns the stored viewport unchanged (offset NOT applied).
- `void AdornBillboarder2D::line2d(const Vector2& p0, const Vector2& p1, const Color4& color)` — forwards to `parent->line2d(p0 + screenOffset, p1 + screenOffset, color)`.
- `void AdornBillboarder2D::rect2dImpl(const Vector2& x0y0, const Vector2& x1y0, const Vector2& x0y1, const Vector2& x1y1, const Vector2& tex0, const Vector2& tex1, const Color4& color)` — adds `screenOffset` to the four corner positions only; texture coords pass through unmodified.

## Usage

Part of the billboarder family alongside `AdornBillboarder` (3D) and `ViewportBillboarder`; consumed by code that renders adornments relative to a tracked screen rect. Base-class pure virtuals implemented here are only `line2d` and `rect2dImpl`.

## Gotchas

- Only position args are offset — `tex0/tex1` UVs deliberately untouched.
- Raw `parent` pointer: the billboarder must not outlive its `Adorn`.
- `getViewport()` ignores `screenOffset`; callers wanting offset space must add it themselves.
