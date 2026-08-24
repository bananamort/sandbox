# FileMesh.cpp

## Purpose

Implements `FileMesh` ("FileMesh") — a DataModelMesh subclass adding MeshId (asset reference) and TextureId. Two compare-then-raise setters; everything else inherited.

## Key types and API

Descriptors (category_Data, no Security:: arguments):
- `desc_meshId("MeshId")` — MeshId.
- `desc_textureId("TextureId")` — TextureId (reflection plumbing defined in [Decal](Decal.cpp)-side specializations).

Constants: `sFileMesh = "FileMesh"`.

## Usage / reflection touchpoints

Base of [SpecialMesh](SpecialMesh.md) (which auto-switches its MeshType to FileMesh when MeshId is assigned); asset resolution via ContentProvider like [CharacterMesh](CharacterMesh.md) ids.

## Gotchas

- No validation or normalization of the ids — arbitrary strings accepted as URLs.
- Scale/VertexColor/Offset behavior comes from [DataModelMesh](DataModelMesh.md).
