# Adorn.cpp

Source: `roblox-sandbox/Rendering/GfxBase/Adorn.cpp` (105 lines)

## Purpose

Non-inline conveniences of the abstract `RBX::Adorn` interface: outlined-rectangle construction from four filled rects, `rect2d` overloads that default UVs/apply rotation or software clipping, and `drawFont2D` forwarding to the virtual `drawFont2DImpl`.

## API

- `template<Modifier> static void outlineRect2dImpl(adorn, rect, thick, color, modifier)` — emits FOUR rect2d calls: left edge `(x0−thick..x0)`, right edge `(x1..x1+thick)` (note right/bottom edges extend +thick outward), top band, bottom band.
- `void Adorn::outlineRect2d(const Rect2D&, float thick, const Color4&)` — no modifier.
- `void Adorn::outlineRect2d(rect, thick, color, const Rotation2D&)` — rotation passed through to each edge rect.
- `void Adorn::outlineRect2d(rect, thick, color, const Rect2D& clipRect)` — clipRect as modifier.
- `void Adorn::rect2d(rect, color)` / `(rect,color,Rotation2D)` / `(rect,color,clipRect)` — default UV (0,0)-(1,1).
- `void Adorn::rect2d(rect, texul, texbr, color)` → Rotation2D() variant.
- `void Adorn::rect2d(rect, texul, texbr, color, const Rotation2D&)` — if rotation non-empty, rotates all four corners then calls `rect2dImpl`.
- `void Adorn::rect2d(rect, texul, texbr, color, const Rect2D& clipRect)` — SOFTWARE CLIP: intersects rect with clipRect and proportionally adjusts both U and V ranges by the clipped fractions (guards divide-by-zero on zero width/height); calls rect2dImpl with intersected geometry. Skips work when `clipRect == rect`.
- `Vector2 Adorn::drawFont2D(s, position, size, autoScale, color, outline, font, xalign, yalign, availableSpace, clippingRect, rotation)` — forwards to `drawFont2DImpl(this, ...)`.

## Usage

The only .cpp backing Adorn; everything else in Adorn.h is pure virtual implemented by backends/decorators.

## Gotchas
- Outline rects are asymmetric: left/top edges inset by thick, right/bottom outset — outline is NOT centered on the border.
- Clipping path adjusts upperUV by `(intersect.x1 − rect.x1)` which can push upperUV BELOW lowerUV when clipped on the right — matches inverted-V semantics of rect2dImpl's tex args (verify per-backend).
- `rect2d(...,Rotation2D)` ignores clipRect entirely; combined rotate+clip requires manual composition.
