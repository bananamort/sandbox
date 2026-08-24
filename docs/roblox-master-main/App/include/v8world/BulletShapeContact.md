# App/include/v8world/BulletShapeContact.h

## Purpose

Part↔part contact that consumes Bullet persistent manifolds and maintains a matched set of `BulletShapeConnector`s across frames: new Bullet manifold points are matched to surviving connectors by closest-feature identity so kernel contact state (impulses, resting flags) persists while the underlying manifold churns.

## Declared API

- `class BulletShapeContact : public Contact`
  - `typedef RBX::FixedArray<BulletShapeConnector*, BULLET_CONTACT_ARRAY_SIZE> BulletConnectorArray;`
  - `BulletShapeContact(Primitive* p0, Primitive* p1, World* ourWorld); ~BulletShapeContact();`
  - Members: `btPersistentManifold* bulletManifold; btCollisionAlgorithm* bulletNPAlgorithm;` `BulletConnectorArray polyConnectors; World* world;` *(an unrelated `class bulletNPAlgorithm;` fwd decl at top of file is unused by these members)*
  - Private machinery: `removeAllConnectorsFromKernel()/putAllConnectorsInKernel()`, `updateClosestFeatures()`, `float worstFeatureOverlap()`, `matchClosestFeatures(BulletConnectorArray&)`, `BulletShapeConnector* matchClosestFeature(BulletShapeConnector*)`, `deleteConnectors(...)`, `newBulletShapeConnector(btCollisionObject*, btCollisionObject*, btCollisionAlgorithm*, int manifoldIndex, int contactIndex, bool swapped)`, `updateContactPoints()`, `computeManifoldsWithBulletNarrowPhase(btManifoldArray&)`.
  - Contact overrides: `deleteAllConnectors()`, `int numConnectors() {return polyConnectors.size();}` (inline), `getConnector(int)`, `computeIsColliding(float)`, `stepContact()`, `invalidateContactCache()`.
  - `/*implement*/ void findClosestFeatures(BulletConnectorArray& newConnectors);`

## Gotchas

- Connector lifetime is decoupled from manifold-point lifetime on purpose — the match/closest-feature update pass is what keeps contacts stable frame-to-frame.
- The `swapped` flag in `newBulletShapeConnector` exists because Bullet manifold ordering vs RBX primitive ordering can disagree.

## UNKNOWN

- Value/meaning of `BULLET_CONTACT_ARRAY_SIZE` (defined elsewhere, presumably [Contact.md](Contact.md)'s header chain).

## Cross-links

- Base: [Contact.md](Contact.md); terrain twin: [BulletShapeCellContact.md](BulletShapeCellContact.md); legacy variant: [BulletContact.md](BulletContact.md).
- Kernel connectors & contact params: [v8kernel/ContactConnector.md](../v8kernel/ContactConnector.md), [v8kernel/ContactParams.md](../v8kernel/ContactParams.md).
