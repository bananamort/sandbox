# App/include/v8datamodel/ExtrudedPartInstance.h

## Purpose

`ExtrudedPartInstance` ("TrussPart" — descriptor sExtrudedPart, part type TRUSS_PART): the truss/climbable beam part. Adds truss visual style plus strict resize rules (limited handle faces, fixed resize increment, XML size enforcement).

## Declared API

`class ExtrudedPartInstance : public DescribedCreatable<ExtrudedPartInstance, PartInstance, sExtrudedPart>`

- `enum VisualTrussStyle { FULL_ALTERNATING_CROSS_BEAM = 0 /*classic*/, BRIDGE_STYLE_CROSS_BEAM, NO_CROSS_BEAM };`
- Reflection: `static const EnumPropDescriptor<ExtrudedPartInstance, VisualTrussStyle> prop_styleXml;`
- `getPartType() → TRUSS_PART`.
- Size policy overrides: `const Vector3& getMinimumUiSize() const`; `Faces getResizeHandleMask() const`; `int getResizeIncrement() const`; `void setPartSizeXml(const Vector3& rbxSize);`
- Style: `void setVisualTrussStyle(VisualTrussStyle); VisualTrussStyle getVisualTrussStyle() const;`

## Gotchas

- Descriptor string is "ExtrudedPart" while the user-facing concept is TrussPart.
- prop_styleXml name suffix suggests XML-only serialization of the style.
- Resize behavior deliberately constrained (climbable beams need exact stud geometry).

## UNKNOWN

- Which faces the resize mask allows and the increment value (.cpp — see [ExtrudedPartInstance.md](../../v8datamodel/ExtrudedPartInstance.md)).

## Cross-links

- Implementation: [App/v8datamodel/ExtrudedPartInstance.md](../../v8datamodel/ExtrudedPartInstance.md).
- Base: [PartInstance.md](PartInstance.md); shape kin: [BasicPartInstance.md](BasicPartInstance.md), [CornerWedgeInstance.md](CornerWedgeInstance.md).
