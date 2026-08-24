# App/include/v8world/ContactManagerSpatialHash.h

## Purpose

Concrete instantiation of the multi-resolution spatial hash template for contact broadphase: hashes `Primitive`s and reports `Contact` pairs back to `ContactManager`, with 4 grid levels.

## Declared API

- `#define CONTACTMANAGER_MAXLEVELS 4`
- `class ContactManagerSpatialHash : public SpatialHash<Primitive, Contact, ContactManager, CONTACTMANAGER_MAXLEVELS>`
  - `ContactManagerSpatialHash(World* world, ContactManager* contactManager);`

All behavior (insert/update/pair callbacks) is inherited from the template — see [SpatialHashMultiRes.md](SpatialHashMultiRes.md) (folds SpatialHashMultiRes.inl).

## Gotchas

- Template params bind the hash to exactly one owner (`ContactManager`): pair callbacks land there, not in World.

## Cross-links

- Owner: [ContactManager.md](ContactManager.md); template: [SpatialHashMultiRes.md](SpatialHashMultiRes.md), mixin: [BasicSpatialHashPrimitive.md](BasicSpatialHashPrimitive.md).
