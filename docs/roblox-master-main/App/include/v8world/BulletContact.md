# App/include/v8world/BulletContact.h

## Purpose

Legacy-style bridge contacts that drive collision through Bullet's broad/narrow phase (`btCollisionAlgorithm` + manifold arrays) while exposing standard Roblox `Contact`/`ContactConnector` objects to the kernel. Defines three types: `BulletConnector`, `BulletContact` (part↔part), and `BulletCellContact` (part↔terrain cell).

## Declared API

- `class BulletConnector : public ContactConnector, public Allocator<BulletConnector>`
  - `BulletConnector(Body* b0, Body* b1, const ContactParams& contactParams, int manifoldIndex, int cacheIndex);`
  - Public data: `int bulletManifoldIndex; int bulletPointCacheIndex;`
- `typedef FixedArray<BulletConnector*, 4> BulletConnectorArray;` — hard cap of 4 contact points.
- `class BulletContact : public Contact`
  - `BulletContact(World* world, Primitive* p0, Primitive* p1); ~BulletContact();`
  - Contact overrides: `deleteAllConnectors()`, `numConnectors()`, `getConnector(int)`, `computeIsColliding(float overlapIgnored)`, `stepContact()`, `invalidateContactCache()`.
  - Members: `World* world; btCollisionAlgorithm* algorithm; btManifoldArray manifoldArray; BulletConnectorArray connectors;`
- `class BulletCellContact : public CellContact`
  - `BulletCellContact(World* world, Primitive* p0, Primitive* p1, const Vector3int32& feature, const shared_ptr<btCollisionShape>& cellShape);`
  - Same Contact override set **plus** `onPrimitiveContactParametersChanged()` (re-pushes terrain material params).
  - Extra members: `btCollisionObject cellCollisionObject;` (stack object for the one cell) and `shared_ptr<btCollisionShape> cellShape;`
  - Private: `void updateContactParemeters(btCollisionObject* cellObj);` *(sic — "Paremeters")*.

## Gotchas

- `BulletConnectorArray` is fixed at 4 — Bullet manifolds yielding more points must be truncated upstream.
- `cellCollisionObject` is embedded by value; its transform must be refreshed whenever the cell/part move (implementation detail in .cpp).
- Typo'd method name `updateContactParemeters` is part of this header's surface — don't "fix" call sites blindly.

## Cross-links

- Base chain: [Contact.md](Contact.md), [CellContact.md](CellContact.md); kernel side: [v8kernel/ContactConnector.md](../v8kernel/ContactConnector.md), [v8kernel/ContactParams.md](../v8kernel/ContactParams.md).
- Newer manifold→connector machinery: [BulletShapeContact.md](BulletShapeContact.md), [BulletShapeCellContact.md](BulletShapeCellContact.md).
