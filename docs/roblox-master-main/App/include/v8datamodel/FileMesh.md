# App/include/v8datamodel/FileMesh.h

## Purpose

`FileMesh` Instance — mesh decoration loaded from an asset id, with a texture id; direct [DataModelMesh](DataModelMesh.md) child and base of SpecialMesh. Setters are virtual specifically because SpecialMesh mutates its MeshType enum when ids change.

## Declared API

`class FileMesh : public DescribedCreatable<FileMesh, DataModelMesh, sFileMesh>`

- `const MeshId& getMeshId() const { return meshId; }` / `virtual void setMeshId(const MeshId& value);`
- `const TextureId& getTextureId() const { return textureId; }` / `virtual void setTextureId(const TextureId& value);`
- `FileMesh();`
- Protected members: `TextureId textureId; MeshId meshId;`

## Gotchas

- Source comment: setters are virtual "because SpecialMesh automatically changes the enum type if this is called" — assigning a mesh id through a FileMesh* to a SpecialMesh retypes it.
- No local file support implied — ids resolve through content pipeline.

## UNKNOWN

- Which MeshType transitions trigger on set (.cpp — see [FileMesh.md](../../v8datamodel/FileMesh.md)).

## Cross-links

- Implementation: [App/v8datamodel/FileMesh.md](../../v8datamodel/FileMesh.md).
- Base: [DataModelMesh.md](DataModelMesh.md); sibling meshes: [SpecialMesh.md] (S–Z half), [BlockMesh.md](BlockMesh.md), [CylinderMesh.md](CylinderMesh.md), [BevelMesh.md](BevelMesh.md).
