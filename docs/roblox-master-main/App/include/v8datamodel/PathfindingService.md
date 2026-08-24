# App/include/v8datamodel/PathfindingService.h

## Purpose

`PathfindingService` — INTERNAL_LOCAL creatable service computing voxel-grid A* paths: maintains a `Voxel::ChunkMap<OccupancyChunk>` + `Voxelizer`, listens to terrain changes (Voxel CellChangeListener, Voxel2 GridListener) and coarse primitive movement (ContactManagerSpatialHash callback), throttles path requests through a job, and returns `Path` instances. Also defines `RBX::Path` (RUNTIME_LOCAL non-creatable result object with waypoint list + status).

## Declared API

`class PathfindingService : public DescribedCreatable<PathfindingService, Instance, sPathfindingService, Reflection::ClassDescriptor::INTERNAL_LOCAL>, public Service, public ContactManagerSpatialHash::CoarseMovementCallback, public Voxel::CellChangeListener, public Voxel2::GridListener`

- Public state: `float emptyCutoff;` (public data member!) with `getEmptyCutoff()/setEmptyCutoff(float)`.
- Async entry points (all take resume/error boost::functions):
  - `void computePathAsync(Vector3 start, Vector3 finish, float maxDistance, bool isSmooth, resume(shared_ptr<Instance>), error(std::string))`
  - `void computeRawPathAsync(Vector3, Vector3, float, resume, error)`
  - `void computeSmoothPathAsync(Vector3, Vector3, float, resume, error)`
- `enum SolidState {EMPTY, SOLID, OUTSIDE}`; `int checkPoints(int startPoint, const std::vector<Vector3>& points, unsigned char emptyCutoff)`.
- Invalidation hooks: `void markChunksDirty(const ExtentsInt32&)`, `void coarsePrimitiveMovement(Primitive*, const UpdateInfo&) override`, `void terrainCellChanged(const Voxel::CellChangeInfo&) override`, `void onTerrainRegionChanged(const Voxel2::Region&) override`.
- Request queue: `void executeThrottledRequests()`, `int countOrComputeDirtyChunks(startCell, finishCell, float maxDistance, bool compute)`, `void scheduleRequest(const shared_ptr<PathfindingRequest>&)`.
- `struct PathfindingRequest { Vector3int16 startCell, finishCell; int maxDistance; error fn; virtual void execute(PathfindingService*) = 0; virtual ~PathfindingRequest(); }`.
- Smoothing: `void smoothPath(std::vector<Vector3>& points, unsigned char emptyCutoff, int smoothWindow)`.
- Protected/private: `onServiceProvider` override; `shared_ptr<PathfindingJob> job`; `DoubleEndedVector<shared_ptr<PathfindingRequest>> throttledRequests`; `CreatePathRequest` struct; `Node` struct (pos/parent/totalPath/closed + open-set iterators); pool-allocated typedefs `NodesByPos` (boost::unordered_map with fast_pool_allocator, null_mutex) and `OpenNodesByWeight` (std::multimap<float, NodesByPos::iterator>); `struct PathfindingState` (addOpenNode/popTopOpenNode/checkOpenNodesCounts); `isSolid(pos, cutoff)` → SolidState; `computePath(CreatePathRequest&)`; chunk LRU bits (`collectOldChunks`, `unsigned currentFrameNum`, `lastChunk/lastChunkId`, `getChunkById`); cell adjusters `adjustCell/adjustCellSideways`.

`class Path : public DescribedNonCreatable<Path, Instance, sPath, Reflection::ClassDescriptor::RUNTIME_LOCAL>`
- `typedef enum { Success=0, ClosestNoPath=1, ClosestOutOfRange=2, FailStartNotEmpty=3, FailFinishNotEmpty=4 } PathStatus;`
- `Path(weak_ptr<PathfindingService> service, PathStatus status)`; `void addPoint(const Vector3&)`; `shared_ptr<const Reflection::ValueArray> getPointCoordinates()`; `void checkOcclusionAsync(int startPoint, resume(void(int)), error(std::string))`; `const std::vector<Vector3>& getPoints()`; `void reverse()`; `PathStatus getStatus() const`; private `OcclusionRequest` struct + `status` + weak service backref.

## Gotchas

- `emptyCutoff` is a PUBLIC member on a service — anyone can mutate the occupancy threshold mid-flight without going through setEmptyCutoff.
- A* containers use boost `fast_pool_allocator` with `null_mutex` — fine only because pathfinding is single-threaded per service; do not share across threads.
- Node stores live iterators into both maps (`itWeight`) — erasing from either map invalidates node bookkeeping; classic invalidation hazard when editing.
- Paths are RUNTIME_LOCAL and hold a weak_ptr to their creating service — occlusion requests die with the service.

## UNKNOWN

- Concrete dirty-chunk accounting in `countOrComputeDirtyChunks` (out-of-line).
- Relationship between `maxDistance` cells vs world units at call boundary.

## Cross-links

- Implementation: [App/v8datamodel/PathfindingService.md](../../v8datamodel/PathfindingService.md).
- Terrain sources: [TerrainRegion.md](TerrainRegion.md), voxel layer under App/include/voxel*; movement source: Workspace physics ([Workspace.md](Workspace.md)).
