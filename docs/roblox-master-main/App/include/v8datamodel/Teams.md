# App/include/v8datamodel/Teams.h

## Purpose

`Teams` — PERSISTENT_HIDDEN creatable service container for `Team` instances: team assignment/rebalancing for joining players, lookups by BrickColor or player, player counts, and humanoid team-color resolution. Maintains a copy-on-write teams list via child add/remove hooks.

## Declared API

`class Teams : public DescribedCreatable<Teams, Instance, sTeams, Reflection::ClassDescriptor::PERSISTENT_HIDDEN>, public Service`

- Ctor/dtor.
- Player/team management:
  - `void assignNewPlayerToTeam(Network::Player* p)`
  - `int getNumPlayersInTeam(BrickColor color)`
  - `bool teamExists(BrickColor color)`
  - `bool isTeamGame()`
  - `void rebalanceTeams()`
- Lookups: `BrickColor getUnusedTeamColor()`, `Team* getTeamFromTeamColor(BrickColor c)`, `Team* getTeamFromPlayer(Network::Player* p)`, `shared_ptr<const Instances> getTeams()` (inline over copy_on_write_ptr), `G3D::Color3 getTeamColorForHumanoid(Humanoid*)`.
- Overrides: `onChildAdded/onChildRemoving(Instance*)`; inline `askAddChild {return fastDynamicCast<Team>(child) != NULL;}` — Teams children must be Team instances.

## Gotchas

- Per project recon (certified M–Z findings): **`getUnusedTeamColor()` has an iterator-invalidation UB bug** — documented in the certified implementation doc; do not "fix" from the header alone.
- Only Team children allowed (askAddChild).
- Team list is copy-on-write — readers get stable snapshots while writers mutate.

## UNKNOWN

- isTeamGame criteria (≥2 teams? autoAssignable count?) out-of-line.

## Cross-links

- Implementation: [App/v8datamodel/Teams.md](../../v8datamodel/Teams.md).
- Members: [Team.md](Team.md); spawn integration: [SpawnLocation.md](SpawnLocation.md); players: Network Players docs.
