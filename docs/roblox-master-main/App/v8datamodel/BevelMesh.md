# BevelMesh.cpp

## Purpose

Implements `BevelMesh` ("BevelMesh") — a DataModelMesh subclass carrying three scalar shaping parameters (Bevel, Roundness, Bulge) for beveled part rendering. Pure data holder: setters store + raise, nothing else.

## Key types and API

Descriptors (all category_Data, STREAMING):
- `desc_bevel("Bevel")` — float, get/set raise.
- `desc_roundness("Bevel Roundness")` — float. NOTE the descriptor's registered name contains a space; the Lua-facing property name would be "Bevel Roundness" as written.
- `desc_bulge("Bulge")` — float.
No Security:: arguments anywhere.

Constants: `sBevelMesh = "BevelMesh"`. Defaults all 0.0.

## Usage / reflection touchpoints

Consumed by mesh geometry builders under [Base](../../Base/) rendering; sibling meshes [BlockMesh](BlockMesh.md), [CylinderMesh](CylinderMesh.md), [SpecialMesh](SpecialMesh.md).

## Gotchas

- Setters raise unconditionally (no change compare) — every assignment fires PropertyChanged even for identical values.
- "Bevel Roundness" with a space is an odd descriptor name vs the camelCase norm; scripts addressing it by that literal string is the only path.
- No clamping/validation of any of the three floats.
