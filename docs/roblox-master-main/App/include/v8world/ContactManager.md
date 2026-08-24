# App/include/v8world/ContactManager.h

## Purpose

Broadphase + hit-testing hub of the world: owns the `ContactManagerSpatialHash`, creates/releases Contacts for overlapping primitive pairs, tracks terrain (Voxel + Voxel2) changes to re-check mega-cluster/smooth-cluster contacts, and provides the engine's ray-cast (`getHit`) and extents-overlap queries.

## Declared API

- `class ContactManager : public Voxel::CellChangeListener, public Voxel2::GridListener`
  - Members: `ConcurrencyValidator concurrencyValidator;` (single-thread contract checking), `ContactManagerSpatialHash* spatialHash;` `Primitive* myMegaClusterPrim;` `World* world;`
  - Terrain dirty sets: `UpdatedTerrainRegionsSet` (SpatialRegion::Id, boost unordered) and `UpdatedTerrainChunksSet` (Vector3int32); scratch vectors `tempChunks/tempPrimitives`; statics `dummySurfaceNormal/dummySurfaceMaterial` used as default out-params.
  - Listener overrides: `terrainCellChanged(const Voxel::CellChangeInfo&)`, `onTerrainRegionChanged(const Voxel2::Region&)`.
  - Ray casts:
    - `Primitive* getHit(const RbxRay& worldRay, const std::vector<const Primitive*>* ignorePrim, const HitTestFilter* filter, Vector3& hitPointWorld, bool terrainCellsAreCubes = false, bool ignoreWater = false, Vector3& surfaceNormal = dummySurfaceNormal, PartMaterial& surfaceMaterial = dummySurfaceMaterial) const;` — NULL on no hit.
    - Legacy: `getHitLegacy(originDirection, ignorePrim, filter, hitPointWorld, float& distanceToHit, const float& maxSearchDepth, bool ignoreWater)`.
    - Private slow/fast paths: `getSlowHit(...)` (takes primitive array + maxDistance + stopped flag), `getFastHit(worldRay, ...)` — in-header TODO complains about argument counts.
  - Spatial queries: `getPrimitivesTouchingExtents(extents, ignore, maxCount, found)` ×2 overloads; `getPrimitivesOverlapping(const Extents&, DenseHashSet<Primitive*>&)`; `intersectingGroundPlane(check, yHeight)`; `intersectingOthers(...)` ×3; `intersectingMySimulation(Primitive*, SystemAddress, float overlapIgnored)`; `shared_ptr<const Instances> getPartCollisions(Primitive*)`.
  - Pair lifecycle: `onNewPair(Primitive*, Primitive*)` (+ CullableSceneNode overload = RBXASSERT(0)), `releasePair(...)`, `checkTerrainContact(Primitive*)`.
  - World callbacks: `onPrimitiveAdded/Removed/ExtentsChanged/GeometryChanged/Assembled(Primitive*)`, `onAssemblyMovedFromStep(Assembly&)`, `applyDeferredTerrainChanges()`, `fastClear()`, `doStats()` ("spit out hash stats").
  - Misc: `getSpatialHash()`; public member `boost::scoped_ptr<Profiling::CodeProfiler> profilingBroadphase;` `Primitive* getMegaClusterPrimitive() const;` `bool terrainCellsInRegion3(Region3) const;` `Vector3 findUpNearestLocationWithSpaceNeeded(float maxSearchDepth, const Vector3& startCenter, const Vector3& spaceNeededToCorner);`
  - Private terrain contact checks: mega-cluster water/small/big variants + `checkSmoothCluster*` + deferred apply helpers; `setUpbulletCollisionShapes(p0, p1);` *(sic: lowercase b)*; grid getters.

## Gotchas

- `getHit`'s defaulted out-params (`dummySurfaceNormal/Material`) mean callers who don't pass references silently share statics — never read them expecting per-call data.
- The `CullableSceneNode*` overloads are deliberate dead ends (assert, no-op, or return false) guarding against Graphics-side misuse.
- Terrain updates are deferred (`updatedTerrainRegions/Chunks` + `applyDeferredTerrainChanges`) — contact state can lag one step behind voxel edits.
- `concurrencyValidator` implies all calls must come from one thread at a time; crossing threads is an asserted error.

## UNKNOWN

- Exact semantics of `terrainCellsAreCubes` fast path vs smooth cells (implementation-only).

## Cross-links

- Hash: [ContactManagerSpatialHash.md](ContactManagerSpatialHash.md), [BasicSpatialHashPrimitive.md](BasicSpatialHashPrimitive.md), [TerrainPartition.md](TerrainPartition.md).
- Contacts created here: [Contact.md](Contact.md), [Buoyancy.md](Buoyancy.md), [CellContact.md](CellContact.md).
- Solver that consumes contacts: [../solver/SolverKernel.md](../solver/SolverKernel.md), [../solver/Solver.md](../solver/Solver.md).
