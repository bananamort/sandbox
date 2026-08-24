# PathfindingService.cpp

## Purpose

Implements `PathfindingService` (place-wide voxel-grid A* pathfinding) and its result object `Path`. Voxels the world into `Voxel::OccupancyChunk`s (16³ cells derived from physics ContactManager + terrain), runs A* over cell centers with walk/fall/diagonal costs, optionally smooths the polyline, and executes work incrementally on a dedicated throttled `PathfindingJob`. `Path` instances are returned to scripts with Status + waypoints.

## Key types and API

Reflection (`Security::` tiers verbatim):
- `prop_EmptyCutoff("EmptyCutoff")` — float 0..1 (setter throws std::runtime_error "Value is outside expected range"); default 40/255.
- `func_computeRawPathAsync` → "ComputeRawPathAsync(start, finish, maxDistance)" yield, **Security::None**.
- `func_computeSmoothPathAsync` → "ComputeSmoothPathAsync(start, finish, maxDistance)" yield, **Security::None**.
- `func_checkOcclusionAsync` → Path "CheckOcclusionAsync(startPoint:int)" yield, **Security::None**.
- `prop_Points` → Path bound func "GetPointCoordinates():Array", **Security::None**.
- `prop_PathStatus("Status")` — enum PathStatus on Path, read-only (NULL setter).
- Enum `PathStatus`: Success / ClosestNoPath / ClosestOutOfRange / FailStartNotEmpty / FailFinishNotEmpty.

Tunables (all DYNAMIC_FASTINTVARIABLE): `PathfindingMaxDistance(512)`, `PathfindingJobRunsPerSecond(10)`, `PathfindingChunksPerInvokation(10)`, `PathfindingAgeToCollectChunks(1000)`, `PathfindingCollectPeriod(100)`, `PathfindingDefaultBucketNum(2048)`, `PathfindingVerticalChunkClamp(1)`, `PathfindingSmoothIterations(5)`, `PathfindingAverageWindow(7)`. Logs: LOGVARIABLE PathfindingDetail, PathfindingPerf.

`PathfindingJob : DataModelJob` ("PathfindingJob", Write, cyclicExecutive=true, standard sleep at desired Hz) → `executeThrottledRequests()` each step: increments frame counter, collects aged chunks every CollectPeriod frames, then pops queued requests within a chunk-voxelization budget of ChunksPerInvokation (do-while always executes ≥1 request per tick).

Core flow (`computePathAsync` shared by both Async entries):
1. GA trackEvent once per process (boost::once_flag) "PathfindingService".
2. Validation errors via errorFunction: "MaxDistance is too large" (> DFInt), "Start or Finish are outside of supported range" (beyond ±kMaxWorldCoordinate = (int16max−2·chunkXZ)·cellSize).
3. Lazy init on first call: create+register job; register `coarsePrimitiveMovement` callback on ContactManagerSpatialHash; connect terrain listener (smooth grid vs voxel grid by `MegaClusterInstance::isSmooth`). Torn down in `onServiceProvider` (removeBlocking job).
4. Requests needing voxelization are queued (`scheduleRequest`); clean ones execute inline via resumeFunction.

A* (`computePath`): nudges start/finish cells to empty neighbors (`adjustCell` sideways-by-dot-product, then up, then up-sideways; failure ⇒ FailFinish/FailStartNotEmpty). Node expansion: empty below ⇒ fall (cost 1); solid below ⇒ walk 4 sides (cost 1) or step-up when side solid but above empty; diagonals (cost √2) allowed only when BOTH adjacent orthogonals share the same open state. Termination: finish reached (Success), node beyond maxDistance (ClosestOutOfRange using best-so-far closestCell), or open set drained (ClosestNoPath). Waypoints: raw mode uses cell centers (+0.5); smooth mode converts via `Voxel::worldSpaceToCellSpace` then runs `DFInt::PathfindingSmoothIterations` passes of windowed moving-average smoothing that re-verifies floor/ceil/cellBelow solidity and pins Y.

Invalidation: `markChunksDirty` over hashed extents from `coarsePrimitiveMovement` (SKIPS humanoid parts via `PartCookie::IS_HUMANOID_PART`; marks old extents too on hash-level change), `terrainCellChanged` (block change), `onTerrainRegionChanged` (Voxel2 region sweep).

`Path` class: ctor(service weak_ptr, status), `addPoint`, `reverse()`, `checkOcclusionAsync` (validates startPoint, voxelize-checks the point bounding box, returns first occluded index or −1; errors "PathfindingService no longer exists"/"Start point value is invalid"), `getPointCoordinates` maps stored cell-space points back via `Voxel::cellSpaceToWorldSpace`.

## Usage / reflection touchpoints

Fully script-facing at Security::None (ComputeRawPathAsync era, pre-Modern pathfinder). Consumes MegaCluster.md (terrain grids) and PartCookie.md in this folder; Voxel/Voxel2 grids and ContactManager spatial-hash live in engine libs documented under [Base](../../Base/) task scheduler docs (job runs via DataModelJob/TaskScheduler).

## Gotchas

- Smooth-path results are returned in CELL space and only converted to world coordinates by GetPointCoordinates — mixing raw/smooth coordinate handling is caller-sensitive.
- Humanoid movement never dirties chunks — paths can go stale around moving characters by design.
- The do-while request loop ignores the budget for the first popped request each tick (executes even after budget exhausted).
- `isSolid` treats unvoxelized regions as OUTSIDE (not EMPTY) — A* expansion across uncomputed borders yields OUTSIDE which matches neither fall/walk branch, halting exploration there.
- EmptyCutoff is snapshotted per-request as `(unsigned char)(emptyCutoff*255)` — later property changes don't affect queued requests already built... (queued CreatePathRequest copies capture it at enqueue time).
- Single-entry chunk cache (`lastChunkId/lastChunk`) invalidated wholesale during collection.
- UNKNOWN: exact OccupancyChunk dimensions/kVoxelChunkSize constants (Voxel headers); Path::getPoints accessor used by OcclusionRequest lives header-side.
