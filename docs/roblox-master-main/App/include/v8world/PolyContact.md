# App/include/v8world/PolyContact.h

## Purpose

Base for analytic mesh-vs-mesh contacts ([PolyPolyContact.md](PolyPolyContact.md)) and shared machinery: maintains an array of `PolyConnector`s, matches new closest-feature connectors against surviving ones each frame so kernel state persists.

## Declared API

- `typedef RBX::FixedArray<PolyConnector*, CONTACT_ARRAY_SIZE> ConnectorArray;` — sized by `CONTACT_ARRAY_SIZE` (40) with in-header TODO "should only ever need 8" (an older size-12 typedef is commented out).
- `class PolyContact : public Contact`
  - `PolyContact(Primitive* p0, Primitive* p1);` ~dtor.
  - Member: `ConnectorArray polyConnectors;`
  - Private machinery: kernel add/remove of all connectors, `updateClosestFeatures()`, `float worstFeatureOverlap()`, `deleteConnectors(ConnectorArray&)`, `matchClosestFeatures(newConnectors)`, `PolyConnector* matchClosestFeature(PolyConnector*)`, `updateContactPoints()`.
  - Contact overrides: `deleteAllConnectors`, inline `numConnectors`, `getConnector(int)`, `computeIsColliding(float)`, `stepContact`.
  - Pure virtual: `/*implement*/ void findClosestFeatures(ConnectorArray&) = 0;`

## Gotchas

- Same connector-matching pattern as [CellContact.md](CellContact.md)'s CellMeshContact — near-duplicated by design.
- Subclasses decide feature selection; base only handles bookkeeping.

## Cross-links

- Base: [Contact.md](Contact.md); subclasses: [PolyPolyContact.md](PolyPolyContact.md), [BallPolyContact.md](BallPolyContact.md).
- Kernel connector types: [v8kernel/PolyConnectors.md](../v8kernel/PolyConnectors.md).
