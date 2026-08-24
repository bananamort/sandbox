# BlockMesh.cpp

## Purpose

Implements `BlockMesh` ("BlockMesh") — the entire TU is one line: the class-name constant definition `sBlockMesh = "BlockMesh"`. All behavior lives header-side (it's a DataModelMesh with default box scaling semantics).

## Key types and API

- `const char* const RBX::sBlockMesh = "BlockMesh";` — that's all.

No descriptors, no Security:: tiers, no methods in this TU.

## Usage / reflection touchpoints

Creatable via its DescribedCreatable base declared in the header; sibling meshes [CylinderMesh](CylinderMesh.md), [BevelMesh](BevelMesh.md), [SpecialMesh](SpecialMesh.md) share the DataModelMesh Scale/VertexColor machinery.

## Gotchas

- Don't expect TU-level logic: Scale/VertexColor behavior documented under DataModelMesh.md ([DataModelMesh](DataModelMesh.md)) applies here unchanged.
