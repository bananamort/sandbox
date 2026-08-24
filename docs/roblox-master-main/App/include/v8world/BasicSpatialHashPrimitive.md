# App/include/v8world/BasicSpatialHashPrimitive.h

## Purpose

Mixin base that any class stored in the multi-resolution `SpatialHash` must contain: it caches the primitive's last hashed integer extents and its current hash-grid level. Header for the contract consumed by `SpatialHashMultiRes` (see [SpatialHashMultiRes.md](SpatialHashMultiRes.md), which folds SpatialHashMultiRes.inl).

## Declared API

- Debug switch (commented out by default): `_RBX_DEBUGGING_SPATIAL_HASH` — when on, defines `RBXASSERT_SPATIAL_HASH(expr)` as a real assert, adds members `void* spatialNodes; int spatialNodeCount;`, and sets `const bool assertingSpatialHash = true;`; otherwise no-ops with `assertingSpatialHash = false`.
- `class BasicSpatialHashPrimitive`
  - Members: `ExtentsInt32 oldSpatialExtents; int spatialNodeLevel;` (+ debug pair above).
  - `BasicSpatialHashPrimitive()` — `spatialNodeLevel(-1)`.
  - `~BasicSpatialHashPrimitive()` — asserts `spatialNodeLevel == -1` (must have been removed from hash), then stamps `-2` as destroyed-sentinel.
  - `bool IsInSpatialHash() { return spatialNodeLevel > -1; }`
  - `int getSpatialNodeLevel() const` (asserts ≥ −1); `void setSpatialNodeLevel(int)`.
  - `const ExtentsInt32& getOldSpatialExtents() const; void setOldSpatialExtents(const ExtentsInt32&);`
  - `getOldSpatialMin()/getOldSpatialMax()` → `Vector3int32` refs into the extents.

## Gotchas

- Dtor asserts the object was removed from every hash node before destruction — deleting a still-hashed primitive is an asserted bug (and in release leaves stale pointers in the hash).
- The `-2` dtor sentinel means use-after-free of this mixin reads `spatialNodeLevel == -2` — handy for debugging, UB nonetheless.
- `oldSpatialExtents` is only meaningful while in the hash; it is scratch state owned by the hash update algorithm.

## Cross-links

- Consumer template: [SpatialHashMultiRes.md](SpatialHashMultiRes.md) (.inl folded), [ContactManagerSpatialHash.md](ContactManagerSpatialHash.md), [TerrainPartition.md](TerrainPartition.md).
- Integer extents type from Util (`ExtentsInt32`); float counterpart documented pattern in Base [MathUtil.h.md](../../../Base/include/rbx/MathUtil.h.md).
