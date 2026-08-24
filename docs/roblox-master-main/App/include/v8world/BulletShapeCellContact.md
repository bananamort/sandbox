# App/include/v8world/BulletShapeCellContact.h

## Purpose

Part↔terrain-cell contact using Bullet narrow phase: wraps the contacted cell in an embedded `btCollisionObject` (optionally a custom shared `btCollisionShape` for smooth-terrain features) and maintains matched `BulletShapeCellConnector`s like [BulletShapeContact.md](BulletShapeContact.md). Also re-pushes terrain material friction/elasticity per connector.

## Declared API

- `class BulletShapeCellContact : public CellMeshContact`
  - `typedef RBX::FixedArray<BulletShapeCellConnector*, BULLET_CONTACT_ARRAY_SIZE> BulletConnectorArray;`
  - Ctors:
    - `BulletShapeCellContact(Primitive* p0, Primitive* p1, const Vector3int16& cell, World* contactWorld);`
    - `BulletShapeCellContact(Primitive* p0, Primitive* p1, const Vector3int32& feature, const shared_ptr<btCollisionShape>& customShape, World* contactWorld);` — smooth-terrain feature variant.
  - `~BulletShapeCellContact();`
  - Members: `btCollisionAlgorithm* bulletNPAlgorithm; btCollisionObject bulletCollisionObject;` ("collision object for the cell involved in contact"), `shared_ptr<btCollisionShape> customShape; BulletConnectorArray polyConnectors; World* world;`
  - Private machinery: kernel add/remove of connectors, `updateClosestFeatures()`, `worstFeatureOverlap()`, `deleteConnectors/matchClosestFeatures/matchClosestFeature`, terrain-materials `updateContactParemeters(btCollisionObject*, BulletConnectorArray&)` *(sic)*, `newBulletShapeCellConnector(btCollisionObject*, btCollisionObject*, btCollisionAlgorithm*, int manifoldIndex, int contactIndex)` — comment: "use a BulletShapeConnector to represent this connector (we don't need a specific BulletShapeCellConnector)", `updateContactPoints()`, `computeManifoldsWithBulletNarrowPhase(btManifoldArray&)`.
  - Contact overrides: `deleteAllConnectors`, inline `numConnectors() {return polyConnectors.size();}`, `getConnector(int)`, `computeIsColliding(float)`, `stepContact()`, `invalidateContactCache()`.
  - `findClosestFeatures(ConnectorArray&)` override = `{RBXASSERT(0);}` — **must not be called** with compound narrow phase ("it generates too many connectors"); use `findClosestBulletCellFeatures(BulletConnectorArray&)` instead.

## Gotchas

- Two constructors select two different cell representations (voxel cell id vs arbitrary feature shape); downstream code must know which was used.
- The asserted-out `findClosestFeatures(ConnectorArray&)` is a trap inherited from the base interface — calling it via base pointer asserts in dev and misbehaves in ship.

## Cross-links

- Base: [CellContact.md](CellContact.md), [Contact.md](Contact.md); part twin: [BulletShapeContact.md](BulletShapeContact.md).
- Terrain grids: [../voxel/INDEX.md](../voxel/INDEX.md), [../voxel2/INDEX.md](../voxel2/INDEX.md); kernel side: [v8kernel/ContactConnector.md](../v8kernel/ContactConnector.md).
