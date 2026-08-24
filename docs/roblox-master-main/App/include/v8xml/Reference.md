# App/include/v8xml/Reference.h

## Purpose

Declares the streaming reference-resolution contracts: `IIDREF` (a property that can receive an instance handle by ID) and `IReferenceBinder` (the two-pass loader that collects `ID` declarations and `IDREF` requests, then resolves them). Used by XML/binary deserialization to wire up object references after all instances exist.

## Declared API

- Include guard `_568E368F53F1431aB7D4923F6D45021A` (GUID-style, not pragma once).
- `class RBXInterface IIDREF` ("Used for streaming")
  - Friend IReferenceBinder; private pure virtual `void assignIDREF(Reflection::DescribedBase* propertyOwner, const InstanceHandle& handle) const;`
- `class RBXBaseClass IReferenceBinder` ("Used for streaming")
  - Pure virtuals: `announceID(const XmlNameValuePair* valueID, DescribedBase* source);` `announceIDREF(const XmlNameValuePair* valueIDREF, DescribedBase* propertyOwner, const IIDREF* idref);` `bool resolveRefs();` virtual dtor.
  - Protected inline `assign(const IIDREF*, DescribedBase*, const InstanceHandle&)` — the only way to invoke the private assignIDREF.

## Usage notes

- Consumers: RefPropDescriptor::readValue announces IDREFs; serializers implement the binder.

## Gotchas

- The GUID include guard suggests this header is included from multiple legacy trees; pragma-once duplication avoided deliberately.
- resolveRefs returning false signals unresolved references — callers must decide whether to tolerate.
