# App/include/v8xml/WebSerializer.h

## Purpose

Declares `RBX::WebSerializer`, the static helper converting reflection containers (`ValueMap`/`ValueArray`/`Variant`) into XML elements for web API responses.

## Declared API

- `class RBX::WebSerializer`
  - `static XmlElement* writeTable(const RBX::Reflection::ValueMap& result);`
  - `static XmlElement* writeList(const RBX::Reflection::ValueArray& result);`
  - `static XmlElement* writeEntry(const std::string& key, const RBX::Reflection::Variant& value);`
  - `static XmlElement* writeValue(const RBX::Reflection::Variant& value);`

## Usage notes

- Counterpart to [WebParser.md](WebParser.md) which parses these forms back.
- Callers own the returned XmlElement pointers.

## Gotchas

- Raw owning pointers returned — no smart wrappers at this boundary.
