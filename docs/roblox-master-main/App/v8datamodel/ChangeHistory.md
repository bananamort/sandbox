# ChangeHistory.cpp

## Purpose

Implements `ChangeHistoryService` ("ChangeHistoryService") — Studio's undo/redo engine. Records instance create/delete/property-change deltas AND full terrain snapshots (classic voxel chunks + Voxel2 smooth boxes) into named Waypoints, merges/trims them against count+memory budgets, replays them forward (Redo) and backward (Undo, with time-travel reconstruction for deletes), and integrates Run-mode transitions under three runtime undo behaviors.

## Key types and API

Descriptors — every script surface is **Security::Plugin**:
- BoundFuncs: `SetEnabled(state)`, `SetWaypoint(name)` → requestWaypoint2, `ResetWaypoints()`, `Redo()` → playLua, `Undo()` → unplayLua, `GetCanUndo()` → canUnplay2, `GetCanRedo()` → canPlay2 (Tuple {bool[, name]}).
- Events: `OnUndo(waypoint)`, `OnRedo(waypoint)` on undoSignal/redoSignal; internal `waypointChangedSignal`.

Enum "RuntimeUndoBehavior": Aggregate (default static), Snapshot, Hybrid.

Flags: `FASTFLAGVARIABLE(TeamCreate9938FixEnabled, true)` (lets Replicate items satisfy parent-property undo). LOGVARIABLE ChangeHistoryService.

Core structures:
- `Item` — one instance's delta: Action {None, Create, Change, Delete, Replicate}, parent ptr, Properties map {descriptor→Variant}, ClusterCells per SpatialRegion packed as `(cellIndex<<16)|(material<<8)|detail`, SmoothClusterCells per 8³ chunk (kChunkSizeLog2=3). Property capture filters: skips read-only/write-only/non-XmlWrite; non-replicated props EXCEPT `PartOperation::desc_ChildData` and `PartOperation::prop_CollisionFidelity`.
- `Waypoint` — Items keyed by raw Instance*, order-stamped; play() applies in insertion order, unplay() in REVERSE then re-applies CFrames ("hack because the CFrame property can be constrained by the physics engine"); absorb() folds a later waypoint in.
- Undo reconstruction: `unplayDelete` rewinds to first Create/Replicate item, replays it + intervening Changes, then restores properties captured at delete time (Scripts/ModuleScripts get source captured via `getScriptSourceDescriptorIfScript` since source changes aren't recorded); `unplayProperty` walks back to first prior value (parent special-case); `unplayClusterData` per-cell rewind defaulting to empty-cell/Water.

Behavior:
- attach(): records FULL initial world via visitDescendants + resetBaseWaypoint("base" merged into single waypoint); hooks dataModel descendantAdded/Removing/itemChangedSignal.
- setWaypoint(name): trims redos past playWaypoint, merges oldest while >maxWaypoints or >maxMemoryUsage; requestWaypoint cleans CSGDictionaryService/NonReplicatedCSGDictionaryService first.
- checkSettingWaypoint during RunState: Aggregate→Reject, Snapshot/Hybrid→Accept.
- isReplicatedChange (Security identity Replicator_) routes records into EXISTING waypoints instead of recording — property/cell changes scan waypoints NEWEST→OLDEST for an item already holding that descriptor (terrain falls back to a forced base-waypoint update), while new instances record straight into the BASE waypoint; Team Create sync keeps history consistent.
- Camera property changes record ONLY Name/Parent.
- Run transitions: STOPPED/PAUSED → setRunWaypoint (reports missed physics CFrame/Velocity/RotVelocity by diffing waypoints when not Snapshot); RUNNING from STOPPED marks runStartWaypoint; reset() unplays back to it.
- Stats: ChangeHistoryStatsItem publishes "Data Size"/"Stack Size" under StatsService.

## Usage / reflection touchpoints

Studio-plugin API ([Selection](Selection.md) auto-selects modified parts after each play/unplay); terrain via [MegaCluster](MegaCluster.md) grids; CSG dictionary cleanup with [CSGDictionaryService](CSGDictionaryService.md)/[NonReplicatedCSGDictionaryService](NonReplicatedCSGDictionaryService.md).

## Gotchas

- The FIRST waypoint can never be undone (`getUnplayWaypoint` refuses begin()) — that's the base snapshot.
- Undo of a delete resurrects the instance by replaying its ORIGINAL creation properties then overwriting with delete-time captured ones — non-captured props revert to creation values, not pre-delete values.
- Waypoints hold raw Instance* keys — instances must stay alive via shared_ptr inside Item or history corrupts.
- maxWaypoints/maxMemoryUsage constants live header-side; merge pressure silently collapses oldest history.
