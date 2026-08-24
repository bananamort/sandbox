# App/include/v8datamodel/GuiBase3d.h

## Purpose

Base for 3D adornment GUI ("adornment instances (3D objects that adorn Instances)" — per class comment): color/transparency/visible state feeding the IAdornable render gate; input-processing disabled by default.

## Declared API

`class GuiBase3d : public DescribedNonCreatable<GuiBase3d, GuiBase, sGuiBase3d>`

- `GuiBase3d(const char* name);`
- Appearance: `void setBrickColor(BrickColor)` / `BrickColor getBrickColor() const` (returning `BrickColor::closest(color)` — nearest palette match of the stored Color3); `setColor(Color3)/getColor()`; `setTransparency(float)/getTransparency()`; `setVisible(bool)/getVisible()`.
- IAdornable: `shouldRender3dAdorn() const { return getVisible(); }`
- GuiBase defaults: `canProcessMeAndDescendants() → false`, `getZIndex() → -1`, `getGuiQueue() → GUIQUEUE_GENERAL`.
- Protected state: `Color3 color; float transparency; bool visible;`

## Gotchas

- BrickColor view is lossy: stored value is Color3, getter snaps to closest palette entry.
- Z-index −1 keeps 3D adornments outside normal 2D ordering.

## UNKNOWN

- Where subclasses hook the actual draw (render3dAdorn overrides — see [GuiBase3d.md](../../v8datamodel/GuiBase3d.md)).

## Cross-links

- Implementation: [App/v8datamodel/GuiBase3d.md](../../v8datamodel/GuiBase3d.md).
- Base: [GuiBase.md](GuiBase.md); children: [Adornment.md](Adornment.md) (PartAdornment/PVAdornment), [FloorWire.md](FloorWire.md), selection family.
