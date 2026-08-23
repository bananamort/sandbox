# ParametricPartInstance.cpp

## Purpose

Implements `ParametricPartInstance` (base for parametrically-shaped parts) and its concrete subclass `Wedge`, the sloped ramp brick. `sWedge = "WedgePart"` is declared here as the serialization name used by the Wedge class registration (in the header).

## Key types and API

- `class ParametricPartInstance : public PartInstance` — empty ctor/dtor; exists to host shared parametric-part behavior declared in the header.
- `class Wedge : public ParametricPartInstance` — ctor sets Name "Wedge" (display name; registered script name is "WedgePart" via sWedge), primitive geometry `GEOMETRY_WEDGE`, and surface type NORM_Y = NO_SURFACE (the sloped top face gets no studs/inlets). No reflection block here.

## Usage / reflection touchpoints

No REFLECTION macros in this TU. WedgePart's creatability and properties come from DescribedCreatable declarations in the header plus inherited PartInstance reflection.

## Gotchas

- Instance name vs display Name mismatch: setName("Wedge") at runtime, but the class/creator name is "WedgePart".
- Only the +Y face is NO_SURFACE; other faces keep default universal surfaces.
