# App/include/v8datamodel/SpawnLocation.h

## Purpose

Two classes: `SpawnLocation` — creatable `BasicPartInstance` spawn pad with team/neutral logic, touch-triggered team change, forcefield duration, and enable flag; and `SpawnerService` — non-creatable service registering spawn pads and placing players (with preferred spawn name), including a static direct-spawn helper.

## Declared API

`class SpawnLocation : public DescribedCreatable<SpawnLocation, BasicPartInstance, sSpawnLocation>`
- Friend: `SpawnerService`.
- PUBLIC data members: `bool neutral; bool allowTeamChangeOnTouch; int forcefieldDuration;`
- Private: `BrickColor teamColor; bool enabled;` scoped_connection_logged `spawnerTouched`; handlers `onEvent_spawnerTouched(shared_ptr<Instance>)`, `updateSpawnerTouched()`.
- Ctor/dtor; overrides `onServiceProvider`, `onAncestorChanged(AncestorChanged&)`; inline `onAllowTeamChangeOnTouchChanged(desc) { updateSpawnerTouched(); }`.
- Descriptors: `prop_Neutral(BoundProp<bool>)`, `prop_AllowTeamChangeOnTouch(BoundProp<bool>)`, `prop_SpawnForcefieldDuration(BoundProp<int>)`.
- API: `BrickColor getTeamColor() const` / `setTeamColor(BrickColor)`; inline `bool getEnabled() const` / `void setEnabled(bool)`.

`class SpawnerService : public DescribedNonCreatable<SpawnerService, Instance, sSpawnerService>, public Service`
- Ctor/dtor; `void RegisterSpawner(SpawnLocation*)` / `UnregisterSpawner(SpawnLocation*)`.
- `SpawnLocation* GetSpawnLocation(Network::Player* player, std::string preferedSpawnName)` — note misspelled parameter `preferedSpawnName`.
- `bool SpawnPlayer(shared_ptr<ModelInstance> model, Network::Player*, std::string preferedSpawnName)`; static `void SpawnPlayer(Workspace* workspace, shared_ptr<ModelInstance> model, CoordinateFrame location, int forceFieldDuration)`.
- `void ClearContents()`; private `std::list<SpawnLocation*> spawners`.

## Gotchas

- SpawnLocation keeps three PUBLIC raw fields mirrored by BoundProps — two write paths for the same state.
- SpawnerService holds RAW SpawnLocation pointers in a list; lifetime managed via Register/Unregister on ancestor/provider events.
- Touch-based team change is connection-managed (`spawnerTouched`) and re-wired by updateSpawnerTouched when AllowTeamChangeOnTouch flips.
- Static SpawnPlayer overload bypasses service registration entirely (direct placement + forcefield duration).

## UNKNOWN

- Team-color matching rules inside GetSpawnLocation (out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/SpawnLocation.md](../../v8datamodel/SpawnLocation.md).
- Base: [BasicPartInstance.md](BasicPartInstance.md); teams: [Team.md](Team.md), [Teams.md](Teams.md); player side: Network Players docs, [Workspace.md](Workspace.md).
