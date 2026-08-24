# App/include/v8datamodel/SelectionSphere.h

## Purpose

`SelectionSphere` — creatable `PVAdornment` drawing a translucent sphere (surface color/transparency) around its Adornee. Structurally identical to [SelectionBox](SelectionBox.md) minus line thickness.

## Declared API

`class SelectionSphere : public DescribedCreatable<SelectionSphere, PVAdornment, sSelectionSphere>`

- `void setSurfaceColor(Color3)` / inline getter.
- `void setSurfaceBrickColor(BrickColor)` / inline `getSurfaceBrickColor() { return BrickColor::closest(surfaceColor); }` — lossy palette view.
- `setSurfaceTransparency(float)` / inline getter.
- IAdornable: `/*override*/ void render3dAdorn(Adorn*)`.
- Instance: `askSetParent { return true; }`.
- Private: `Color3 surfaceColor; float surfaceTransparency;`

## Gotchas

- Sphere radius derives from Adornee extents, not a settable property.
- Same Color3-storage/BrickColor-view asymmetry as SelectionBox.

## UNKNOWN

- Ctor defaults (out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/SelectionSphere.md](../../v8datamodel/SelectionSphere.md).
- Base: [Adornment.md](Adornment.md); siblings: [SelectionBox.md](SelectionBox.md), [SelectionLasso.md](SelectionLasso.md).
