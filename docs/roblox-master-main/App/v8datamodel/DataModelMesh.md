# DataModelMesh.cpp

## Purpose

Implements `DataModelMesh` ("DataModelMesh") — the base class for part-attached decorative meshes (Block/Cylinder/Bevel/Special families): Scale (NaN/Inf-sanitized), VertexColor, Offset, and per-axis LOD enums. Alpha is derived from the parent part's transparency.

## Key types and API

Descriptors (all category_Data, no Security:: arguments):
- `desc_scale("Scale")` — Vector3, default (1,1,1); setter replaces non-finite components with 0 ("avoids issues with tesselation while generating geometry").
- `desc_vertColor("VertexColor")` — Vector3, default (1,1,1).
- `desc_offset("Offset")` — Vector3, default 0.
- `desc_levelOfDetailX("LODX", STREAMING)` / `desc_levelOfDetailY("LODY", STREAMING)` — enum "LevelOfDetailSetting": High/Medium/Low; defaults HIGH_LOD.

Constants: `sDataModelMesh = "DataModelMesh"`; instance name defaults to "Mesh".

Behavior: compare-then-raise setters; `askSetParent` — PartInstance parents ONLY; `getAlpha()` reads parent PartInstance `getTransparencyUi()` (0 when unparented).

## Usage / reflection touchpoints

Base of [BlockMesh](BlockMesh.md)/[CylinderMesh](CylinderMesh.md)/[BevelMesh](BevelMesh.md)/[SpecialMesh](SpecialMesh.md); geometry consumers under [PartInstance](PartInstance.md) rendering.

## Gotchas

- Setting Scale to NaN silently becomes 0 — no error surfaces to scripts.
- LODX/LODY are STREAMING-category but the LOD machinery appears vestigial in this TU (UNKNOWN where consumed).
- askSetParent forbids ModelInstance parents — a mesh must be a DIRECT child of a part.
