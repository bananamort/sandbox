# App/include/v8datamodel/SelectionBox.h

## Purpose

`SelectionBox` — creatable `PVAdornment` drawing a box outline (surface color/transparency + line thickness) around its Adornee in 3D.

## Declared API

`class SelectionBox : public DescribedCreatable<SelectionBox, PVAdornment, sSelectionBox>`

- `void setSurfaceColor(Color3)` / inline `Color3 getSurfaceColor() const`.
- `void setSurfaceBrickColor(BrickColor)` / inline `BrickColor getSurfaceBrickColor() const { return BrickColor::closest(surfaceColor); }` — getter quantizes through the BrickColor palette.
- `void setSurfaceTransparency(float)` / inline getter; `setLineThickness(float)` / inline getter.
- IAdornable: `/*override*/ void render3dAdorn(Adorn* adorn)`.
- Instance: `/*override*/ bool askSetParent(const Instance*) const { return true; }` — parenting unrestricted.
- Private: `Color3 surfaceColor; float surfaceTransparency; float lineThickness;`

## Gotchas

- Surface color is stored as Color3; BrickColor view is lossy via closest() — set/get asymmetry.
- All geometry comes from the inherited Adornee/Extents machinery ([Adornment.md](Adornment.md)).

## UNKNOWN

- Default values for color/transparency/thickness (set in ctor, out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/SelectionBox.md](../../v8datamodel/SelectionBox.md).
- Base: [Adornment.md](Adornment.md); siblings: [SelectionSphere.md](SelectionSphere.md), [SelectionLasso.md](SelectionLasso.md), [Handles.md](Handles.md).
