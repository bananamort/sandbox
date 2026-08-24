# SpawnLocation.cpp

## Purpose

Implements TWO classes: `SpawnLocation` ("SpawnLocation", the spawn PartInstance with team/neutral/forcefield behavior, touched-based team switching, and SpawnerService registration lifecycle) and `SpawnerService` ("SpawnerService", non-archivable service holding registered spawners and implementing respawn selection + character placement with forcefield).

## Key types and API

### SpawnLocation descriptors
- `prop_SpawnForcefieldDuration("Duration")` — BoundProp int, category "Forcefield", default 10.
- `prop_Neutral("Neutral")` — BoundProp bool, category "Teams", default true.
- `prop_AllowTeamChangeOnTouch("AllowTeamChangeOnTouch")` — BoundProp bool with change notifier (onAllowTeamChangeOnTouchChanged), default false.
- `prop_TeamColor("TeamColor")` — BrickColor, category "Teams".
- `prop_Enabled("Enabled")` — bool, category_Behavior, default true; setter re-evaluates touched connection.

Behavior:
- Touched pipeline: `updateSpawnerTouched()` connects `touchedSignal` → onEvent_spawnerTouched ONLY when allowTeamChangeOnTouch AND no client present AND enabled. Handler is server-only: resolves touching character's parent → Player, applies `setTeamColor(getTeamColor())` + `setNeutral(neutral)`.
- Lifecycle: onServiceProvider registers into SpawnerService when entering Workspace-descendant state, unregisters when leaving provider; onAncestorChanged re-registers on any ancestry move (register only while under Workspace).

### SpawnerService
- Ctor sets non-archivable via propArchivable.setValue (comment: cstor-def route didn't work).
- RegisterSpawner/Unregister/ClearContents manage a raw list.
- `GetSpawnLocation(player, preferredSpawnName)`: honors player's dangerousRespawnLocation first (when no preferred name AND spawn neutral-or-team-matching AND enabled AND still under Workspace); else collects enabled spawns usable by this player (neutral OR matching teamColor when player not neutral); preferred-name match wins, else uniform RANDOM pick (`rand() % size`). NULL when none.
- `SpawnPlayer(model, player, preferredName)` overload: workspace-less → throw runtime_error("SpawnPlayer couroldn't get the workspace" [sic]); delegates to CF variant which: drops at spawn translation +7 Y ("hard-coded height… very bad" per comment), creates ForceField child + Debris expiry when duration > 0, moves via Workspace::moveToPoint UNJOIN_NO_JOIN, then rotates model primary CFrame to face spawn look vector (Y-degenerate fallback to up vector).

## Usage / reflection touchpoints

All five properties script-facing. Pairs with Team.md/Teams.md, ForceField.md, DebrisService.md, RootInstance.md (insertSpawnLocation auto-team creation) in this folder; [Network Players](../../Network/) for team storage.

## Gotchas

- Team-change-on-touch RBXASSERTs allowTeamChangeOnTouch inside handler but the guard lives in connection logic — race between flag change and pending touch event asserts in debug.
- Random selection uses unseeded rand() — deterministic per process unless seeded elsewhere.
- The +7 stud drop ignores actual character height (acknowledged TODO in source).
- GetSpawnLocation's respawn-location shortcut skips preferred-name handling entirely (only applies when name empty).
- SpawnPlayer CF variant never validates the spawn is still enabled/registered mid-spawn.
