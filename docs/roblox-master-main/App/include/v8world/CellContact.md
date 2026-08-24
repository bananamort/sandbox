# App/include/v8world/CellContact.h

## Purpose

Terrain-cell contacts: `CellContact` is a `Contact` tagged with the `Vector3int32` grid feature it touches; `CellMeshContact` extends it with a `POLY::Mesh` for the cell and the connector-matching machinery that keeps kernel connectors stable across frames. Also hosts two file-scope terrain helpers.

## Declared API

- File-scope data/helpers:
  - `const Vector3int16 kFaceDirectionToLocationOffset[7]` — +X,+Z,−X,−Z,+Y,−Y,(0,0,0) neighbor offsets indexed by `Voxel::FaceDirection`.
  - `static inline Voxel::FaceDirection oppositeSideOffset(Voxel::FaceDirection f)` — table {MinusX, MinusZ, PlusX, PlusZ, MinusY, PlusY}.
- `class CellContact : public Contact`
  - `CellContact(Primitive* p0, Primitive* p1, const Vector3int32& gridFeature);`
  - `const Vector3int32& getGridFeature() const;` protected member `gridFeature`.
  - `virtual ContactType getContactType() const → Contact_Cell`.
- `class CellMeshContact : public CellContact`
  - `typedef RBX::FixedArray<PolyConnector*, CONTACT_ARRAY_SIZE> ConnectorArray;` — in-header TODO: "should only ever need 8" (sized by `CONTACT_ARRAY_SIZE = 40`).
  - `CellMeshContact(Primitive*, Primitive*, const Vector3int32&); ~CellMeshContact();`
  - `POLY::Mesh* getCellMesh(void);` member `POLY::Mesh* cellMesh` (starts NULL).
  - `bool cellFaceIsInterior(const Vector3int16& mainCellLoc, Voxel::FaceDirection faceDir);`
  - Private machinery: kernel add/remove of connectors, `updateClosestFeatures()`, `worstFeatureOverlap()`, `deleteConnectors/matchClosestFeatures/matchClosestFeature`, `updateContactPoints()`.
  - Contact overrides: `deleteAllConnectors`, inline `numConnectors`, `getConnector(int)`, `computeIsColliding(float)`, `stepContact`.
  - Pure virtual: `/*implement*/ void findClosestFeatures(ConnectorArray& newConnectors) = 0;`

## Gotchas

- The header defines a non-static const global array (`kFaceDirectionToLocationOffset`) at namespace scope in a widely-included header → one copy per TU unless deduped; treat as read-only.
- ConnectorArray is 40 but comment says ≤8 needed — memory over-allocation accepted for uniformity.
- Subclasses must implement `findClosestFeatures`; base asserts nothing if you forget (pure virtual enforces).

## Cross-links

- Subclasses: [BallCellContact.md](BallCellContact.md), [BulletShapeCellContact.md](BulletShapeCellContact.md); base: [Contact.md](Contact.md).
- Face directions & grids: [../voxel/INDEX.md](../voxel/INDEX.md), [../voxel2/INDEX.md](../voxel2/INDEX.md).
