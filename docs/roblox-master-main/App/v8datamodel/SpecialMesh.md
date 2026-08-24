# SpecialMesh.cpp

## Purpose

Implements `SpecialShape` (instance name "Mesh", class constant sSpecialShape = "SpecialMesh"), the classic SpecialMesh DataModelMesh subclass: a MeshType enum selecting a built-in shape, with automatic switch to FileMesh whenever MeshId or TextureId is assigned. Registers the `MeshType` enum.

## Key types and API

Descriptor:
- `desc_meshType("MeshType")` — EnumPropDescriptor SpecialShape::MeshType, category_Data; default HEAD_MESH.

Enum `MeshType`: Head, Torso, Wedge, Brick, Sphere, Cylinder, FileMesh active; **Prism, Pyramid, ParallelRamp, RightAngleRamp, CornerWedge registered with deprecated() attributes** (still load old files).

Behavior:
- Ctor names instance "Mesh".
- `setMeshType`: change-tracked raise.
- `setMeshId` / `setTextureId`: on change delegate to Super (DataModelMesh storage) THEN force `setMeshType(FILE_MESH)` — assigning an id implicitly retypes the mesh.

## Usage / reflection touchpoints

Script-facing legacy mesh. Pairs with FileMesh.md/CharacterMesh.md family in this folder; DataModelMesh base for Scale/VertexColor properties.

## Gotchas

- Setting TextureId alone converts the mesh to FILE_MESH even with no MeshId — a texture-only assignment yields a file mesh pointing at nothing.
- Deprecated ramp/wedge mesh types remain selectable via enum conversion from old serialized data.
