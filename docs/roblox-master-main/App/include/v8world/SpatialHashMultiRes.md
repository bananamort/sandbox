# App/include/v8world/SpatialHashMultiRes.h

## Purpose

The multi-resolution spatial hash driving contact broadphase: a hashed **octree** of grid cells at `MAX_LEVELS` zoom levels. Big primitives occupy coarse cells, small ones fine cells; pair callbacks fire when primitives first share a leaf region. `SpatialHashStatic` holds level math. This doc **folds `SpatialHashMultiRes.inl`** (all template implementations live there; the header ends with `#include "v8World/SpatialHashMultiRes.inl"`).

## Declared API

### Support types (header)
- `class NodeBase` — `short level; int hashId; Vector3int32 gridId;` dtor stamps `-2/-2` sentinels; `getLevel()` asserts ≥ −1.
- `enum enumAction { aRecurseTreeNode, aVisitSingleSpatialNode, aVisitAllSiblingsSpatialNodes };`
- `struct NodeInfo` — priority-queue payload `{node, action, intersectResult, distance}` with inverted-distance `operator<` (lower distance = visited first).
- `class SpatialHashStatic`
  - In `.cpp`: `static const int cellMinSize;` `static const int maxLevelForAnchored;` `getHash(level, grid)`, `computeMinMax(level, extents, min, max)`, `makeVisitOrder(int offsets[8], const Vector3& visitDir)`.
  - Inline (from the **.inl**): `hashGridSize(level) = float(cellMinSize << level)`, `hashGridRecip`, `numBuckets(level) → 65536` (**constant for every level**), `realToHashGrid(level, pt)` ("4 grids per hash bucket"), `scaleExtents(smallLevel, bigLevel, extents)` via `shiftRight`, `hashGridToReal[Extents]`.
  - `static const Extents safeExtents(const Extents&)` — NaN/Inf guard returning zero extents after assert.

### Template `SpatialHash<Primitive, Contact, ContactManager, MAX_LEVELS>`
- Nested interfaces:
  - `struct SpaceFilter` — pure `Intersects(const Extents&) → IntersectResult`, virtual `Distance(extents)` (default 0), pure `bool onPrimitive(Primitive*, IntersectResult, float distance)` (return false breaks iteration).
  - `class CoarseMovementCallback` — `UpdateInfo{UPDATE_TYPE_Insert|Change, old/new Level+SpatialExtents}`; pure `coarsePrimitiveMovement(p, info)`. Header warning: callback may fire during Lua edits — implementers must not mutate primitive extents/location (re-entrancy).
