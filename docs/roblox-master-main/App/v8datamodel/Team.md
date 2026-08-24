# Team.cpp

## Purpose

Implements `Team` ("Team"), one team entry under the Teams service: TeamColor (BrickColor), AutoAssignable flag, deprecated Score and AutoColorCharacters. Parenting restricted to Teams instances.

## Key types and API

Descriptors (category_Data, no security tier ⇒ default):
- `prop_Color("TeamColor")` — BrickColor, default brickWhite.
- `prop_AutoAssignable("AutoAssignable")` — bool, default true.
- `prop_Score("Score")` — int default 0, marked **deprecated()**.
- `Team::prop_AutoColorCharacters("AutoColorCharacters")` — BoundProp bool default true, marked **deprecated()**.

All setters change-tracked raises. `askSetParent`: only Teams parents accepted.

## Usage / reflection touchpoints

Fully script-facing properties. Consumers: Teams.md queries, SpawnLocation.md team matching, RootInstance.md auto-creation ("<Color> Team"), [Network Player](../../Network/) teamColor storage.

## Gotchas

- Score/AutoColorCharacters remain settable but flagged deprecated — no engine consumer in this TU.
- Team uniqueness by color is enforced nowhere here (callers check teamExists).
