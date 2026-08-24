# App/include/v8datamodel/FaceInstance.h

## Purpose

`FaceInstance` — abstract base for Instances that attach to a face of their parent Part (per the class comment): carries the `NormalId face` selector and draws 3D selection adornment on that face. [Decal](Decal.md) and the texture trail family build on it.

## Declared API

`class FaceInstance : public Reflection::Described<FaceInstance, sFaceInstance, Instance>, public IAdornable`

- Prop: `static const Reflection::EnumPropDescriptor<FaceInstance, NormalId> prop_Face;` `NormalId getFace() const { return face; } void setFace(RBX::NormalId value);`
- `FaceInstance(void);`
- Overrides: `bool askSetParent(const Instance*) const;` IAdornable `void render3dSelect(Adorn*, SelectState);`

## Gotchas

- Uses raw `Reflection::Described<>` rather than DescribedCreatable — it is not script-creatable directly.
- Parent must be a Part (askSetParent logic in .cpp).

## Cross-links

- Implementation: [App/v8datamodel/FaceInstance.md](../../v8datamodel/FaceInstance.md).
- Child: [Decal.md](Decal.md).
