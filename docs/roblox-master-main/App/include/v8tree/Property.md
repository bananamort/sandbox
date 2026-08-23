# App/include/v8tree/Property.h

## Purpose

Small support header for the v8tree property layer: declares `RBX::PropertyChanged`, an immutable wrapper around a `Reflection::Property` snapshot delivered by `Instance` change notifications (constructed only by `Instance`), plus the standard property-category string macros used across descriptors.

## Declared API

- `class PropertyChanged`
  - Wraps a private `RBX::Reflection::Property`; copy ctor only.
  - `const Reflection::Property& getProperty() const`, `const Reflection::PropertyDescriptor& getDescriptor() const`, `const RBX::Name& getName()`.
  - Private ctor `(const Reflection::Property&)`, `friend class Instance`.
- Category macros: `category_Data "Data"`, `category_Behavior "Behavior"`, `category_State "State"`, `category_Appearance "Appearance"`, `category_Team "Team"`, `category_Image "Image"`, `category_Video "Video"`, `category_Control "Control"` — with an in-source TODO suggesting they belong in Reflection.
- Includes pull in `Reflection/Property.h`, `V8Xml/Reference.h`, `V8Xml/XmlElement.h`, `Util/Object.h`, G3D Vector3/Color3.

## Usage notes

- Instances of this class appear as arguments to `onChildChanged(Instance*, const PropertyChanged&)` and similar notification hooks; use `getDescriptor()` for identity and `getProperty()` for old/new value access.

## Gotchas

- The category macros are unquoted-string #defines with no namespace/prefix — names like `category_Data` are collision-prone globally.
