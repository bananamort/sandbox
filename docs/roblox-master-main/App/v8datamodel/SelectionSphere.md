# SelectionSphere.cpp

## Purpose

Implements `SelectionSphere` ("SelectionSphere"), a DescribedCreatable PVAdornment rendering an outline sphere plus optional translucent fill sphere fitted to the adornee's minimum grid dimension. Sphere twin of SelectionBox.md.

## Key types and API

Descriptors (category_Appearance) — identical pattern to SelectionBox:
- `prop_SurfaceColor("SurfaceColor3")` — Color3 cap STANDARD, default brickBlue.
- `prop_depSurfaceBrickColor("SurfaceColor")` — BrickColor deprecated → SurfaceColor3, LEGACY_SCRIPTING.
- `prop_SurfaceTransparency("SurfaceTransparency")` — float default 1 (fill hidden).

Rendering (`renderPart` helper):
- radius = gridSize.min() × 0.5; outline thickness fixed 0.2 drawn with Material_Outline when transparency < 1; fill with Material_NoLighting when surfaceTransparency < 1; material restored to Default after.
- Adornee dispatch identical to SelectionBox (PartInstance direct, ModelInstance via computePart()).

## Usage / reflection touchpoints

Script-creatable adornment. Pairs with SelectionBox.md, SelectionLasso.md in this folder.

## Gotchas

- No LineThickness property here (unlike SelectionBox) — outline width hardcoded 0.2.
- Radius derives from MIN grid axis — stretched parts get undersized spheres.
- Model adornees collapse to one aggregate sphere via computePart().
