# App/include/v8kernel/BulletShapeConnectors.h

## Purpose

Bridge connectors between the Roblox kernel and Bullet collision: `BulletShapeConnector` ([PolyConnector.md](PolyConnectors.md) subclass) wraps a Bullet narrowphase manifold pair, and `BulletShapeCellConnector` specializes it for terrain-cell collisions. These carry contact points produced by Bullet's `btPersistentManifold` into kernel contacts.

## Declared API

- Includes Bullet headers (`btPersistentManifold.h`, `btCollisionDispatcher.h`, `btCollisionObject.h`, `btBulletCollisionCommon.h`) — this header drags Bullet types into every includer.
- `class BulletShapeConnector : public PolyConnector, public Allocator<BulletShapeConnector>`
  - Ctor: `(Body* b0, Body* b1, const ContactParams&, btCollisionObject* colObj0, btCollisionObject* colObj1, btCollisionAlgorithm* algo, int manifoldIndex, int cacheIndex)` → forwards `(b0, b1, params, 0, 0)` to PolyConnector; dtor.
  - Protected state: `btCollisionObject* bulletCollisionObject0/1; btCollisionAlgorithm* bulletAlgo; int bulletManifoldIndex, bulletPointCacheIndex;`
  - Protected ops: `void updateConnectorPointFromManifold(bool refreshContacts = true); void realignConnectorsToBulletContacts(); bool foundValidContactPointFromBulletManifold(btPersistentManifold*, Vector3& p0World, Vector3& p1World);` private `GeoPairType getConnectorType()` → `BULLET_SHAPE_CONNECTOR`, `bool validObjectCFrames(); virtual void updateBulletCollisionObjects();`
  - Public: `updateContactPoint()` override; `void findValidContactAfterNarrowphase(); bool recalculateValidPoints(btManifoldArray&, Vector3& pt0InWorld, Vector3& pt1InWorld);` index accessors `setBulletManifoldPointIndex(int) / getBulletManifoldIndex() / getBulletPointCacheIndex()`; `refreshIndividualPoint(bool swapped, Vector3 pt0InWorld, Vector3 pt1InWorld, btManifoldArray&); void updatePointWithTransform(bool swapped, btManifoldPoint&); bool isPointInvalid(btManifoldPoint&, double validThreshold);` static `match(oldCon, newCon)` — same manifold+cache indices and type.
- `class BulletShapeCellConnector : public BulletShapeConnector` — same ctor signature; `getConnectorType()` → `BULLET_SHAPE_CELL_CONNECTOR`; overrides `updateBulletCollisionObjects()` and `updateContactPoint()`; own static `match`.

## Gotchas

- Contact polarity can be **swapped** relative to body order — the `swapped` parameter threads through refresh/update paths; ignoring it flips normals.
- `match()` compares only indices + type: two different body pairs sharing a manifold index would falsely match if index spaces aren't per-pair.
- `updateContactPoint` is overridden twice (base + cell variant) — behavior differs for cell (terrain) contacts.
- The ctor passes `0, 0` as PolyConnector's last two args (surface ids unused here).
