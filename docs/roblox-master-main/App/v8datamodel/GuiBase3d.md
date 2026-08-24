# GuiBase3d.cpp

## Purpose

Implements `GuiBase3d` ("GuiBase3d") — the base for 3D-world GUI adornments (selection boxes, handles, billboards): Color3 with deprecated BrickColor "Color" alias, Transparency, Visible. Visible changes mark render dirty.

## Key types and API

Descriptors:
- `prop_color("Color3", category_Appearance, STANDARD)` — Color3, default BrickColor::brickBlue().
- `prop_depBrickColor("Color", category_Appearance)` — BrickColor, `Attributes::deprecated(prop_color, LEGACY_SCRIPTING)`; setter forwards into setColor.
- `prop_transparency("Transparency", category_Appearance)` — float default 0.
- `prop_Visible("Visible", category_Data)` — bool default true; raise + shouldRenderSetDirty.

Constants: `sGuiBase3d = "GuiBase3d"`. No Security:: arguments.

## Usage / reflection touchpoints

Base of [Adornment](Adornment.md) PartAdornment/PVAdornment, [SelectionBox](SelectionBox.md)/[SelectionSphere](SelectionSphere.md), [HandlesBase](HandlesBase.md), [FloorWire](FloorWire.md).

## Gotchas

- Two registered color properties ("Color3" canonical, "Color" deprecated alias) — writing either raises only the Color3 descriptor's changed signal.
- No clamping on Transparency here.
