# Teams.cpp

## Purpose

Implements `Teams` ("Teams"), the service container of Team instances plus team assignment logic: least-populated auto-assignment, membership queries by BrickColor, per-humanoid team-color lookup for rendering, unused-color selection, and a shared-write-protected mirror list of Team children exposed via GetTeams.

## Key types and API

Descriptors:
- `func_teams("GetTeams():Instances")` — **Security::None**.
- `teams_rebalanceTeamsFunction("RebalanceTeams()")` — **Security::None**, deprecated(); BODY IS FULLY COMMENTED OUT — a no-op.

Logic:
- `isTeamGame()`: true when ANY Player has neutral==false.
- `assignNewPlayerToTeam(player)`: scans auto-assignable Team children, picks smallest membership (`getNumPlayersInTeam`), sets player teamColor + neutral=false; ties go to FIRST found (strict <); seed default brickGreen/10000 never used unless found.
- `getNumPlayersInTeam(color)`: counts non-neutral players with matching teamColor.
- `getTeamFromTeamColor(c)` first-match child scan; `getTeamFromPlayer` NULL for neutral players; `teamExists` wrapper.
- `getUnusedTeamColor()`: walks ALL BrickColors, erasing used ones via iterator erase INSIDE nested loop (iterator invalidation hazard!), asserts non-empty, random pick.
- `getTeamColorForHumanoid(humanoid)`: finds owning non-neutral player's team color3 else white.
- onChildAdded/onChildRemoving maintain the `teams` Instances mirror backing GetTeams.

## Usage / reflection touchpoints

GetTeams script-facing at Security::None. Pairs with Team.md, SpawnLocation.md, StarterPlayerService context; [Network Players](../../Network/) for player enumeration.

## Gotchas

- RebalanceTeams is dead code (commented body) despite remaining reflected + callable.
- getUnusedTeamColor erases from `vec` with an iterator held across inner-loop erases → undefined behavior when multiple teams exist (works accidentally in most builds).
- assignNewPlayerToTeam does NOT check whether the chosen team still exists after counting; O(n·m) scans per call.
