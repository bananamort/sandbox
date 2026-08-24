# App/include/v8datamodel/BasicPartInstance.h

## Purpose

Two part-class layers: `FormFactorPart` (non-creatable [PartInstance](PartInstance.md) subclass that owns the serialized `FormFactor` with UI/XML setter split) and `BasicPartInstance` ("Part" creatable — the plain block/ball/etc. part carrying a legacy shape enum).

## Declared API

`class FormFactorPart : public DescribedNonCreatable<FormFactorPart, PartInstance, sFormFactorPart>`

- `virtual FormFactor getFormFactor() const { return formFactor; }` (member implied by inline body)
- Dual-channel setters: `void setFormFactorUi(FormFactor value);` / `void setFormFactorXml(FormFactor value);`
- Serialization: `void readProperty(const XmlElement* propertyElement, IReferenceBinder& binder);`
- Extension hook: `protected: virtual void validateFormFactor(FormFactor& value) {}` (no-op default).
- `FormFactorPart(); virtual ~FormFactorPart();`

`class BasicPartInstance : public DescribedCreatable<BasicPartInstance, FormFactorPart, sBasicPart>`

- Reflection: `static const Reflection::EnumPropDescriptor<BasicPartInstance, LegacyPartType> prop_shapeXml;`
- `bool hasThreeDimensionalSize() override virtual;`
- Shape setters: `void setLegacyPartTypeUi(LegacyPartType _type); void setLegacyPartTypeXml(LegacyPartType _type);`
- `virtual PartType getPartType() const override;`
- `LegacyPartType getLegacyPartType() const { return legacyPartType; }`
- Private override: `void validateFormFactor(FormFactor& value);`

## Gotchas

- Ui vs Xml setter split exists on both classes — one path likely clamps/validates differently (validation in .cpp).
- `prop_shapeXml` is typed to the *legacy* `LegacyPartType` enum while runtime type is modern `PartType` — conversion happens in .cpp.
- FormFactorPart itself is non-creatable: only subclasses (this "Part", plus wedge/corner/ramp family elsewhere) are script-visible.

## UNKNOWN

- Which form factors BasicPartInstance's `validateFormFactor` permits (.cpp).

## Cross-links

- Implementation: [App/v8datamodel/BasicPartInstance.md](../../v8datamodel/BasicPartInstance.md).
- Base: [PartInstance.md](PartInstance.md); shape siblings [CornerWedgeInstance.md](CornerWedgeInstance.md), [PrismInstance.md](PrismInstance.md), [PyramidInstance.md](PyramidInstance.md).
