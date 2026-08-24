# App/include/v8datamodel/Team.h

## Purpose

`Team` — creatable `Instance` representing one team: score, BrickColor identity, auto-assign flag, and an auto-color-characters BoundProp.

## Declared API

`class Team : public DescribedCreatable<Team, Instance, sTeam>`

- Protected state: `int score; BrickColor color; bool autoAssignable; bool autoColorCharacters;`
- Ctor/dtor; get/set pairs: `getScore()/setScore(int)`, `getTeamColor()/setTeamColor(BrickColor)`, `getAutoAssignable()/setAutoAssignable(bool)`.
- Descriptor: `static Reflection::BoundProp<bool> prop_AutoColorCharacters;`
- Overrides: `askSetParent(const Instance*) const` (out-of-line), inline `askAddChild {return true;}`.

## Gotchas

- Team color is BrickColor-keyed — Teams service lookups (getTeamFromTeamColor) match on it, so duplicate colors across teams are ambiguous.
- autoColorCharacters has a descriptor but no getter/setter here — reflection-only property.

## UNKNOWN

- askSetParent rules (presumably requires the Teams container).

## Cross-links

- Implementation: [App/v8datamodel/Team.md](../../v8datamodel/Team.md).
- Container: [Teams.md](Teams.md); spawn integration: [SpawnLocation.md](SpawnLocation.md).