- Construction/stats: `SpatialHash(World*, ContactManager*, int maxCellsPerPrimitive);` `fastClear()` (deletes all nodes/tree nodes, releases allocator pools, rebuilds tables); `getNodesOut()`, `getMaxBucket()`, `doStats()` (body `#if 0`'d out in the .inl).
- Mutation API: `onPrimitiveAdded(p, addContact=true)`, `onPrimitiveRemoved(p)`, `onPrimitiveExtentsChanged(p)`, `onPrimitiveAssembled(p)` — the last re-scans neighbors once assembly topology is known ("rely on onNewPair() to do the filtering").
- Queries: `visitPrimitivesInSpace(SpaceFilter*, visitDir)` — loosely sorted walk (roots sorted by dot product, children by precomputed visit order); `visitPrimitivesInSpace(SpaceFilter*)` — strict ordering via `std::priority_queue<NodeInfo>` on `Distance`; `getPrimitivesInGrid(grid, out)` (walks all levels, halving coords) and level-specific overload; `getNextGrid(grid&, unitRay, maxDistance)` — ray-marches adjacent level-0 cells (face→edge→corner order) using G3D AABox collision, padding maxDistance by 2 leaf cells because "collision detection returns the first hit in a grid box"; `getPrimitivesTouchingGrids(extents, ignore|maxCount, answer)` ×2 (per-level scan, exact overlap re-check, early-out at maxCount); `template<Set> getPrimitivesOverlapping(extents, set)` (iterative, faster small regions) and `...Rec(...)` (recursive octree descent, faster large regions) — both shrink extents.max by 0.01 to avoid querying an extra cell layer for exactly aligned boxes and skip per-primitive tests when a whole cell is contained ("tests require reading Primitive memory which leads to extra cache misses").
- Callback registry: `registerCoarseMovementCallback/unregisterCoarseMovementCallback`.

### Internal structure (header decl + .inl impl)
- `TreeNode : NodeBase, Allocator<TreeNode>` — octree interior node: `unsigned short children[8]` (stores **child bucket hashes**, not pointers — 65536 buckets make this lossless), `unsigned char childMask`, `int refByPrimitives`, singly-linked `next`. Retired only when refcount hits 0 **and** no children remain (`retireTreeNode` → `_retireTreeNode` unlinks + deletes, then `removeTreeNodeChild` notifies ancestors, cascading retirement upward).
- `SpatialNode : NodeBase` — one entry per (primitive, occupied cell): `primitive`, `nextHashLink` bucket chain, `treeNode` back-pointer for levels > 0; debug-mode `next/prevPrimitiveLink` under `_RBX_DEBUGGING_SPATIAL_HASH`.
- `SpatialHashTableEntry { SpatialNode* nodes; TreeNode* treeNodes; }`; `std::vector<SpatialHashTableEntry> hashTables[MAX_LEVELS]` sized 65536 each; `rootLevel = MAX_LEVELS − 1`.
- Level assignment (`computeLevel`, .inl): volume of extents + `2×cellMinSize` slack ("extra buffer for thin objects") vs `cellMinSize³ × maxCellsPerPrimitive`, ×8 per level; anchored primitives capped at `maxLevelForAnchored`. **Level is fixed at insertion**: `onPrimitiveExtentsChanged` re-inserts only when growing or shrinking ≥2 levels ("grow always, shrink only if 2 steps down" hysteresis), else updates cells in place via union/difference box walks (`changeMinMax` adds/removes only differing cells).
- Pair generation: while inserting a node it walks same-level and ancestor buckets; new co-occupants produce `contactManager->onNewPair(p, other)` if `Primitive::getContact == NULL`, gated on `Primitive::hasGetFirstContact` (the compile-time duck-type flag from [Primitive.md](Primitive.md)); big primitives additionally pull `addContactFromChildren` down the octree. Removal runs `checkAndReleaseContacts` releasing pairs whose old extents no longer overlap.
- Allocation: header members `object_pool<TreeNode/SpatialNode, roblox_allocator>` with comment "remove these once we can confirm 'boost::pool' objects work" — but the .inl's `newNode/returnNode/createTreeNode/_retireTreeNode` use plain `new`/`delete` (pools currently vestigial). `fastClear` calls `Allocator<T>::releaseMemory()`.
- Threading: `ConcurrencyValidator` — write validator around mutations, read-only validator around queries/reports.
- Debug/validation (public "for unit testing"): `validateInsertNodeToPrimitive/RemoveNodeFromPrimitive/NodesOverlap/TallyTreeNodes/TreeNodeNotHere/Contacts/NoNodesOut` — active only under `_RBX_DEBUGGING_SPATIAL_HASH` (see [BasicSpatialHashPrimitive.md](BasicSpatialHashPrimitive.md)); `validateContacts` uses MSVC-only `__if_exists(Primitive::getFirstContact)`.

## Gotchas

- **Dead-code syntax error**: inside the non-default `visitPrimitivesInSpace(SpaceFilter*)` path, the `#else /* precise sorting */` branch at .inl line ~1324 has an extra closing paren — `nodestovisit.push(NodeInfo(...)));` — defining `PRECISE_SORTING` would not compile; the shipped path always takes the `#ifndef` variant (visits whole sibling groups at once).
- `children[8]` holding hashes means a TreeNode lookup by hash must still verify `gridId` — hash collisions across the 65536-bucket table are expected and handled by chain scans everywhere (`findTreeNode/findNode/hashHasPrimitive`).
- A primitive's level never adapts smoothly — growth past its cell budget forces full remove+re-add; rapid size oscillation across the ±1-level band is dampened only by the two-step shrink hysteresis.
- `numBuckets()` ignoring its argument is intentional (same table size at every level) — don't "fix" call sites that pass `level`.
- `getNextGrid` mutates its `grid&` in/out parameter.

## UNKNOWN

- Values of `cellMinSize` / `maxLevelForAnchored` and the hash function (declared for SpatialHashMultiRes.cpp, which isn't part of App/include).

## Cross-links

- Instantiation: [ContactManagerSpatialHash.md](ContactManagerSpatialHash.md); required mixin on Primitives: [BasicSpatialHashPrimitive.md](BasicSpatialHashPrimitive.md); fuzzy extents input: [Primitive.md](Primitive.md) (`hasGetFirstContact`, `getFastFuzzyExtents`).
- Pair consumer: [ContactManager.md](ContactManager.md). Object pool & allocator: Base [object_pool.h.md](../../../Base/include/rbx/object_pool.h.md).
