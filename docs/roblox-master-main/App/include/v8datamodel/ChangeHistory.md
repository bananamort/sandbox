# App/include/v8datamodel/ChangeHistory.h

## Purpose

`ChangeHistoryService` (INTERNAL service) — Studio undo/redo engine. Records `Waypoint`s of instance/property/terrain deltas against the DataModel, maintains play/unplay cursors plus a run-start reset marker, enforces waypoint count/memory caps, and supports three runtime-undo behaviors while the game is running.

## Declared API

`class ChangeHistoryService : public DescribedCreatable<ChangeHistoryService, Instance, sChangeHistoryService, ClassDescriptor::INTERNAL>, public Service, public Voxel::CellChangeListener, public Voxel2::GridListener`

- Caps (static const): `minWaypoints = 3`, `maxWaypoints = 250`, `maxMemoryUsage = 250 * 1024 * 1024`.
- `enum RuntimeUndoBehavior { Aggregate, Snapshot, Hybrid };` — comments: Aggregate "Don't allow waypoints while running... part of the reset waypoint"; Snapshot "take a snapshot of positions and velocities"; Hybrid "ignore unrelated position and velocity changes". Static member `runtimeUndoBehavior`.
- Waypoint requests: `static void requestWaypoint(const char* name, const Instance* context);` `void requestWaypoint(const char* name);` `void requestWaypoint2(std::string name)` (forwards); `resetBaseWaypoint()`; `clearWaypoints()`; enable flag `setEnabled(bool)/isEnabled()`.
- Undo/redo queries: `bool getPlayWaypoint(std::string& name, int steps = 0)` / `getUnplayWaypoint(...)`; sugar `canPlay()/canUnplay()`; Lua tuple forms `shared_ptr<const Reflection::Tuple> canUnplay2()/canPlay2();` ("returns a tuple: bool state, [string name]").
- Execution: `play()/playLua()/unplay()/unplayLua()` — source comment: "TODO: rename play-->redo unplay-->undo???"; reset support `bool isResetEnabled() const; void reset();`
- Stats/signals: `int getWaypointDataSize()` (`dataSize`), `int getWaypointCount()`; signals `waypointChangedSignal<void()>`, `undoSignal<void(std::string)>`, `redoSignal<void(std::string)>`; Studio hook `boost::function<void(boost::function<void()>, std::string)> withLongRunningOperation;` ("to show progress dialog in studio").
- Terrain access: `MegaClusterInstance* getTerrain() const;` (held `shared_ptr<MegaClusterInstance>`).
- Private machinery: nested `class Item; class Waypoint;` waypoint list typedef'd to std::list ("must be a list and not a vector because we maintain iterators after reallocs") with iterators `playWaypoint/unplayWaypoint/runStartWaypoint`, flags `playing/enabled`; connections `itemAddedConnection/itemRemovedConnection/itemChangedConnection/runTransitionConnection`; handlers `onItemAdded/onItemRemoved/onItemChanged(shared_ptr<Instance>, const Reflection::PropertyDescriptor*)`, `isRecordable(Instance*)`, terrain hooks `terrainCellChanged(const Voxel::CellChangeInfo&)`, `onTerrainRegionChanged(const Voxel2::Region&)`, low-level `setCell(chunkPos, cellInChunk, Voxel::Cell detail, Voxel::CellMaterial material)`; bookkeeping `attach()/dettach()/trimWaypoints()/mergeFirstTwoWaypoints()/computeDataSize()`, `CheckResult {Accept, Reject} checkSettingWaypoint()`, `onRunTransition(RunTransition)`, `setWaypoint(const char*)`, `setRunWaypoint()`, `reportMissedPhysicsChanges(shared_ptr<Instance>)`.

## Gotchas

- play/unplay naming is inverted-feeling vs undo/redo (the TODO acknowledges it).
- Waypoints record terrain via both Voxel1 CellChangeInfo and Voxel2 Region callbacks — two terrain generations must stay covered.
- 250 MB memory cap enforced by `trimWaypoints()` + `computeDataSize()`.
- `requestWaypoint(name, context)` static form exists for callers without service lookup.

## UNKNOWN

- What a serialized Waypoint captures exactly (nested classes defined in .cpp — see [ChangeHistory.md](../../v8datamodel/ChangeHistory.md)).

## Cross-links

- Implementation: [App/v8datamodel/ChangeHistory.md](../../v8datamodel/ChangeHistory.md).
- Related services: [UndoRedo.md](UndoRedo.md), [DataModel.md](DataModel.md), terrain [MegaCluster.md](MegaCluster.md).
