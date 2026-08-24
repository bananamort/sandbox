# CylinderMesh.cpp

## Purpose

Implements `CylinderMesh` ("CylinderMesh") — the entire TU is one line: the class-name constant `sCylinderMesh = "CylinderMesh"`. Behavior (DataModelMesh Scale/VertexColor semantics) lives header-side.

## Key types and API

- `const char* const RBX::sCylinderMesh = "CylinderMesh";` — that's all. No descriptors, no Security:: tiers.

## Usage / reflection touchpoints

Sibling of [BlockMesh](BlockMesh.md)/[BevelMesh](BevelMesh.md); shared mesh machinery under [DataModelMesh](DataModelMesh.md).

## Gotchas

- Despite the name, this is a legacy decorative mesh object distinct from the Part Shape=Cylinder geometry path in [BasicPartInstance](BasicPartInstance.md).
