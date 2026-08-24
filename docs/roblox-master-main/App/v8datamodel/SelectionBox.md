# SelectionBox.cpp

## Purpose

Implements `SelectionBox` ("SelectionBox"), a DescribedCreatable PVAdornment drawing wireframe edges plus optional translucent fill box around a PartInstance or ModelInstance adornee. The classic part-highlight adornment.

## Key types and API

Descriptors (category_Appearance):
- `prop_SurfaceColor("SurfaceColor3")` — Color3, cap STANDARD; default brickBlue color3.
- `prop_depSurfaceBrickColor("SurfaceColor")` — BrickColor, marked deprecated → forwards to SurfaceColor3, caps LEGACY_SCRIPTING.
- `prop_SurfaceTransparency("SurfaceTransparency")` — float, default 1 (invisible fill by default).
- `prop_LineThickness("LineThickness")` — float, default 0.15.

DFFlag referenced: GuiBase3dReplicateColor3WithBrickColor (extern; base-class color replication behavior).

Rendering:
- Free helper `renderPart(adorn, part, color, transparency, surfaceColor, surfaceTransparency, lineThickness)`: line box drawn when transparency < 1 (`Draw::selectionBox` with alpha color); fill box when surfaceTransparency < 1 (`adorn->box` over ±gridSize/2 in part frame).
- `render3dAdorn`: only when getVisible() AND adornee alive; PartInstance renders directly, ModelInstance renders via `computePart()` (aggregate extents part).

## Usage / reflection touchpoints

Script-creatable adornment (Highlight-era predecessor). Pairs with SelectionSphere.md / SelectionLasso.md / HandleAdornment.md family in this folder; Adorn draw layer under Rendering docs.

## Gotchas

- Model adornees render ONE aggregate box (computePart), not per-part outlines.
- Defaults make the FILL invisible (surfaceTransparency=1) — only edges show unless configured.
- Setting SurfaceColor (BrickColor legacy prop) writes through to SurfaceColor3 but reading it goes through getSurfaceBrickColor conversion path.
- UNKNOWN: computePart() semantics header-side; exact Draw::selectionBox edge geometry lives AppDraw.
